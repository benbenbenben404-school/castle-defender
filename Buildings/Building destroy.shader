shader_type spatial;
render_mode blend_mix,depth_draw_opaque,cull_back,diffuse_burley,specular_schlick_ggx;
uniform sampler2D NOISE_PATTERN;
uniform float NOISE_THRESHOLD;

uniform vec4 albedo : hint_color;
uniform sampler2D texture_albedo : hint_albedo;
uniform float specular;
uniform float metallic;
uniform float roughness : hint_range(0,1);
uniform float point_size : hint_range(0,128);
uniform vec3 uv1_scale;
uniform vec3 uv1_offset;
uniform vec3 uv2_scale;
uniform vec3 uv2_offset;
void fragment(){
	vec2 base_uv = UV;
	vec4 albedo_tex = texture(texture_albedo,base_uv);
	ALBEDO = albedo.rgb * albedo_tex.rgb;
	METALLIC = metallic;
	ROUGHNESS = roughness;
	SPECULAR = specular;
	float noiseValue = abs((texture(NOISE_PATTERN, (CAMERA_MATRIX*vec4(VERTEX,1.0)).yz*0.1).x)*2.0-1.0);
	if (noiseValue <NOISE_THRESHOLD){
		ALBEDO = vec3(0,0,0);
	} 
	
	//ALBEDO = vec3(noiseValue,noiseValue,noiseValue);
}