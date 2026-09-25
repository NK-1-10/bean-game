extends CanvasLayer
@onready var panel = $Panel

var on = Vector2(699.0,0)
var off = Vector2(1172, 0)
var open = false ; var first = true

func _ready() -> void:
	$warning.visible = false
	panel.position = off

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		move()

func move():
	var tween = create_tween()
	if open:
		tween.tween_property(panel, "position", off, 0.5)
		open = false
		if first: 
			Signals.phone.emit()
			first = false
	else:
		tween.tween_property(panel, "position", on, 0.5)
		open = true

func _on_button_pressed() -> void:
	var tween = create_tween()
	tween.tween_property(panel, "position", off, 0.5)

func _on_one_pressed() -> void:
	if Global.coins >= 4:	
		Coins.coin(-4)
		Signals.pickUp.emit("plant", 1) # to add to inventory. script for this in "game.gd"
	else:
		warning(4) # how much is essentially needed. for how much tried to buy




func warning(tried):
	var need = tried - Global.coins
	
	$warning.text = "You dont have enough. you need " + str(need) + " more."
	$warning.visible = true
	await get_tree().create_timer(3).timeout
	$warning.visible = false
