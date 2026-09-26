extends Area2D

@onready var plant = $"../../../plant"
@onready var place = $".."
@onready var plants_holder = $"../../../plants"
@onready var bean = $"../../../beanstock"

var offset_half = 16

func _on_mouse_entered() -> void:
	if not place.has_meta("id"): return
	if Global.can_place(place.get_meta("id"), Global.held_item()):
		get_parent().get_node("ColorRect").visible = true

func _on_mouse_exited() -> void:
	get_parent().get_node("ColorRect").visible = false

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if not place.has_meta("id"): return
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var id = place.get_meta("id")
		var item = Global.held_item()
		if not Global.can_place(id, item): return

		if item == "plant":
			var new_plant = plant.duplicate()
			Global.block_around(id)
			plants_holder.add_child(new_plant)
			new_plant.get_node("needs").start()
			new_plant.global_position = place.global_position + place.size / 2
			get_node("../../..").use_item(Global.Current_slot)
			get_node("../../..").refresh_grid()
		elif item == "bean":
			Global.block_2x2(id)
			bean.visible = true
			bean.global_position = place.global_position + Vector2(offset_half, offset_half) + place.size / 2
			get_node("../../..").use_item(Global.Current_slot)
			get_node("../../..").refresh_grid()
			Signals.bean_planted.emit()
