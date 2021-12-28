extends GridContainer

const level_button = preload("res://prefabs/level_button.tscn")
const level_button_locked = preload("res://prefabs/level_button_locked.tscn")

func _ready():
	var levels = list_files_in_directory("res://scenes/levels/")
	
	self.columns = 4 
	
	for level in range(len(levels)):
		var button : Button
		var current_level := int(levels[level])
		if LevelManager.is_level_locked(current_level):
			button = level_button_locked.instance()
			button.text = levels[level]
		else:
			button = level_button.instance()
			button.text = levels[level]
			
			if LevelManager.has_time(current_level):
				var label = button.get_node("Label")
				label.text = _format_time(LevelManager.get_time(current_level))
		self.add_child(button)

func _format_time(time: float):
	var minutes := time / 60
	var seconds := fmod(time, 60)
	var milliseconds := fmod(time, 1) * 100

	if minutes < 1:
		return "%02d.%02d" % [seconds, milliseconds]
	return "%02d:%02d.%02d" % [minutes, seconds, milliseconds]

func list_files_in_directory(path):
	var files = []
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()

	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			file = file.split('.')
			files.append(file[0])

	dir.list_dir_end()
	
	files.sort_custom(NumberSorter, "sort_numbers")

	return files


class NumberSorter:
	static func sort_numbers(a, b):
		if len(a) < len(b):
			return true
		elif len(a) == len(b):
			if ord(a[len(a) - 1]) < ord(b[len(b) - 1]):
				return true
			return false
		return false


func _on_BackButton_pressed():
	var main_menu_scene = get_tree().change_scene("res://scenes/main_menu.tscn")
	if main_menu_scene != OK:
		get_tree().quit(-1)
