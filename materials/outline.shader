shader_type spatial;
render_mode unshaded;

uniform float thickness;
uniform float depthDetection;
uniform bool whiteOutline;

void fragment() {
	vec2 size = vec2(1024,1024);
	vec2 uv = SCREEN_UV;   
    
    vec2 widthStep = vec2(thickness / size.x, 0.0);
    vec2 heightStep = vec2(0.0, thickness / size.y);
    vec2 widthHeightStep = vec2(thickness / size.x, thickness / size.y);
    vec2 widthNegativeHeightStep = vec2(thickness / size.x, -(thickness / size.y));
	
	//----
	float bottomLeftIntensity = textureLod(DEPTH_TEXTURE, uv.xy - widthNegativeHeightStep, 0.0).r;
	float bLDepth = (INV_PROJECTION_MATRIX * vec4(uv*2.0-1.0,bottomLeftIntensity*2.0-1.0,1.0)).w;
	
    float topRightIntensity = textureLod(DEPTH_TEXTURE, uv.xy + widthNegativeHeightStep, 0.0).r;
	float tRDepth = (INV_PROJECTION_MATRIX * vec4(uv*2.0-1.0,topRightIntensity*2.0-1.0,1.0)).w;
	
    float topLeftIntensity = textureLod(DEPTH_TEXTURE, uv.xy - widthHeightStep, 0.0).r;
	float tLDepth = (INV_PROJECTION_MATRIX * vec4(uv*2.0-1.0,topLeftIntensity*2.0-1.0,1.0)).w;
	
    float bottomRightIntensity = textureLod(DEPTH_TEXTURE, uv.xy + widthHeightStep, 0.0).r;
	float bRDepth = (INV_PROJECTION_MATRIX * vec4(uv*2.0-1.0,bottomRightIntensity*2.0-1.0,1.0)).w;
	
    float leftIntensity = textureLod(DEPTH_TEXTURE, uv.xy - widthStep, 0.0).r;
	float lDepth = (INV_PROJECTION_MATRIX * vec4(uv*2.0-1.0,leftIntensity*2.0-1.0,1.0)).w;
	
    float rightIntensity = textureLod(DEPTH_TEXTURE, uv.xy + widthStep, 0.0).r;
	float rDepth = (INV_PROJECTION_MATRIX * vec4(uv*2.0-1.0,rightIntensity*2.0-1.0,1.0)).w;
	
    float bottomIntensity = textureLod(DEPTH_TEXTURE, uv.xy + heightStep, 0.0).r;
	float bDepth = (INV_PROJECTION_MATRIX * vec4(uv*2.0-1.0,bottomIntensity*2.0-1.0,1.0)).w;
	
    float topIntensity = textureLod(DEPTH_TEXTURE, uv.xy - heightStep, 0.0).r;
	float tDepth = (INV_PROJECTION_MATRIX * vec4(uv*2.0-1.0,topIntensity*2.0-1.0,1.0)).w;
	//-----
	
    float h = -tLDepth - depthDetection * tDepth - tRDepth + bLDepth + depthDetection * bDepth + bRDepth;
    float v = -bLDepth - depthDetection * lDepth - tLDepth + bRDepth + depthDetection * rDepth + tRDepth;
    
    float mag = (length(vec2(h * depthDetection, v * depthDetection)));
	
	if (whiteOutline) {
		if (mag > 0.1) {
			mag = 1.0;
		} else {
			mag = 0.0;
		}
	} else {
		if (mag > 0.1) {
			mag = 0.0;
		} else {
			mag = 1.0;
		}
	}
	
	vec3 m = vec3(mag,mag,mag);	
	ALBEDO = mix(textureLod(SCREEN_TEXTURE,SCREEN_UV,0.0).rgb, m, 0.3);
}