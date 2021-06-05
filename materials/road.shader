shader_type spatial;
render_mode cull_back;

uniform vec2 u_resolution = vec2(180,180);
uniform vec4 col;
uniform sampler2D t;
uniform float scaleAdjustY = 0.0;
uniform float scaleAdjustX = 0.0;
uniform float translateY = 0.0;
uniform float translateX = 0.0;

vec3 hash3( vec2 p )
{
    vec3 q = vec3( dot(p,vec2(127.1,311.7)), 
				   dot(p,vec2(269.5,183.3)), 
				   dot(p,vec2(419.2,371.9)) );
	return fract(sin(q)*43758.5453);
}

float iqnoise( in vec2 x, float u, float v )
{
    vec2 p = floor(x);
    vec2 f = fract(x);
		
	float k = 1.0+63.0*pow(1.0-v,4.0);
	
	float va = 0.0;
	float wt = 0.0;
    for( int j=-2; j<=2; j++ )
    for( int i=-2; i<=2; i++ )
    {
        vec2 g = vec2( float(i),float(j) );
		vec3 o = hash3( p + g )*vec3(u,u,1.0);
		vec2 r = g - f + o.xy;
		float d = dot(r,r);
		float ww = pow( 1.0-smoothstep(0.0,3.144,sqrt(d)), k );
		va += o.z*ww;
		wt += ww;
    }
	
    return va/wt;
}

void vertex() {
	COLOR = col;
}

void fragment () {
	vec3 view = (INV_PROJECTION_MATRIX * vec4(VERTEX, 1.0)).xyz;
	float d = distance(view, VERTEX);
	
	vec2 uv = (UV * 100000.0) / u_resolution.xy;
    vec2 p = vec2(2.7,0.001);
	float f = iqnoise(12.0*uv, p.x, p.y );
	vec2 v = vec2(UV.y * scaleAdjustY + translateY, UV.x * scaleAdjustX + translateX);
	vec4 imgCol = texture(t,v);
	vec3 c = mix(imgCol.rgb, col.rgb, 0.5);
	if (UV.x < 0.502 && UV.x > 0.498) {
		c = mix(imgCol.rgb, vec3(0.5,0.5,0.0), 0.5);
	}	else {
		c = mix(imgCol.rgb, col.rgb, 0.5);
	}
	ALBEDO = c;
	METALLIC = f/(d/3.0);
}

//IMPORTANT NOTE! 
//As of Godot 3.0, there are no fallthrough scenarios in the fragment program to set default values 
//when a light shader is in use. The light_compute function runs once per spot light, so if a light shader 
//sets the inout values statically the results will only show the last light affecting the material.
//In order to see the effects of multiple lights on a material, you must add the results from the previous call.
//https://github.com/godotengine/godot/blob/master/drivers/gles3/shaders/scene.glsl
void light() {
	float a = dot(NORMAL, ATTENUATION);
	float dotProd = dot(NORMAL, LIGHT);
	if (dotProd > 0.0) {
		DIFFUSE_LIGHT += ALBEDO / 1.5 * (dotProd * LIGHT_COLOR);
	}
	SPECULAR_LIGHT -= vec3(dot(NORMAL, ATTENUATION));
	if ((SPECULAR_LIGHT.r) > -0.1) {
		DIFFUSE_LIGHT = vec3(0.0);
	}
}
