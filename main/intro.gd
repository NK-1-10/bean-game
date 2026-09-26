extends Node

@onready var pan = $"../UI/Panel"
@onready var place = $"../UI/Panel/txt"
@onready var player = $"../player"
@onready var stash = $"../UI/Bag"
@onready var bean = $"../UI/Bag/Bean"

var startPanel = Vector2(-241, 174)
var endPanel = Vector2(57, 174)
var txt = ''
var pressed = 0
var waiting = false

func _ready() -> void:
	pan.position = startPanel; pressed = 0 ; bean.visible = false ; bean.position = Vector2(0, 62.619)
	stash.position = Vector2(580, 726)
	Signals.start_start.connect(_start)

func _start():
	await move("in")
	txt = "What a lovely plot of land. Lovely."
	await Global.typewriter(txt, place)
	txt = "And above..the golden goose in the sky..."
	await Global.typewriter(txt, place)
	txt = "No time to waist! Let's get these ROOTS growing!"
	await Global.typewriter(txt, place)
	await move("out")
	var tween = create_tween()
	tween.tween_property(stash, "position", Vector2(580, 412), 1)
	waiting = true

func move(w):
	var tween = create_tween()
	if w == "in":
		tween.tween_property(pan, "position", endPanel, 1)
	else:
		tween.tween_property(pan, "position", startPanel, 1)
	await tween.finished


func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT and waiting:
		print('pressed')
		pressed += 1
		if pressed == 3:
			emmit()
			waiting = false
		else:
			shake()

func shake():
	waiting = false
	var tween = create_tween()
	tween.tween_property(stash, "rotation_degrees", 25, 0.25).as_relative()
	tween.tween_property(stash, "rotation_degrees", -40, 0.25).as_relative()
	tween.tween_property(stash, "rotation_degrees", 0, 0.5)
	await tween.finished
	waiting = true
	
func emmit():
	bean.visible = true
	var tween = create_tween()
	tween.tween_property(bean, "position", Vector2(0, -394.12), 0.5)
	await tween.finished
	var tween2 = create_tween()
	tween2.tween_property(stash, "position", Vector2(580, 850), 1)
	await tween2.finished
	Signals.start_end.emit() 
