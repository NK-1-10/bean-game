extends Node2D
@onready var top = $top
@onready var bottom = $bottom
@onready var middle = $middle

var middles = [
	preload("res://assets/middle.PNG"),
	preload("res://assets/middle2.PNG"),
	preload("res://assets/middle3.PNG"),
	preload("res://assets/middle4.PNG"),
]
var ammount

var stack = 0  
var offset = -32

func _ready() -> void:
	ammount = middles.size()
	top.position = Vector2(0, offset)

func chunks():
	stack += 1
	top.position = Vector2(0, offset + stack*offset)
	var roll = randi_range(0, ammount-1)
	
	var new_middle = Sprite2D.new()
	new_middle.texture = middles[roll]
	new_middle.position = Vector2(0, stack*offset)
	middle.add_child(new_middle)
	

func _on_button_pressed() -> void:
	chunks()
