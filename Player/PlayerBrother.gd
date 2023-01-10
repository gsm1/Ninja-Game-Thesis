extends KinematicBody2D
const UP = Vector2(0,-1) #οριζουμε το πανω
const GRAVITY =150 #βαρυτητσ
onready var stats = $Stats
onready var sprite = $AnimationPlayer

var velocity = Vector2(0,0)

func _physics_process(delta):
	apply_gravity()
	move_and_slide(velocity, UP)

func apply_gravity():
	#Εφαρμοζουμε τη βαρυτητα
	if is_on_floor() and velocity.y > 0 :
		velocity.y = 0
	elif is_on_ceiling():
		velocity.y = 1
	else:
		velocity.y += GRAVITY

func _on_Hurtbox_area_entered(area):
	velocity.x = 0
	sprite.play("die")
	yield(get_node("AnimationPlayer"), "animation_finished")
	queue_free()

func cutscenerun():
	#function ωστε να τρεχει οταν θελουμε στο cutscene
	sprite.play("run")

func _on_Area2D_body_entered(body):
	#function ωστε να ειναι ακινητος οταν θελουμε στο cutscene
	if stats.health>0:
		sprite.play("idle")
