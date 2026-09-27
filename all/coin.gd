extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var firstTween = create_tween()
	var time = randf_range(0.6, 1.2)
	firstTween.tween_property($CoinSheet, "position", 
	Vector2(0, -randi_range(16, 72)), time / 2)
	
	firstTween.play()
	await firstTween.finished
	
	var secondTween = create_tween()
	secondTween.tween_property($CoinSheet, "position", Vector2(0, 0), time / 2)
	secondTween.play()

func _on_anim_timer_timeout() -> void:
	if $CoinSheet.frame == 3:
		$CoinSheet.frame = 0
	else:
		$CoinSheet.frame += 1

func _on_body_entered(body: Node2D) -> void:
	print("touched by: ", body.name)
	if body.name != "player": return
	var c = randi_range(1, 3)
	Global.coins += c
	Signals.coins_change.emit(c)
	queue_free()
