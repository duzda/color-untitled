extends ColorRect
class_name FullScreenTexture

var _enabled:bool = false

var _parent

func _ready():
	self.resize()
	var _connected = get_tree().get_root().connect("size_changed", self, "resize")

func set_parent(var parent):
	_parent = parent

func resize():
	self.rect_size = get_viewport_rect().size
	self.rect_position = -get_viewport_rect().size/2

func reset():
	self.material.set_shader_param("elapsed_time", 0.0)

