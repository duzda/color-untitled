extends FullScreenTexture
class_name ShatterImpact

var shader = preload("res://shaders/impact.shader")

var _elapsed_time:float = 0
var _impact_vector: Vector2

func enable_shader(impact_vector):
	self.material.set_shader(shader)
	_enabled = true;
	_impact_vector = impact_vector / get_viewport_rect().size

func _physics_process(delta):
	if not _enabled:
		return

	_elapsed_time += delta
	self.material.set_shader_param("position", Vector2(0.5, 0.5) + 
		(_parent.get_node("Camera2D").get_camera_screen_center() - _parent.global_position) / get_viewport_rect().size *
		Vector2(-1, 1)) # To match OPENGL space
	self.material.set_shader_param("elapsed_time", _elapsed_time)

