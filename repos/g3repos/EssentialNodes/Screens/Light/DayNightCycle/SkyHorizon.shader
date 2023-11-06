shader_type canvas_item;

uniform vec4 sky_color: hint_color = vec4(1.0);
uniform vec4 horizon_color: hint_color = vec4(vec3(0.48),1.0);

uniform float horizon_top_height = 0.35;
uniform float horizon_bottom_height = 0.4;

float gradient(float y){
	return mix(0.0, 1.0, y);
}

void fragment(){
	// Only the top half of the shader is shown above the 3D horizon.
	float compressed_y = smoothstep(horizon_top_height, horizon_bottom_height, UV.y);
	
	vec3 sky = mix(sky_color.xyz, horizon_color.xyz, vec3(compressed_y));
	COLOR = vec4(sky, 1.0);
}