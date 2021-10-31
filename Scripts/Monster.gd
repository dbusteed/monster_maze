extends KinematicBody2D

onready var nav = get_node("/root/World/Navigation2D")
onready var player = get_node("/root/World/Player")

var dir = null
var path = null
var target = null
var next_step = null
var velocity = Vector2.ZERO


func _physics_process(delta):
	if Global.playing:
		path = nav.get_simple_path(global_position, player.global_position, false)
		if path.size() > 2:
			next_step = path[2]
			dir = global_position.direction_to(next_step)
			velocity = velocity.move_toward(dir * 25, 200 * delta)
		
		if $SoftCollision.is_colliding():
			velocity += $SoftCollision.get_push_vector() * delta * 100
		
		velocity = move_and_slide(velocity)


func blink():
	$AnimationPlayer.play("Blink")
