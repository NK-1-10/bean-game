shader_type canvas_item;

uniform vec2 center = vec2(0.0);
uniform float radius = 5000.0;
uniform vec2 screen_size = vec2(1152.0, 648.0);

void fragment() {
	vec2 pos = UV * screen_size;
	if (distance(pos, center) < radius) {
		COLOR = vec4(0.0, 0.0, 0.0, 0.0);   // inside circle: see-through
	} else {
		COLOR = vec4(0.0, 0.0, 0.0, 1.0);   // outside: black
	}
}