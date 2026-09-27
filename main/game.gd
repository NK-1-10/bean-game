extends Node2D

@onready var grid = $ColorRect
@onready var inventory = $UI/inventory/HBoxContainer/Panel
@export var start = Vector2(400, 177)
@export var slots = 3
var offset = 16*2
@onready var starty = start.y
@onready var startx = start.x
@onready var camera = $Camera2D
@onready var player = $player

var selected = 0

@onready var music = $UI/buttons/settings/Panel/VBoxContainer/music
@onready var sfx = $UI/buttons/settings/Panel/VBoxContainer/sfx
@onready var t = $UI/buttons/settings/Panel/VBoxContainer/txt
@onready var window = $UI/buttons/settings/Panel/VBoxContainer/fullscreen

var character = "Elf"
func _ready() -> void:
	music.value = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("music")))
	sfx.value = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("sfx")))
	window.button_pressed = DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN
	t.button_pressed = not Global.skip
	if Global.character != "":
		character = Global.character
	print(Global.character)
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	Signals.start_end.connect(_add_bean) ; Signals.bean_planted.connect(_planted_bean) ; Signals.phone.connect(_opened_phone) ; Signals.updateCoins.connect(update_coins)
	$beanstock.position = Vector2(-1028,-700) ; $UI/Phone.position = Vector2(1244, 136) ; Signals.pickUp.connect(inventoryChange)
	$UI/inventory/HBoxContainer/Panel/overlay.visible = false
	$ColorRect/ColorRect.visible = false
	$ColorRect/red.visible = false
	$squares.visible = false
	generate_inventory()
	grid.visible = false
	var id = 0
	for i in range(5):       # rows
		for n in range(8):   # columns
			id += 1
			var new_rec = grid.duplicate()
			new_rec.visible = true
			new_rec.position = Vector2(startx + offset * n, starty + offset * i)
			$squares.add_child(new_rec)
			new_rec.set_meta("id", id)
			Global.Squares[id] = {
				"row": i,
				"column": n,
				"can_plant": true
			}
	play_intro()
	#inventoryChange("plant", 1)
	#$player/Camera2D.make_current()

var txt = ''
@onready var label = $UI/Panel/txt

func _add_bean():
	inventoryChange("bean", 1)
	inventoryChange("wateringcan", 1)
	move('in')
	txt = "the great bean fo an even greater Beanstock! Try selecting the bean and planting it somewhere on this lovely land."
	await Global.typewriter(txt, label)

func update_coins(txt):
	$"sounds/coin add".play()
	$UI/buttons/Coin.text = txt

func _planted_bean():
	txt = "Perfect! But if you want to reach the goose in the sky, then the beanstock must grow in size."
	await Global.typewriter(txt, label)
	txt = "In order to do that, you must plant more beans around the beanstock. When they reeach a certain size, The roots will have connected with the beanstock, helping it grow."
	await Global.typewriter(txt, label)
	txt = "However, take note that your little bean trees will need your attention. They will need watering, feeding and sometimes some company."
	await Global.typewriter(txt, label)
	txt = "To get more beans to plant, you must defeat the bugs coming to eat your plants. For that you will get coins. And with coins you can buy more beans on your phone!"
	await Global.typewriter(txt, label)
	$sounds/appear.play()
	var tween = create_tween()
	tween.tween_property($UI/Phone, "position", Vector2(1069, 136), 0.5)
	await tween.finished
	txt = "And with that, good luck!"
	await Global.typewriter(txt, label)
	move('out')
	player.set_physics_process(true) 
	$player/Camera2D.make_current()
	Signals.gameStart.emit()
	$check.start()

func _opened_phone():
	txt = "Great. Thankfully you have just enough coins to buy one bean! This is your start. keep going tho! In no time you will reach the end."
	await Global.typewriter(txt, label)

func refresh_grid():
	var item = Global.held_item()
	for sq in $squares.get_children():
		sq.get_node("ColorRect").visible = false
		sq.get_node("red").visible = not Global.can_place(sq.get_meta("id"), item)

@onready var pan = $UI/Panel
var startPanel = Vector2(-241, 174)
var endPanel = Vector2(57, 174)

func move(w):
	if Global.skip : return
	var tween = create_tween()
	if w == "in":
		$sounds/open.play()
		tween.tween_property(pan, "position", endPanel, 1)
	else:
		tween.tween_property(pan, "position", startPanel, 1)
		$sounds/close.play()
	await tween.finished
















var movement = {
	"Elf":{
		"idle":"elf idle",
		"walk forward": "elf walk forward"
	},
	"Maid":{
		"idle":"maid idle",
		"walk forward": "maid walk forward"
	},
	"Frog":{
		"idle":"frog idle",
		"walk forward": "frog walk forward"
	},
	"Pumpkin":{
		"idle":"pumpkin idle",
		"walk forward": "pumpkin walk forward"
	},
}

