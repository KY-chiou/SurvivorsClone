shader_type canvas_item;

uniform float progress: hint_range(0.0, 1.0) = 0.0;

void fragment() {
	COLOR = texture(TEXTURE, UV);
	vec3 color = mix(COLOR.rgb, vec3(1.0), progress);
	COLOR.rgb = color;
}
