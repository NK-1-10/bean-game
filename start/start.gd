extends CanvasLayer



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Signals.select.connect(selected)

func selected(who):
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
