extends Area2D

var direction = Vector2.RIGHT
@export var speed = 200
@export var damage = 10

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	position += direction * speed * delta


func _on_body_exited(body: Node2D) -> void:
	if body.has_method("takeDamage"):
		body.takeDamage(damage)
	queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free() 
