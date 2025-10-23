shader_type canvas_item;

uniform int numberOfColors : hint_range(0, 12);
uniform vec4 modulate : source_color;
uniform vec4 C1 : source_color;
uniform vec4 C2 : source_color;
uniform vec4 C3 : source_color;
uniform vec4 C4 : source_color;
uniform vec4 C5 : source_color;
uniform vec4 C6 : source_color;
uniform vec4 C7 : source_color;
uniform vec4 C8 : source_color;
uniform vec4 C9 : source_color;
uniform vec4 C10 : source_color;
uniform vec4 C11 : source_color;
uniform vec4 C12 : source_color;

void fragment(){
	vec4 referenceColors[12];
	referenceColors[0] = C1;
	referenceColors[1] = C2;
	referenceColors[2] = C3;
	referenceColors[3] = C4;
	referenceColors[4] = C5;
	referenceColors[5] = C6;
	referenceColors[6] = C7;
	referenceColors[7] = C8;
	referenceColors[8] = C9;
	referenceColors[9] = C10;
	referenceColors[10] = C11;
	referenceColors[11] = C12;
	
	if(numberOfColors != 0){
		vec4 textureColor = texture(TEXTURE, UV);
		int index = int(floor(textureColor.r * float(numberOfColors)));
		index = clamp(index, 0, numberOfColors - 1);
		COLOR.rgb = referenceColors[index].rgb;
		COLOR.a = textureColor.a;
		COLOR *= modulate;
	}
}