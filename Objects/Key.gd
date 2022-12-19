extends Area2D

func _ready():
	$AnimatedSprite.play("default")

func _on_Key_body_entered(body):
	PlayerStats.key_obtained = true #ενημερωνεται το script του παιχτη οτι εχει το κλειδι
	queue_free()
