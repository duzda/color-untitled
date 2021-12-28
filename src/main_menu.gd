extends Node

func _ready():
	$Menu/Play.grab_focus();
	if OS.get_name() != "HTML5":
		$Menu/Exit.show()

func _on_Play_pressed():
	var scene_return_value = get_tree().change_scene(LevelManager.select_current_level())
	if scene_return_value != OK:
		get_tree().quit(-1)

func _on_LevelSelect_pressed():
	var level_select_scene = get_tree().change_scene("res://scenes/level_select.tscn")
	if level_select_scene != OK:
		get_tree().quit(-1)

func _on_Exit_pressed():
	get_tree().quit()
