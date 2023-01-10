extends CanvasLayer


onready var scene = get_tree()

func _ready():
	self.visible = false

func _on_MainMEnu_pressed():
	Music.stop_win_music()
	get_tree().change_scene("res://UI/Menu.tscn")

func _on_Quit_pressed():
	get_tree().quit()
