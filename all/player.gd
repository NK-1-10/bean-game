extends CharacterBody2D
@onready var player = $AnimatedSprite2D

const SPEED = 150.0

var facing := "side"

func _physics_process(delta: float) -> void:
	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")

	if direction:
		if abs(direction.x) >= abs(direction.y):
			facing = "side"
			player.flip_h = direction.x < 0
			player.play("elf walk")
		elif direction.y < 0:
			facing = "back"
			player.play("elf walk forward")
		else:
			facing = "front"
			player.play("elf walk back")
		velocity = direction * SPEED
	else:
		if facing == "side":
			player.play("elf idle side")
		elif facing == "back":
			player.play("elf idle back")
		elif facing == "front":
			player.play("elf idle")
		velocity = velocity.move_toward(Vector2.ZERO, SPEED)

	move_and_slide()
