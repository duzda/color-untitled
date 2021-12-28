class_name SceneManager
extends Node

const main_menu_scene = "scenes/main_menu.tscn"

var _shatter_impact
var _player
var _pause

func _ready():
	_shatter_impact = get_tree().get_root().get_node("ColorManager/Player/Camera2D/ShatterImpact")
	_player = get_tree().get_root().get_node("ColorManager/Player")
	_pause = get_tree().get_root().get_node("ColorManager/Pause")

func _process(_delta):
	if Input.is_action_pressed("ui_reset"):
		self.reload_scene()
	
func reload_scene():
	_shatter_impact.reset()
	_player._on_ColorManager_other_entered()
	_pause._ready()
	Engine.time_scale = 1
	var scene_return_value = get_tree().reload_current_scene()
	if scene_return_value != OK:
		self.load_main_menu()

func load_main_menu():
	Engine.time_scale = 1
	var scene_return_value = get_tree().change_scene(main_menu_scene)
	if scene_return_value != OK:
		get_tree().quit(-1);
