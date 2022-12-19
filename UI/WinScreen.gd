extends CanvasLayer


onready var scene = get_tree()
#var paused = false setget set_paused

func _ready():
	self.visible = false

#func set_paused(value):
#	paused = value
#	scene.paused = value
#	self.visible = value


func _on_MainMEnu_pressed():
#	self.paused = not paused
	Music.stop_win_music()
	get_tree().change_scene("res://UI/Menu.tscn")

func _on_Quit_pressed():
	get_tree().quit()
