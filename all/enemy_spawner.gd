extends Node2D

var enemyScene = preload("res://all/enemy.tscn")
@export var enemyVals = [1, 3, 3, 5]

@export var roundWeight = 3
@export var roundExponentialism = 5
@export var roundRamp = 1
@export var rampRamp = 1

@export var distFromCenter = 500

var currentRound = 0

@export var plantsContainer: Node2D

var enemiesLeft = 0

func _ready() -> void:
	Signals.gameStart.connect(spawnRound)

func spawnRound():
	print("starting round")
	currentRound += 1
	var currentRoundPoints = round(pow(1.1, currentRound) * currentRound * (roundWeight + roundExponentialism))
	while(currentRoundPoints > 0):
		var randType = randi_range(0, 3)
		
		while(enemyVals[randType] > currentRoundPoints):
			randType -= 1
		
		currentRoundPoints -= enemyVals[randType]
		
		enemiesLeft += 1
		spawnEnemy(randType)

func checkRemainingEnemies():
	enemiesLeft -= 1
	
	if enemiesLeft == 0:
		spawnRound()

func spawnEnemy(val):
	var newEnemy = enemyScene.instantiate()
	
	var randZone = randi_range(0, 2)
	
	var randX
	var randY
		
	if(randZone == 0):
		randX = randi_range(-distFromCenter, -distFromCenter * 0.75)
		randY = randi_range(-distFromCenter, distFromCenter)
	elif(randZone == 1):
		randX = randi_range(distFromCenter * 0.75, distFromCenter)
		randY = randi_range(-distFromCenter, distFromCenter)
	elif(randZone == 2):
		randX = randi_range(-distFromCenter, distFromCenter)
		randY = randi_range(distFromCenter * 0.75, distFromCenter)
	newEnemy.global_position = global_position + Vector2(randX, randY)
	newEnemy.allPlantContainer = plantsContainer
	add_child(newEnemy)
	newEnemy.tree_exited.connect(checkRemainingEnemies)
