extends KinematicBody2D

var death_menu = preload("res://Scenes/DeathMenu.tscn")

var velocity = Vector2.ZERO
var input_vector = Vector2.ZERO

func _physics_process(delta):
    if Global.playing:
        input_vector = Vector2.ZERO
        input_vector.x = Input.get_action_strength("right") - Input.get_action_strength("left")
        input_vector.y = Input.get_action_strength("down") - Input.get_action_strength("up")
        input_vector = input_vector.normalized()

        if input_vector == Vector2.ZERO:
            velocity = velocity.move_toward(Vector2.ZERO, 500 * delta)
        else:
            velocity = velocity.move_toward(input_vector * 30, 200 * delta)

        velocity = move_and_slide(velocity)


func _on_HurtBox_area_entered(_area):
    var d = death_menu.instance()
    get_node("/root/World").add_child(d)
    Global.playing = false
