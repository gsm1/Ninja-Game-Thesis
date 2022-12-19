extends Control


onready var scene = get_tree()
onready var pause_overlay = $CanvasLayer
var paused = false setget set_paused

func _ready():
	pause_overlay.visible = false


func _unhandled_input(event: InputEvent):
	#ελεγχος για να μην μπορουμε να κανουμε pause στο cutscene και οταν εχουμε τερματισει το παιχνιδι
	if event.is_action_pressed("Pause") and PlayerStats.health >0 and PlayerStats.game_finsihed == false and  (get_tree().current_scene.name == "Level2" or  get_tree().current_scene.name == "Level1" or  get_tree().current_scene.name == "Level3"):
		self.paused = not paused
		scene.set_input_as_handled() #δεν μας επιτρεπει να δωσουμε input


func set_paused(value):
	paused = value
	scene.paused = value
	pause_overlay.visible = value


func _on_Quit_pressed():
	get_tree().quit()


func _on_MainMenu_pressed():
	self.paused = not paused
	get_tree().change_scene("res://UI/Menu.tscn")


func _on_Resume_pressed():
	self.paused = not paused
	
