extends Area2D


onready var heartempty = $Area2D/ExtraEmptyHeart
onready var healthregen = $Area2D/HealthRegen
export var heartfull = true # εντολη με την οποια καθοριζουμε αν το chest θα δινει εξτρα καρδια ή θα αναπληρωνει τις χαμενες μας καρδιες

func _ready():
	$AnimatedSprite.play()

func _on_Area2D_body_entered(body):
	$Area2D.queue_free()
	if heartfull == false:
		PlayerStats.max_health += 1
	else:
		PlayerStats.health = PlayerStats.max_health

func _on_PlayerNear_body_entered(body):
	$AudioStreamPlayer.play()
	if heartfull == false:
		heartempty.position.y -= 20
		heartempty.visible = true
	else:
		healthregen.position.y -= 20
		healthregen.visible = true
	#Απενεργοποιουμε το collision για να μην μπορουμε να ξαναπαρουμε την καρδια
	$PlayerNear/CollisionShape2D.set_deferred("disabled", true)
	$Area2D/Particles2D.visible = true
func _on_PlayerNear_body_exited(body):
	#Απενεργοποιουμε το area για να μην ξαναεμφανιζεται η κσρδια
	$PlayerNear.set_deferred("monitoring", false) 
	
