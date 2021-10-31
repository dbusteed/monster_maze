shader_type canvas_item;

uniform bool blink = false;

void fragment() {
	vec4 color = texture(TEXTURE, UV);
	if (blink) {
		color.a = color.a * 0.25;
	}
	COLOR = color;
}

//shader_type canvas_item;
//
//uniform float adj : hint_range(0.25, 1.0) = 0;
//
//void fragment() {
//	vec4 color = texture(TEXTURE, UV);
//	color.a = color.a * adj;
//	COLOR = color;
//}
