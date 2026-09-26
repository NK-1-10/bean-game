extends Node2D

@onready var hi = $"../highlight2"

var paint = Color.WHITE

var maid = Vector2(22, 152)
var pumpkin = Vector2(322, 152)
var elf = Vector2(622, 152)
var frog = Vector2(922, 152)
var target
var selected = false
var current

func _ready() -> void:
	pan.position = Vector2(0, 658)
	paint = hi.color
	position = hi.position
	queue_redraw()

func _draw():
	var width = hi.size.x
	var height = hi.size.y
	var center = Vector2(width / 2, height)
	var radius = width / 2
	var points = PackedVector2Array()
	for i in range(33):
		var angle = PI * i / 32.0
		points.append(center + Vector2(cos(angle), sin(angle)) * radius)
	draw_colored_polygon(points, paint)

func move(where):
	down()
	p.color_initial_ramp = shade
	target = where
	moverlay.visible = true ; poverlay.visible = true ; eoverlay.visible = true ; foverlay.visible = true
	maid1.play('idle') ; pump.play('idle') ; elf1.play('idle') ; frog1.play('idle')
	selected = false
	var tween = create_tween().set_parallel()
	tween.tween_property(hi, "position", where, 0.5)
	tween.tween_property(self, "position", where, 0.5)
	await tween.finished
	if where != target: return   # player already moved to someone else
	reveal(where)


@onready var maid1 = $"../HBoxContainer/maid/maid"
@onready var moverlay = $"../HBoxContainer/maid/maid/overlay"
@onready var pump = $"../HBoxContainer/pumpkin/pumpkin"
@onready var poverlay = $"../HBoxContainer/pumpkin/pumpkin/overlay"
@onready var elf1 = $"../HBoxContainer/elf/elf"
@onready var eoverlay = $"../HBoxContainer/elf/elf/overla"
@onready var frog1 = $"../HBoxContainer/frog/frog"
@onready var foverlay = $"../HBoxContainer/frog/frog/overlay"

var shade = preload("res://gradients/basic.tres")
var frogshade = preload("res://gradients/frog.tres")
var maidshade = preload("res://gradients/maid.tres")
var punpkinshade = preload("res://gradients/pumpkin.tres")
var elfshade = preload("res://gradients/elf.tres")

var char_gradients = {
	"Maid": maidshade,
	"Pumpkin": punpkinshade,
	"Elf": elfshade,
	"Frog": frogshade,
}

@onready var p = $"../particle/CPUParticles2D"

func set_particle(who):
	p.color_initial_ramp = char_gradients[who]
	p.color = Color.WHITE

func reveal(who):
	var w
	selected = true
	if who == maid:
		moverlay.visible = false
		maid1.play('walk')
		current = "Maid"
	elif who == pumpkin:
		poverlay.visible = false
		pump.play('walk')
		current="Pumpkin"
	elif who == elf:
		eoverlay.visible = false
		elf1.play('walk')
		current = "Elf"
	else : 
		foverlay.visible = false
		frog1.play('walk')
		current= "Frog"
	set_particle(current)


var can_move = true
@onready var pan =  $"../Panel"
func up(who):
	var txt = "Selected: " + who
	$"../Panel/Label".text = txt
	var tween = create_tween()
	tween.tween_property(pan, "position", Vector2(0, 558), 0.4)
	can_move = false

func down():
	var tween = create_tween()
	tween.tween_property(pan, "position", Vector2(0, 658), 0.4)



func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if selected:
			if can_move: up(current)
			else: can_move = true

func _on_start_pressed() -> void:
	can_move = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	var sprite ; var one; var two ; var three
	var four; var five ; var six
	if current == "Maid":
		sprite = maid1
		one = eoverlay; two = foverlay; three = poverlay
		four = elf1; five = frog1; six = pump
	elif current == "Elf":
		sprite = elf1
		four = maid1; five = frog1; six = pump
		one = moverlay; two = foverlay; three = poverlay
	elif current == "Frog":
		sprite = frog1
		four = elf1; five = maid1; six = pump
		one = eoverlay; two = moverlay; three = poverlay
	else:
		sprite = pump
		four = elf1; five = frog1; six = maid1
		one = eoverlay; two = foverlay; three = moverlay
	sprite.play('idle')
	one.play('back') ; two.play('back') ; three.play('back') 
	four.play('back') ; five.play('back') ; six.play('back') 
	var tween = create_tween().set_parallel()
	tween.tween_property(one, "scale", Vector2(1, 1), 1.5)
	tween.tween_property(two, "scale", Vector2(0.8, 0.8), 1.5)
	tween.tween_property(three, "scale", Vector2(0.9, 0.9), 1.5)
	tween.tween_property(four, "scale", Vector2(0.5, 0.5), 1.5)
	tween.tween_property(five, "scale", Vector2(0.5, 0.5), 1.5)
	tween.tween_property(six, "scale", Vector2(0.5, 0.5), 1.5)
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	await tween.finished
	Signals.selected.emmit(current)










func _on_maid_mouse_entered() -> void:
	if can_move: move(maid)

func _on_pumpkin_mouse_entered() -> void:
	if can_move: move(pumpkin)

func _on_elf_mouse_entered() -> void:
	if can_move: move(elf)

func _on_frog_mouse_entered() -> void:
	if can_move: move(frog)
