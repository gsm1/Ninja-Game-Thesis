extends Area2D

# οριζουμε την απαραιτητη μεταβλητη και τα σηματα ωστα να δωσουμε στον παιχτη ενα χρονο που θα ειναι ατρωτος μετα απο καθε χτυπημα
var invincible = false setget set_invincible
onready var timer = $Timer
signal invincibility_started
signal invincibility_ended


func start_invincibility(duration):
	self.invincible = true
	timer.start(duration) #o παιχτης θα ειναι ατρωτος για ενα χρονικο διαστημα που οριζουμε εμεις

func set_invincible(value):
	invincible = value
	if invincible == true:
		emit_signal("invincibility_started")
	else:
		emit_signal("invincibility_ended")

func _on_Timer_timeout():
	self.invincible = false


func _on_Hurtbox_invincibility_ended():
	#ενεργοποιουμε το collision του hurtbox οταν τελειωσει ο χρονος
	$CollisionShape2D.set_deferred("disabled", false)


func _on_Hurtbox_invincibility_started():
	#απενεργοποιουμε το collision του hurtbox για οσο ειμαστε ατρωτοι
	$CollisionShape2D.set_deferred("disabled", true)
