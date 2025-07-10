extends Node

var score = 0

@onready var coin_label: Label = $HUD/CanvasLayer/CoinCounter/CoinLabel

func add_point():
	score += 1
	#print(score)
	coin_label.text = "X " + str(score)
