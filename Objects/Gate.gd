extends StaticBody2D

func _on_Area2D_body_entered(body):
	#Οταν ειμαστε μπροστα απο την πυλη και εχουμε το κλειδι παιζει το animation
	if PlayerStats.key_obtained == true:
		$AnimatedSprite.play("default")
		$AudioStreamPlayer.play()
		get_node("CollisionShape2D").set_deferred("disabled", true)
		

func _on_Area2D_body_exited(body):
#	Αφου περασουμε την πρωτη πυλη το κλειδι παυει να λειτουργει στην επομενη
	PlayerStats.key_obtained = false
