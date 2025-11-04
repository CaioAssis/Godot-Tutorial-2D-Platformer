shader_type canvas_item;

uniform float fade : hint_range(0.0, 1.0, 0.05) = 0.0;

void fragment() {
	vec4 tex = texture(TEXTURE, UV); // guarda frag original
	vec2 center = vec2(0.5, 0.5); // encontra centro da img
	float dist = length(UV - center); //guarda a distancia do frag ao centro
	
	float progress = step(dist, fade); // step(edge, x), retorna 0.0 se x < edge e 1.0 se x >= edge
	
	COLOR.rgb = tex.rgb; // poe na saida o rgb original
	COLOR.a = tex.a * progress; // pega o progresso do radial
}
