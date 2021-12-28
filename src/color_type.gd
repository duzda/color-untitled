enum ColorType {
	RED,
	GREEN,
	YELLOW,
	WHITE,
	BLACK
}

const MappedColors = {
	ColorType.RED: Color(0xee0000ff),
	ColorType.GREEN: Color(0x14f414ff),
	ColorType.YELLOW: Color(0xffd700ff),
	ColorType.WHITE: Color.white,
	ColorType.BLACK: Color.black
}

static func get_color(color) -> Color:
	return MappedColors[color]
