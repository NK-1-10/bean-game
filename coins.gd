extends Node

func _ready() -> void:
	Signals.coins_change.connect(coin)

func coin(ammount):
	Global.coins += ammount
	var txt = "Coins : " + str(Global.coins)
	Signals.updateCoins.emit(txt)
