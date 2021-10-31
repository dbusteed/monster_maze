extends Button

func _on_StartButton_pressed():
	get_tree().change_scene("res://Scenes/World.tscn")	
	Global.level = 1

func _unhandled_input(_event):
	if Input.is_key_pressed(KEY_ENTER):
		_on_StartButton_pressed()
