extends Control


onready var scene = get_tree()
onready var pause_overlay = $CanvasLayer
var paused = false setget set_paused


func _ready():
	#αρχικα η οθονη του losescreen ειναι αορατη
	pause_overlay.visible = false
	

func set_paused(value):
	#οταν πεθαινουμε γινεται paused
	paused = value
	scene.paused = value
	pause_overlay.visible = value
	

func _on_TryAgain_pressed():
	#παρακατω οριζονται η αρχικη ζωη του εκαστοτε level,το κλειδι ως false και η ultra
	if get_tree().current_scene.name == "Level1":
		PlayerStats.max_health = 5
		PlayerStats.health = 5
	elif get_tree().current_scene.name == "Level2":
		PlayerStats.max_health = PlayerStats.max_health_lv2
		PlayerStats.health = PlayerStats.max_health_lv2
	elif get_tree().current_scene.name == "Level3":
		PlayerStats.max_health = PlayerStats.max_health_lv3
		PlayerStats.health = PlayerStats.max_health_lv3
	PlayerStats.ultra = 0
	PlayerStats.key_obtained = false
	self.paused = not paused
	Music.stop_lose_music()
	Music.play_music()
	get_tree().reload_current_scene()


func _on_MainMenu_pressed():
	self.paused = not paused
	Music.stop_lose_music()
	get_tree().change_scene("res://UI/Menu.tscn")


func _on_Quit_pressed():
	get_tree().quit()
