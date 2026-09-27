extends CanvasLayer
@onready var piece = $middle
@onready var txt = $Label/Label
var s = Vector2(597.0, 23)
var e = Vector2(597, -1000.0)

var startingx = 549
var startingy = 549

var height = 224.0
var speed = 100.0   # pixels per second
var count = 4       # how many pieces are stacked

var pieces = [
	preload("res://assets/middle.PNG"),
	preload("res://assets/middle2.PNG"),
	preload("res://assets/middle3.PNG"),
	preload("res://assets/middle4.PNG"),
]
var list = []

func _ready() -> void:
	txt.position = s
	for i in range(count):
		var p = Sprite2D.new()
		p.texture = pieces.pick_random()
		p.scale = Vector2(7, 7)
		p.position = Vector2(startingx, startingy - i * height)
		piece.add_child(p)
		list.append(p)
	var tween = create_tween()
	tween.tween_property(txt, "position", e, 20)
	await tween.finished
	start_end()

func _process(delta: float) -> void:
	for p in list:
		p.position.y += speed * delta
		if p.position.y > startingy + height:   # fell off the bottom
			p.position.y -= count * height       # back to the top
			p.texture = pieces.pick_random()


func start_end():
	Fade.change_scene("res://main.tscn")
