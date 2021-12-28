class_name Wall
extends ColorRect

# Called when the node enters the scene tree for the first time.
func _ready():
	$StaticBody2D.shape_owner_get_shape(0, 0).extents = self.rect_size / 2
	$StaticBody2D/CollisionShape2D.transform = Transform2D(0, self.rect_size / 2)

func change_color(color):
	self.color = color
