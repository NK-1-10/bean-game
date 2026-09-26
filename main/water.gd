extends Area2D

@onready var panel = $"../UI/Panel"
@onready var txt = $"../UI/Panel/txt"

var inside = false
func _on_body_exited(body: Node2D) -> void:
	if body.name == "player": inside = false
func _on_body_entered(body: Node2D) -> void:
	if body.name == "player": inside = true
	
var startPanel = Vector2(-241, 174)
var endPanel = Vector2(57, 174)
func move(w):
	var tween = create_tween()
	if w == "in":
		tween.tween_property(panel, "position", endPanel, 1)
	else:
		tween.tween_property(panel, "position", startPanel, 1)
	await tween.finished

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interract") and inside:
		var slot = Global.Current_slot
		var key = str(slot)
		if Global.inventory.has(key) and Global.inventory[key]["name"] == "wateringcan":
			Global.inventory[key] = {"name": "water", "amount": 1}
			get_tree().current_scene.updateInvent(slot)
