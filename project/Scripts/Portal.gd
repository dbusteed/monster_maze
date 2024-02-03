extends Area2D

func _on_Portal_body_entered(_body):
	get_tree().change_scene("res://Scenes/World.tscn")
	Global.level += 1
	Global.playing = false

func fade_in():
	$Tween.interpolate_property(self, "modulate", Color(1, 1, 1, 0), Color(1, 1, 1, 1), 2.0)
	$Tween.start()
