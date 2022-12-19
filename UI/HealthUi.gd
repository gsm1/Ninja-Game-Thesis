extends Control

onready var heartUIFull = $HeartUIFull
onready var heartUIEmpty = $HeartUIEmpty

var hearts = 10 setget set_hearts #setter-getter
var max_hearts = 10 setget set_max_hearts #setter-getter

func set_hearts(value):
	hearts = clamp(value, 0, max_hearts)
	if heartUIFull != null:
		heartUIFull.rect_size.x = hearts * 15 # πολλαπλασιαζουμε επι 15px και εμφανιζεται μια καρδια στο UI


func set_max_hearts(value):
	max_hearts = max(value, 1)
	self.hearts = min(hearts, max_hearts)
	if heartUIEmpty != null:
		heartUIEmpty.rect_size.x = max_hearts * 15 # πολλαπλασιαζουμε επι 15px και εμφανιζεται μια αδεια καρδια στο UI

func _ready():
	self.max_hearts = PlayerStats.max_health
	self.hearts = PlayerStats.health
	PlayerStats.connect("health_changed", self, "set_hearts")
	PlayerStats.connect("max_health_changed", self, "set_max_hearts")
