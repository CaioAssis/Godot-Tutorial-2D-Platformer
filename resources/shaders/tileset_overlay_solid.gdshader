shader_type canvas_item;

uniform vec4 tileset_ref_color: source_color;
uniform sampler2D overlay_tex: repeat_enable, filter_nearest;
uniform float scale = 0.01;
varying vec2 world_position;

void vertex(){
	world_position = (MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).xy;
}

void fragment(){
	vec4 frag_sample = texture(TEXTURE, UV);
	vec4 overlay_color = texture(overlay_tex, world_position * scale);
	float apply = distance(frag_sample.rgb, tileset_ref_color.rgb) < 0.0001 ? 1.0 : 0.0; 
	float overlay_mix = apply * overlay_color.a;
	vec4 result = mix(frag_sample, overlay_color, overlay_mix);
	result.a = frag_sample.a;
	COLOR = result;
}