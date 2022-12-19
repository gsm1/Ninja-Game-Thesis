extends Control

onready var UltraUIFull = $UltraUIFull
onready var UltraUIEmpty = $UltraUIEmpty

var ultras = 0 setget set_tokens

func set_tokens(value):
	ultras = clamp(value, 0, 3)
	if UltraUIFull != null:
		UltraUIFull.rect_size.x = ultras * 20 # πολλαπλασιαζουμε επι 20px και εμφανιζεται ενας ρομβος στο UI της ultra μας

func _ready():
	self.ultras = PlayerStats.ultra
	PlayerStats.connect("ultra_changed", self, "set_tokens")
