class_name ColorManager
extends Node

const ColorType = preload("res://src/color_type.gd")
const ColorSwapper = preload("res://src/color_swapper.gd")
const COlorWall = preload("res://src/color_wall.gd")

export var current_level := 0
export(ColorType.ColorType) var color_type = ColorType.ColorType.WHITE
var environment_color = ColorType.ColorType.BLACK if color_type == ColorType.ColorType.BLACK else ColorType.ColorType.WHITE

signal black_entered()
signal other_entered()
signal game_won()
signal game_won_guiManager()

func _ready():
	add_to_group("ColorManager")
	get_tree().call_group(ColorSwapper.ColorGroups[self.color_type], "noanimate_select")

func swap_color(color):
	if color == color_type:
		return

	if color == ColorType.ColorType.YELLOW:
		emit_signal("game_won")
		emit_signal("game_won_guiManager", current_level)

	var enemies = get_node("Enemies").get_children()
	for e in enemies:
		e.change_color(color)

	if color == ColorType.ColorType.BLACK:
		emit_signal("black_entered")
		if environment_color != ColorType.ColorType.BLACK:
			set_environment_color(color)

	else:
		emit_signal("other_entered")
		if environment_color != ColorType.ColorType.WHITE:
			set_environment_color(ColorType.ColorType.WHITE)
		
	get_tree().call_group(ColorSwapper.ColorGroups[self.color_type], "animate_deselect")
	get_tree().call_group(ColorSwapper.ColorGroups[color], "animate_select")
	get_tree().call_group(ColorWall.ColorGroups[self.color_type], "disable")
	get_tree().call_group(ColorWall.ColorGroups[color], "enable")
	self.color_type = color

func set_environment_color(color):
	environment_color = color
	get_tree().call_group("wall", "change_color", ColorType.MappedColors[color])
