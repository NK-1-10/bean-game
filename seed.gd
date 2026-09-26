extends Area2D

var direction = Vector2.RIGHT
@export var speed = 200
var damage = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	position += direction * speed * delta


func _on_body_exited(body: Node2D) -> void:
	if body.has_method("takeDamage"):
		body.takeDamage(damage)
		queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free() 
