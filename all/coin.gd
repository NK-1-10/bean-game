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


func _on_area_entered(area: Area2D) -> void:
	Global.coins += randi_range(1, 3)
