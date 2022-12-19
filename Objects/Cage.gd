extends StaticBody2D

func _on_Area2D_body_entered(body):
	#παιζει το animation οταν ο παιχτης μπει στην περιοχη
	$AnimationPlayer.play("default")
	$Area2D.set_deferred("monitoring",false)
