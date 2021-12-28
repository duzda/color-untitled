extends Node

func _ready():
	get_tree().paused = true;

func _input(event):
	if not event is InputEventMouse and not event.is_action("ui_reset"):
		get_tree().paused = false;
