extends Control

func _ready():
	Music.play_music() #η μουσικη του μενου
	
func _on_Levels_pressed():
	get_tree().change_scene("res://UI/Levels.tscn")

func _on_Options_pressed():
	get_tree().change_scene("res://UI/Options.tscn")

func _on_Quit_pressed():
	get_tree().quit()
