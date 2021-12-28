shader_type canvas_item;
render_mode unshaded;

varying vec2 position;

void vertex() {
	position = VERTEX;
}

void fragment() {
	float sum = position.x + position.y;
	if (sin(sum * 0.5f) < -0.6f) {
		return;
	}
}