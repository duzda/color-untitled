extends Node
class_name GUIManager

var _scene_manager
var _successful = false

func _ready():
	_scene_manager = get_tree().get_root().get_node("ColorManager/SceneManager")

func on_gameover():
	$ElapsedTime.stop_timer()
	$Menu.visible = true
	$AnimationPlayer.play("scale_text")
	if _successful:
		$Menu/Continue.visible = true
		$Menu/Continue.grab_focus()
	else:
		$Menu/Restart.grab_focus()

func update_text(elapsedTime: String):
	$ElapsedTime.text = elapsedTime

func _on_Continue_pressed():
	Engine.time_scale = 1
	var scene = LevelManager.select_current_level()
	if scene == LevelManager.level_names[LevelManager.level_names.size() - 1]:
		_scene_manager.load_main_menu()
	var scene_return_value = get_tree().change_scene(scene)
	if scene_return_value != OK:
		get_tree().quit(-1);

func _on_Restart_pressed():
	_scene_manager.reload_scene()

func _on_Exit_pressed():
	_scene_manager.load_main_menu()

func _on_ColorManager_game_won_guiManager(level):
	_successful = true
	on_gameover()
	LevelManager.update_time(level, $ElapsedTime.get_time())
