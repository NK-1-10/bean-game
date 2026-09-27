extends CharacterBody2D
@onready var player = $AnimatedSprite2D

const SPEED = 150.0

var facing := "side"

var character = "Elf"

func _ready() -> void:
	if Global.character != "":
		character = Global.character

var movement = {
	"Elf":{
		"idle":"elf idle",
		"idle back": "elf idle back",
		"idle side": "elf idle side",
		"walk": "elf walk",
		"walk back": "elf walk back",
		"walk forward": "elf walk forward"
	},
	"Maid":{
		"idle":"maid idle",
		"idle back": "maid idle back",
		"idle side": "maid idle side",
		"walk": "maid walk",
		"walk back": "maid walk back",
		"walk forward": "maid walk forward"
	},
	"Frog":{
		"idle":"frog idle",
		"idle back": "frog idle back",
		"idle side": "frog idle side",
		"walk": "frog walk",
		"walk back": "frog walk back",
		"walk forward": "frog walk forward"
	},
	"Pumpkin":{
		"idle":"pumpkin idle",
		"idle back": "pumpkin idle back",
		"idle side": "pumpkin idle side",
		"walk": "pumpkin walk",
		"walk back": "pumpkin walk back",
		"walk forward": "pumpkin walk forward"
	},
}

func _physics_process(delta: float) -> void:
	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	

	if direction:
		if abs(direction.x) >= abs(direction.y):
			facing = "side"
			player.flip_h = direction.x < 0
			player.play(movement[character]["walk"])
		elif direction.y < 0:
			facing = "back"
			player.play(movement[character]["walk forward"])
		else:
			facing = "front"
			player.play(movement[character]["walk back"])
		velocity = direction * SPEED
	else:
		if facing == "side":
			player.play(movement[character]["idle side"])
		elif facing == "back":
			player.play(movement[character]["idle back"])
		elif facing == "front":
			player.play(movement[character]["idle"])
		velocity = velocity.move_toward(Vector2.ZERO, SPEED)

	move_and_slide()
