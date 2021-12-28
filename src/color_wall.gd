class_name ColorWall
extends ColorRect

const ColorType = preload("res://src/color_type.gd")

const ColorGroups = {
	ColorType.ColorType.WHITE: "color_wall_white",
	ColorType.ColorType.BLACK: "color_wall_black",
	ColorType.ColorType.RED: "color_wall_red",
	ColorType.ColorType.GREEN: "color_wall_green",
	ColorType.ColorType.YELLOW: "color_wall_yellow"
}

export(ColorType.ColorType) var color_type = ColorType.ColorType.WHITE setget set_color

# Called when the node enters the scene tree for the first time.
func _ready():
	self.disable()
	$ReferenceRect.rect_size = self.rect_size
	$StaticBody2D.shape_owner_get_shape(0, 0).extents = self.rect_size / 2
	$StaticBody2D/CollisionShape2D.transform = Transform2D(0, self.rect_size / 2)
	add_to_group(ColorGroups[color_type])

func set_color(color):
	color_type = color
	self.color = ColorType.get_color(color)
	$ReferenceRect.border_color = ColorType.get_color(color)

func enable():
	self.set_visibility(true)
	$ReferenceRect.visible = false
	self.set_collision(true)

func disable():
	self.set_visibility(false)
	$ReferenceRect.visible = true
	self.set_collision(false)

# Hides current object, but keeps it children shown
func set_visibility(visibility: bool):
	self.color = Color(self.color.r, self.color.g, self.color.b, visibility)

func set_collision(collision: bool):
	$StaticBody2D.set_collision_layer_bit(0, collision)
	$StaticBody2D.set_collision_layer_bit(10, collision)
	$StaticBody2D.set_collision_mask_bit(0, collision)
	$StaticBody2D.set_collision_mask_bit(10, collision)
