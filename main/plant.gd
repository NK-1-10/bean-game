extends Node2D

signal damage

@onready var plant = $AnimatedSprite2D
@onready var timer = $needs
@onready var shoot = $shoot
@onready var temp = $Label
@onready var bar = $ProgressBar
var seed_scene = preload("res://seed.tscn")
@onready var progress = $progress

@export var hp = 50
@export var seedDamage = 1
@export var range = 50

@export var first = 3
@export var second =  1

var xp0 = 4
var xp1 = 8
var xp2 = 15
var xpNeeded
var xpTotal = 0

var cFrame
var dead = false
var clickable = false
var has_need = false
var need = ''

var waterF = true ; var foodF = true; var attentionF = true

func _ready() -> void:
	damage.connect(takeDamage)
	$labels/e.visible = false
	temp.visible = false
	bar.visible = false
	plant.frame = 0
	cFrame = 0
	temp.text = 'lvl0'
	xpNeeded = xp0

func _process(delta: float) -> void:
	if has_need:
		bar.value = progress.wait_time - progress.time_left
	if is_in_range:
		canE(need)
	else:
		yes = false
		$labels/e.visible = false
		

func grow(from):
	if from == 0:
		shoot.wait_time = first
		shoot.start()
	elif from == 1:
		shoot.wait_time = second
	elif from == 2:
		clickable = true
		timer.stop()
	if from == 3: return
	
	plant.frame = from+1
	cFrame = plant.frame


func _on_lvl_up_pressed() -> void:
	grow(cFrame)

func fusionStart():
	shoot.stop()
	plant.play_backwards("default")
	await plant.animation_finished
	queue_free()
	timer.stop()
	#fuse() #--------------------------------------------------------------------when fuse script added

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT and clickable:
		fusionStart()

func _on_needs_timeout() -> void: #--------------------------------------------------------------------need control
	if has_need: return
	has_need = true
	
	var roll = randi_range(1, 3)
	var n
	if roll ==  1:
		n = "w" #water
	elif roll == 2:
		n = "f" #food
	else : n = "a" #attention
	_need(n)

func _need(what): 
	bar.visible = true
	temp. visible = true
	bar.max_value = progress.wait_time
	progress.start()
	if what == "a":
		temp.text = "Pay attention to me"
		need = "attention"
		if attentionF:
			attentionF = false
			Signals.first.emit("attention")
	elif what == "f":
		temp.text = "Feed me"
		need = "food"
		if attentionF:
			foodF = false
			Signals.first.emit("food")
	elif what == "w":
		temp.text = "Water me"
		need = "water"
		if attentionF:
			waterF = false
			Signals.first.emit("water")

func fufillNeed(what):
	if not has_need or what != need: return
	if what != need: return
	progress.stop()
	bar.visible = false
	has_need = false
	
	var xp
	if what == "water":
		xp = 6
	elif what == "food":
		xp = 4
	elif what == "attention":
		xp = 2
	updateXP(xp)
	temp.visible = false
	
	var time = randi_range(2, 4)
	timer.wait_time = time
	if cFrame == 3: return
	timer.start()

func updateXP(add):
	if cFrame == 3: return
	xpTotal += add
	var frame = cFrame
	if frame == 0:
		if xpTotal >= xp0:
			grow(frame)
		else: return
	elif frame == 1:
		if xpTotal >= xp1:
			grow(frame)
		else: return
	else:
		if xpTotal >= xp2:
			grow(frame)
		else: return

func _on_w_pressed() -> void:
	fufillNeed('water')
func _on_a_pressed() -> void:
	fufillNeed('attention')
func _on_f_pressed() -> void:
	fufillNeed('food')
	
func _on_progress_timeout() -> void:
	has_need = false
	need = ''
	bar.visible = false
	timer.start()
	temp.visible = false
	if cFrame == 0: return
	cFrame -= 1
	plant.frame = cFrame
	if cFrame == 0:
		shoot.stop()
	elif cFrame == 1:
		shoot.wait_time = first
	clickable = false

func takeDamage(damage): #--------------------------------------------------------------------damage and death
	print(damage)
	if dead: return
	hp -= damage
	if hp <= 0 :
		timer.stop()
		death()

func death():
	print("plant died")
	plant.play_backwards("default")
	plant.frame = cFrame
	await plant.animation_looped
	dead = true
	queue_free()


func _on_shoot_timeout() -> void:
	var s = seed_scene.instantiate()
	s.damage = seedDamage
	get_parent().add_child(s)
	s.global_position = global_position
	s.direction = (get_global_mouse_position() - global_position).normalized()


var is_in_range = false

func _on_area_2d_body_exited(body: Node2D) -> void:
	is_in_range = false
func _on_area_2d_body_entered(body: Node2D) -> void:
	is_in_range = true
	

var yes = false

func canE(need):
	yes = false
	$labels/e.visible = false
	var key = str(Global.Current_slot)
	var holding = ""
	if Global.inventory.has(key):
		holding = Global.inventory[key]["name"]
	if need == "attention" or (need == "water" and holding == "water") or (need == "food" and holding == "food"):
		$labels/e.visible = true
		yes = true

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interract") and yes:
		var game = get_tree().current_scene
		var slot = Global.Current_slot
		if need == "food":
			game.use_item(slot)
		elif need == "water":
			Global.inventory[str(slot)] = {"name": "wateringcan", "amount": 1}
			game.updateInvent(slot)
		fufillNeed(need)
