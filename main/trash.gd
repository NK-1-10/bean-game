extends StaticBody2D
@onready var paper = $paper
@onready var plastic = $plastic
@onready var metal = $metal
@onready var trash = $"."
var total_trash = 0

func _ready() -> void:
	paper.visible = false ; metal.visible = false ; plastic.visible = false

func _on_timer_timeout() -> void:
	if total_trash > 4: return

	print('trash.')
	var new_trash = trash.duplicate()

	get_parent().add_child(new_trash)

	var chosen = randi_range(1, 3)
	if chosen == 1:
		new_trash.get_node("paper").visible = true 
		new_trash.add_to_group("paper")
	elif chosen == 2:
		new_trash.get_node("plastic").visible = true
		new_trash.add_to_group("plastic")
	else:
		new_trash.get_node("metal").visible = true
		new_trash.add_to_group("metal")

	var mark = randi_range(1, 7)
	if mark == 1:
		new_trash.global_position = $"../markers/one".global_position
	elif mark == 2:
		new_trash.global_position = $"../markers/two".global_position
	elif mark == 3:
		new_trash.global_position = $"../markers/three".global_position
	elif mark == 4:
		new_trash.global_position = $"../markers/four".global_position
	elif mark == 5:
		new_trash.global_position = $"../markers/five".global_position
	elif mark == 6:
		new_trash.global_position = $"../markers/six".global_position
	elif mark == 7:
		new_trash.global_position = $"../markers/seven".global_position

	total_trash += 1
