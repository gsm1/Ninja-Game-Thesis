extends Area2D

func _ready():
	$AnimatedSprite.play("idle")

func _on_PlayerNear_body_entered(body):
	#Οταν ο παιχτης ειναι κοντα εμφανιζεται ο ταφος
	$AudioStreamPlayer.play()
	$AnimatedSprite.play("default")

func _on_PlayerNear_body_exited(body):
	$PlayerNear.set_deferred("monitoring", false) 

func _on_Tombstone_body_entered(body):
	if PlayerStats.ultra < 3:
		PlayerStats.ultra += 1
	$PlayerNear/CollisionShape2D.disabled = true
	self.set_deferred("monitoring",false)

