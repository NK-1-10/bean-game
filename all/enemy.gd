extends CharacterBody2D

var coinScene = preload("res://all/coin.tscn")

@export var speed: int = 100
@export var maxSpeed: int = 300
@export var deceleration: int = 10
@export var jumpMovement: bool = false
@export var movementDelay: float = 0.5
@export var damage: int = 1
@export var health: int = 5

@export var bugColor: Color = Color.from_rgba8(255, 255, 255, 255)

signal damaged

var onCooldown = false

@export var allPlantContainer: Node2D
var targetedPlant

var newTimer = null

func _ready() -> void:
	targetedPlant = await targetClosestPlant()
	damaged.connect(takeDamage)
	
	if(jumpMovement):
		newTimer = Timer.new()
		newTimer.wait_time = movementDelay
		add_child(newTimer)
		newTimer.connect("timeout", jumpMove)
		newTimer.start()

func targetClosestPlant() -> Node2D:
	var chosenPlant
	var distance = 9999999999
	
	while chosenPlant is not Node2D:
		for child: Node2D in allPlantContainer.get_children():
			var dist = global_position.distance_to(child.global_position)
			if dist < distance:
				distance = dist
				chosenPlant = child
	
		if chosenPlant is not Node2D:
			await get_tree().create_timer(3).timeout
	
	return chosenPlant

func _physics_process(delta: float) -> void:
	if(targetedPlant == null or onCooldown or jumpMovement):
		velocity = velocity.move_toward(Vector2.ZERO, deceleration)
		move_and_slide()
		return
	
	if(!jumpMovement):
		var dirToPlant = global_position.direction_to(targetedPlant.global_position)
		
		velocity = dirToPlant * speed
		$bugSprite.look_at(targetedPlant.global_position)
		$bugSprite.rotation_degrees += 90
	
	move_and_slide()

func jumpMove():
	if(targetedPlant != null):
		var dir = global_position.direction_to(targetedPlant.global_position)
		velocity = dir * speed
		$bugSprite.look_at(targetedPlant.global_position)
		$bugSprite.rotation_degrees += 90

func _on_damage_area_area_entered(area: Area2D) -> void:
	if area.get_parent().get_parent() == allPlantContainer:
		area.get_parent().damage.emit(damage)
		onCooldown = true
		velocity = -global_position.direction_to(area.global_position) * speed / 2
		if(newTimer is Timer): newTimer.stop()
		await get_tree().create_timer(movementDelay).timeout
		onCooldown = false
		if(newTimer is Timer): newTimer.start()

func takeDamage(amount):
	health -= amount
	if(health <= 0):
		var newCoin = coinScene.instantiate()
		newCoin.global_position = global_position
		get_parent().add_child(newCoin)
		
		queue_free()
	else:
		onCooldown = true
		velocity = velocity.move_toward(Vector2.ZERO, deceleration)
		if(!onCooldown):
			await get_tree().create_timer(0.1).timeout
			onCooldown = false
