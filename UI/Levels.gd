extends Control


func _ready():
	#κανουμε load το save και ενεργοποιουμε αντιστοιχα τα κουμπια των level
	LevelsUnlocked.load_level()
	if LevelsUnlocked.level2 == true:
		$VBoxContainer/Level2.set_deferred("disabled", false) 
	if LevelsUnlocked.level3 == true:
		$VBoxContainer/Level3.set_deferred("disabled", false) 
func _on_Level1_pressed():
	#λειτουργια κουμπιου
	get_tree().change_scene("res://Cutscene.tscn")


func _on_Back_pressed():
	#λειτουργια κουμπιου
	get_tree().change_scene("res://UI/Menu.tscn")


func _on_Level2_pressed():
	#λειτουργια κουμπιου
	get_tree().change_scene("res://World/Level2.tscn")


func _on_Level3_pressed():
	#λειτουργια κουμπιου
	get_tree().change_scene("res://World/Level3.tscn")
