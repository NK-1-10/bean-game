extends Node2D

@onready var plant = $AnimatedSprite2D
@onready var timer = $needs
@onready var shoot = $shoot
@onready var temp = $Label
var seed_scene = preload("res://seed.tscn")

@export var hp = 50

@export var first = 3
@export var second =  1

var cFrame
var dead = false
var clickable = false

func _ready() -> void:
	plant.frame = 0
	cFrame = 0
	temp.text = 'lvl0'

func _process(delta: float) -> void:
	pass

func grow(from):
	if from == 0:
		shoot.wait_time = first
		shoot.start()
		temp.text = 'lvl1'
	elif from == 1:
		shoot.wait_time = second
		temp.text = 'lvl2'
	elif from == 2:
		clickable = true
		temp.text = 'awaiting merge'
	if from == 3: return
	
	plant.frame = from+1
	cFrame = plant.frame

func fusionStart():
	shoot.stop()
	temp.text = 'merged'

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT and clickable:
		fusionStart()

func _on_needs_timeout() -> void: #--------------------------------------------------------------------need control
	var time = randi_range(8, 15)
	timer.wait_time = time
	timer.start()
	var need = randi_range(1, 3)
	
	var n
	if need ==  1:
		n = "w" #water
	elif need == 2:
		n = "f" #food
	else : n = "a" #attention
	_need(n)

func _need(what): 
	if what == "a":
		pass
	elif what == "f":
		pass
	else: pass
	
func takeDamage(damage): #--------------------------------------------------------------------damage and death
	if dead: return
	hp = hp - damage
	if hp <= 0 :
		timer.stop()
		death()
		
func death():
	plant.play_backwards("default")
	plant.frame = cFrame
	await plant.animation_finished
	dead = true
	queue_free()


func _on_shoot_timeout() -> void:
	var s = seed_scene.instantiate()
	get_parent().add_child(s)
	s.global_position = global_position
	s.direction = (get_global_mouse_position() - global_position).normalized()


func _on_lvl_up_pressed() -> void:
	grow(cFrame)
