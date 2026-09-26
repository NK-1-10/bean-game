extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body.name != "player": return
	if get_tree().current_scene.inventoryChange("food", 1):
		get_parent().queue_free()
		Signals.pickUpFood.emit()
