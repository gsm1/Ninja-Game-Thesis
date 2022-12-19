extends KinematicBody2D


const UP = Vector2(0,-1) #οριζουμε το πανω
const GRAVITY =150 #βαρυτητσ
const ACC =500 #επιταχυνση
export var MAX_SPEED = 500 #μεγιστη ταχυτητα
export var FRICTION = 1000 #τριβη
var hitflag = true
var keyflag = true
var KEY = preload("res://Objects/Key.tscn") #για να κανουμε instance το deatheffect
onready var sprite = $AnimationPlayer
onready var enemydetect = $EnemyDetectionZone
onready var enemyrange = $EnemyInRange
onready var playerdetect = $PlayerDetectionZone
var velocity = Vector2(0,0)
enum {
	IDLE,
	CHASE,
	FOLLOW
	CAGE
}
var state = CAGE #το αρχικο state εφοσον ειναι μεσα στο κλουβι

func _ready():
	#απενεργοποιουμε τυχον ενεργα hitbox
	$Hitbox.set_collision_mask_bit(2,false)
	sprite.play("idle")

func _physics_process(delta):
	apply_gravity()
	move_and_slide(velocity, UP)
	if state != CAGE:
		#αν δεν ειναι στο κλουβι ψαχνει εχθρους
		seek_enemy()
	match state:
		
		IDLE:
			#οταν ειναι ακινητο και ψαχνει τον παιχτη ή τον εχθρο
			sprite.play("idle")
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			seek_enemy()
			seek_player()
		CHASE:
			#οταν ο εχθρος εισερχεται στο area του 
			var enemy = enemydetect.player
			if hitflag == true:
				sprite.play("run")
			if enemy != null :
				#τρεχει προσ τον εχθρο
				var direction = (enemy.global_position - global_position).normalized()
				if abs(enemy.global_position.x - global_position.x) < 20:
					#αν φτασει αρκετα κοντα ωστε να επιτεθει σταματαει
					velocity.x = 0
				else:
					#αλλιως συνεχιζει να τρεχει προς τον εχθρο
					velocity = velocity.move_toward(direction * MAX_SPEED, ACC * delta)
			else:
				state = FOLLOW
			hit_enemy()
		FOLLOW:
			#τρεχει προσ τον παιχτη
			seek_enemy()
			var player = playerdetect.player
			if player!= null:
				if abs(player.global_position.x - global_position.x) > 300:
					#δεν πλησιαζει λιγορετο απο την ορισμενη αποσταση τον παιχτη
						sprite.play("run")
						var direction = (player.global_position - global_position).normalized()
						velocity = velocity.move_toward(direction * MAX_SPEED, ACC * delta)
				else:
					sprite.play("idle")
					velocity = Vector2.ZERO
					state = IDLE
		CAGE:
			#οταν ειναι στο κλουβι
			sprite.play("idle")
			scale.x = scale.y * -1
	if velocity.x < 0 :
		#αλλαγη κατευθυβσης sprite
		scale.x = scale.y * -1
	elif velocity.x > 0 :
		#αλλαγη κατευθυβσης sprite
		scale.x = scale.y * 1
	velocity = move_and_slide(velocity)
func apply_gravity():
	#Εφαρμοζουμε τη βαρυτητα
	if is_on_floor() and velocity.y > 0 :
		velocity.y = 0
	elif is_on_ceiling():
		velocity.y = 1
	else:
		velocity.y += GRAVITY

func seek_enemy():
	if enemydetect.can_see_player() :
		#οταν βρισκει εχθρο 
		state = CHASE
	else:
		#αλλιως ψαχνει τον παιχτη
		seek_player()
func seek_player():
	if playerdetect.can_see_player():
		state = FOLLOW

func give_key():
	if KEY:
		#εμφανιζει το κλειδι σε προκαθορισμενη θεση
		var key = KEY.instance()
		get_parent().add_child(key)
		key.global_position.y = global_position.y
		key.global_position.x = global_position.x + 150

func hit_enemy():
	var enemy2 = enemyrange.player
	if enemyrange.can_hit_player() :
		#οταν ειναι σε range για επιθεση 
		hitflag = false
		if enemy2 != null:
			sprite.play("attack1")
			velocity.x = 0
			yield(get_node("AnimationPlayer"), "animation_finished")
			sprite.play("idle")

func hit_finished1():
	#ελεγχος οτι το animation τελειωσε
	hitflag = true
	seek_enemy()

func hitbox_enable():
#	Ενεργοποιουμε το hitbox της 1ης επιθεσης στο frame που θελουμε
	$Hitbox.set_collision_mask_bit(3,true)

