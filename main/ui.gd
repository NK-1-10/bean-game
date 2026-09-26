extends CanvasLayer
@onready var water = $buttons/GridContainer/water
@onready var food = $buttons/GridContainer/food
@onready var settings = $buttons/GridContainer/settings
@onready var attention = $buttons/GridContainer/attention
@onready var panel = $Panel
@onready var label = $Panel/txt

func _ready() -> void:
	water.disabled = true; food.disabled = true; attention.disabled = true ; settings.disabled = true
	Signals.first.connect(first) ; Signals.gameStart.connect(begin)

func begin():
	settings.disabled = false

var settingsOpen = false ; var waterOpen = false; var foodOpen = false; var attentionOpen = false
func _on_settings_pressed() -> void:
	if settingsOpen:
		move('out')
	else:
		move('in')
		label.text = "SETTINGS"
		water.disabled = true; food.disabled = true; attention.disabled = true
		
func _on_water_pressed() -> void:
	if settingsOpen:
		move('out')
	else:
		move('in')
		food.disabled = true; attention.disabled = true; settings.disabled = true
		label.text = "WATER. Obtaining: Press e as you enter the area of the body on water at the top of the map. Using: Approach the plant in need of watering and press e"


func _on_food_pressed() -> void:
	if settingsOpen:
		move('out')
	else:
		move('in')
		label.text = "FOOD. Obtaining:Run around the map and pick up the scattered food packets. Using: Approach the plant in need of feeding and press e"
		water.disabled = true; attention.disabled = true; settings.disabled = true


func _on_attention_pressed() -> void:
	if settingsOpen:
		move('out')
	else:
		move('in')
		label.text = "ATTENTION. Obtaining: none. Using: Approach the plant in need of attention and press e"
		water.disabled = true; food.disabled = true; settings.disabled = true























var startPanel = Vector2(-241, 174)
var endPanel = Vector2(57, 174)
func move(w):
	var tween = create_tween()
	if w == "in":
		tween.tween_property(panel, "position", endPanel, 1)
	else:
		tween.tween_property(panel, "position", startPanel, 1)
		water.disabled = false; food.disabled = false; attention.disabled = false; settings.disabled = false
	await tween.finished


func first(what):
	if what == "attention":
		pass
	elif what == "water":
		pass
	elif what == "food":
		pass

func _water():
	water.visible = true
	var txt = "Your plant requires watering! You have 60s to water it. Take your empty bucket and interract with the body of water on the north (^)"
	move("in")
	await Global.typewriter(txt, label)
	await get_tree().create_timer(5).timeout
	move('out')

func _food():
	food.visible = true
	var txt = "Your plant requires feeding! You have 60s to feed it. Just run around and  you are bound to pick up some food."
	move("in")
	await Global.typewriter(txt, label)
	await get_tree().create_timer(5).timeout
	move('out')

func _attention():
	attention.visible = true
	var txt = "Your plant requires attention! You have 60s to comfort it. Walk up to it and let it knowyou are there for them."
	move("in")
	await Global.typewriter(txt, label)
	await get_tree().create_timer(5).timeout
	move('out')
