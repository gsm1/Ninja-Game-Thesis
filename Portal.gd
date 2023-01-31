extends Node2D

func _ready():
	$Area2D/AnimationPlayer.play("PortalStrech")
	
	
func _physics_process(delta):
	if self.visible == true and $AudioStreamPlayer.playing == false:
		$AudioStreamPlayer.play()

func _on_Area2D_body_entered(body):
	#Ελεγχος σε ποιο level ειμαστε
	if get_tree().current_scene.name == "Level1":
		get_tree().change_scene("res://World/Level2.tscn")
		PlayerStats.health = PlayerStats.max_health
		PlayerStats.ultra = 0
		PlayerStats.key_obtained = false
	elif get_tree().current_scene.name == "Level2":
		PlayerStats.health = PlayerStats.max_health
		PlayerStats.ultra = 0
		PlayerStats.key_obtained = false
		get_tree().change_scene("res://World/Level3.tscn")