func play_intro():
	camera.make_current()
	player.set_physics_process(false) 
	player.position = Vector2(521, 470)
	$player/AnimatedSprite2D.play(movement[character]["walk forward"])
	var tween = create_tween()
	tween.tween_property(player, "position", Vector2(521, 256), 3)
	await tween.finished
	$player/AnimatedSprite2D.play(movement[character]["idle"])
	Signals.start_start.emit()
	#player.set_physics_process(true) 
	
func generate_inventory():
	var box = inventory.get_parent()
	box.add_theme_constant_override("separation", 20)
	inventory.get_node("Label").text = "1"
	for s in range(slots - 1):
		var new_slot = inventory.duplicate()
		new_slot.get_node("Label").text = str(s + 2)
		new_slot.gui_input.connect(_on_slot_input.bind(s + 2))
		box.add_child(new_slot)
	inventory.gui_input.connect(_on_slot_input.bind(1))

 # ----------------------------------------------------------------------------------add to inventory "text" and the ammount
func inventoryChange(what, amount):
	if what not in Global.Collectables:
		return false
	# stack onto the same item if stackable
	if Global.Collectables[what]["stackable"]:
		for key in Global.inventory:
			if Global.inventory[key]["name"] == what:
				Global.inventory[key]["amount"] += amount
				updateInvent(int(key))
				return true
	# otherwise first empty slot
	for i in range(1, slots + 1):
		if not Global.inventory.has(str(i)):
			Global.inventory[str(i)] = {"name": what, "amount": amount}
			updateInvent(i)
			return true
	return false  # no room

func updateInvent(index):
	var slot = inventory.get_parent().get_child(index - 1)
	var key = str(index)
	$sounds/pending.play()
	if Global.inventory.has(key):
		var item = Global.inventory[key]["name"]
		slot.get_node("TextureRect").texture = load(Global.Collectables[item]["visual"])
	else:
		slot.get_node("TextureRect").texture = null

func use_item(index):
	var key = str(index)
	if not Global.inventory.has(key):
		return
	Global.inventory[key]["amount"] -= 1
	if Global.inventory[key]["amount"] <= 0:
		Global.inventory.erase(key)
		$squares.visible = false  # nothing to plant anymore
	updateInvent(index)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func is_it_plant(where):
	var key = str(where)
	if Global.inventory.has(key):
		var item = Global.inventory[key]["name"]
		return Global.Collectables[item]["plantable"]
	return false

func select_slot(index):
	var box = inventory.get_parent()
	if index == 0:
		for slot in box.get_children():
			slot.get_node("overlay").visible = false
		selected = 0
		Global.Current_slot = 0
		$squares.visible = false
		return
	if index < 1 or index > box.get_child_count():
		return
	for slot in box.get_children():
		slot.get_node("overlay").visible = false
	box.get_child(index - 1).get_node("overlay").visible = true
	selected = index
	Global.Current_slot = selected
	if is_it_plant(index):
		$squares.visible = true
		refresh_grid()
	else: $squares.visible = false

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("1"):
		select_slot(1)
	elif event.is_action_pressed("2"):
		select_slot(2)
	elif event.is_action_pressed("3"):
		select_slot(3)
	elif event.is_action_pressed("4"):
		select_slot(4)
	elif event.is_action_pressed("clear"):
		select_slot(0)

func _on_slot_input(event: InputEvent, index: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		select_slot(index)






func set_bus(bus_name, value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(bus_name), linear_to_db(value))

func _on_music_value_changed(value: float) -> void:
	set_bus("music", value)
	$sounds/tick.play()

func _on_sfx_value_changed(value: float) -> void:
	set_bus("sfx", value)
	$sounds/tick.play()

func _on_txt_toggled(toggled_on: bool) -> void:
	Global.skip = toggled_on
	$sounds/tick.play()

func _on_fullscreen_toggled(toggled_on: bool) -> void:
	$sounds/tick.play()
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)


var lost = false
var plant_price = 4

func check_lose():
	if lost: return
	for p in $plants.get_children():
		if not p.dead: return                 # a plant is alive
	for key in Global.inventory:
		var item = Global.inventory[key]["name"]
		if Global.Collectables[item]["plantable"]: return   # can still plant
	if get_tree().get_nodes_in_group("coins").size() > 0: return  # coins to pick up
	if Global.coins >= plant_price: return    # can still buy
	lost = true
	lose()

func lose():
	Fade.change_scene("res://main.tscn")

func _on_check_timeout() -> void:
	check_lose()
