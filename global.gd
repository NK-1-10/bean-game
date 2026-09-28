extends Node

var Squares = {}
var slots_taken = 0
var Current_slot = 0

var skip = false

var coins = 15
var beanstalk_spot = 4
var character = ""

var rows = 5
var columns = 8

var beanstalk_planted = false

func block_around(id, radius = 1):
	var row = Squares[id]["row"]
	var col = Squares[id]["column"]
	for r in range(row - radius, row + radius + 1):
		for c in range(col - radius, col + radius + 1):
			if r >= 0 and r < rows and c >= 0 and c < columns and abs(r - row) + abs(c - col) <= radius:
				Squares[r * columns + c + 1]["can_plant"] = false

func can_place_2x2(id):
	var row = Squares[id]["row"]
	var col = Squares[id]["column"]
	if row + 1 >= rows or col + 1 >= columns:
		return false  # would stick out of the grid
	for r in [row, row + 1]:
		for c in [col, col + 1]:
			if not Squares[r * columns + c + 1]["can_plant"]:
				return false
	return true

func block_2x2(id):
	var row = Squares[id]["row"]
	var col = Squares[id]["column"]
	for r in [row, row + 1]:
		for c in [col, col + 1]:
			Squares[r * columns + c + 1]["can_plant"] = false

func held_item():
	var key = str(Current_slot)
	if inventory.has(key):
		return inventory[key]["name"]
	return ""

func in_beanstalk_area(id):
	var row = Squares[id]["row"]
	var col = Squares[id]["column"]
	var srow = Squares[beanstalk_spot]["row"]
	var scol = Squares[beanstalk_spot]["column"]
	return row >= srow and row <= srow + 1 and col >= scol and col <= scol + 1

func can_place(id, item):
	if item == "bean":
		return id == beanstalk_spot and can_place_2x2(id)
	return Squares[id]["can_plant"] and not in_beanstalk_area(id)

var timer = 0.3
func typewriter(string, label):
	if skip : return
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	var text = ''
	label.text = text
	var s = str(string)
	await get_tree().create_timer(timer).timeout
	for n in range(s.length()):
		if s[n] == "." or s[n] == "?" or s[n] == "!":
			timer = 0.5
		else: timer = 0.04
		text = text + s[n]
		label.text = text
		await get_tree().create_timer(timer).timeout
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

var inventory = {}

func reset():
	coins = 15
	Squares = {}
	inventory = {}
	beanstalk_planted = false
	Current_slot = 0
	slots_taken = 0

var Collectables ={
	"plant":{
		"plantable" : true,
		"stackable" : true,
		"visual" : "res://assets/bean.PNG",
		"throwable" : false
	},
	"bean":{
		"plantable" : true,
		"stackable" : false,
		"visual" : "res://assets/beanstok.PNG",
		"throwable" : false
	},
	"water":{
		"plantable" : false,
		"stackable" : false,
		"visual": "res://assets/needs/canwwater.PNG",
		"throwable" : false
	},
	"food":{
		"plantable" : false,
		"stackable" : true,
		"visual": "res://assets/needs/food.PNG",
		"throwable" : true
	},
	"wateringcan":{
		"plantable" : false,
		"stackable" : false,
		"visual": "res://assets/needs/can.PNG",
		"throwable" : false
	},
}
