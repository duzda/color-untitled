extends Label

var _elapsed_time = 0
var _enabled := true

func _process(delta):
	if _enabled:
		_elapsed_time += delta
		self.text = _format_time(_elapsed_time)

func _format_time(time: float):
	var minutes := time / 60
	var seconds := fmod(time, 60)
	var milliseconds := fmod(time, 1) * 100

	return "%02d:%02d.%02d" % [minutes, seconds, milliseconds]

func stop_timer():
	_enabled = false

func get_time():
	return _elapsed_time
