extends Node

const file_name = "user://times.save"
const level_names = [
	"scenes/levels/1.tscn",
	"scenes/levels/2.tscn",
	"scenes/levels/3.tscn",
	"scenes/levels/4.tscn",
	"scenes/levels/5.tscn",
	"scenes/levels/6.tscn",
	"scenes/levels/7.tscn",
	"scenes/levels/8.tscn",
	"scenes/levels/9.tscn",
	"scenes/levels/10.tscn",
	"scenes/levels/11.tscn",
	"scenes/levels/12.tscn",
]

var level_times = {}

func _ready():
	_load_data()

func update_time(level, time):
	if not self.level_times.has(level) or time < self.level_times[level]:
		self.level_times[level] = time
	save_data()

func has_time(level):
	return self.level_times.has(level)

func get_time(level):
	return self.level_times[level]

func save_data():
	var save_game = File.new()
	save_game.open(file_name, File.WRITE)
	save_game.store_var(level_times)
	save_game.close()

func _load_data():
	var file = File.new()
	if file.file_exists(file_name):
		file.open(file_name, File.READ)
		level_times = file.get_var(true)
		file.close()

func is_level_locked(level):
	if level == 1:
		return false
	return not level_times.has(level - 1)

func select_current_level():
	var current_level := 0
	for i in range(level_names.size()):
		if level_times.has(i):
			current_level += 1

	if current_level > level_names.size() - 1:
		current_level -= 1

	return level_names[current_level]
	
