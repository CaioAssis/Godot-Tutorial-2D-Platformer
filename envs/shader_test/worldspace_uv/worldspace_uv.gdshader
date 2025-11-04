shader_type canvas_item;

uniform float tile_size: hint_range(0, 1000, 1) = 100;
uniform float uv_scale: hint_range(0.0, 5.0, 0.1) = 1.0;

varying vec2 world_uv;

//nao esquecer de ligar repeat

void vertex() {
	world_uv = (MODEL_MATRIX * vec4(VERTEX.xy, 0.0, 1.0)).xy / tile_size;
}

void fragment() {
	COLOR = texture(TEXTURE, world_uv * uv_scale);
}

