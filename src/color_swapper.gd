class_name ColorSwapper
extends Area2D

const ColorType = preload("res://src/color_type.gd")

const ColorGroups = {
	ColorType.ColorType.WHITE: "color_swapper_white",
	ColorType.ColorType.BLACK: "color_swapper_black",
	ColorType.ColorType.RED: "color_swapper_red",
	ColorType.ColorType.GREEN: "color_swapper_green",
	ColorType.ColorType.YELLOW: "color_swapper_yellow"
}

export(ColorType.ColorType) var color_type = ColorType.ColorType.WHITE setget set_color

func _ready():
	add_to_group(ColorGroups[color_type])

func set_color(color):
	color_type = color
	$ColorRect.color = ColorType.get_color(color)

func _on_ColorSwapper_body_entered(_body):
	get_tree().call_group("ColorManager", "swap_color", self.color_type)

func animate_select():
	if self.color_type == ColorType.ColorType.YELLOW:
		self.z_index = 1
		$ColorRect/AnimationPlayer2.play("grow", -1, 1.0)
	else:
		$ColorRect/AnimationPlayer2.play("select", -1, 5.0)

func animate_deselect():
	$ColorRect/AnimationPlayer2.play("select", -1, -5.0, true)

func noanimate_select():
	$ColorRect/AnimationPlayer2.current_animation = "select"
	$ColorRect/AnimationPlayer2.seek(1, true)
