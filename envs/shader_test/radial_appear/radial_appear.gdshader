shader_type canvas_item;

uniform float fade : hint_range(0.0, 1.0, 0.05) = 0.0;

void fragment() {
	vec4 tex = texture(TEXTURE, UV); // guarda frag original
	vec2 center = vec2(0.5, 0.5); // encontra centro da img
	vec2 vec = UV - center;

	float angle = atan(vec.y, vec.x) / (2.0*PI) + 0.5; // atan = arch tangent

	float progress = step(angle, fade); // step(edge, x), retorna 0.0 se x < edge e 1.0 se x >= edge
	
	COLOR.rgb = tex.rgb; // poe na saida o rgb original
	COLOR.a = tex.a * progress; // pega o progresso do radial
}
