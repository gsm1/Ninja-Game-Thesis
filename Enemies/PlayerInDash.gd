extends Area2D

var player = null 

func can_hit_player():
	return player != null

func _on_PlayerInDash_body_entered(body):
	#αν υπαρχει ο παιχτης στο area τον επιστρεφει
	player = body


func _on_PlayerInDash_body_exited(body):
	#αλλιως null
	player = null
