extends "res://HurtHitbox/Hitbox.gd"


export var SPEED = 1000


func _physics_process(delta):
	#Οριζουμε κατευθυνση και ταχυτητα του axe
	var direction = Vector2.RIGHT.rotated(rotation)
	global_position += SPEED*direction*delta

func destroy():
	queue_free()

func _on_Projectile_area_entered(area):
	#οταν χτυπαει αντικειμενο καταστρεφεται
	destroy()


func _on_Projectile_body_entered(body):
	#οταν χτυπαει σωμα καταστρεφεται
	destroy()


func _on_VisibilityNotifier2D_screen_exited():
	#οταν βγαινει απο την οθονη καταστρεφεται
	queue_free()
