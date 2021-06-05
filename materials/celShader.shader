shader_type spatial;
render_mode cull_back, specular_disabled;

uniform float divisions = 2;
uniform vec4 col = vec4(0.1,0.1,0.1,1.0);

void vertex() {
	COLOR = col;
}

void fragment () {
	ALBEDO = col.rgb;
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
		DIFFUSE_LIGHT += ALBEDO / 1.2 * (dotProd * LIGHT_COLOR);
		DIFFUSE_LIGHT = floor(DIFFUSE_LIGHT * divisions) / divisions;
	}
	if (col.a == 1.0) {
		SPECULAR_LIGHT -= vec3(dot(NORMAL, ATTENUATION));
		if ((SPECULAR_LIGHT.r) > -0.1) {
			DIFFUSE_LIGHT = vec3(0.0);
		}
	} else {
		DIFFUSE_LIGHT += mix(DIFFUSE_LIGHT, ALBEDO + LIGHT_COLOR * a, 0.4);
		DIFFUSE_LIGHT = floor(DIFFUSE_LIGHT * divisions) / divisions;
	}
}