extends KinematicBody2D


const UP = Vector2(0,-1) #οριζουμε το πανω
const GRAVITY =150 #βαρυτητσ
const ACC = 1000 #επιταχυνση
export var MAX_SPEED = 300 #μεγιστη ταχυτητα
export var FRICTION = 1000 #τριβη
var hitflag = true
var hurt = false
export var has_key = false
var knockback = Vector2.ZERO
const deatheffect = preload("res://HurtHitbox/DeathEffect.tscn") #για να κανουμε instance το deatheffect
var KEY = preload("res://Objects/Key.tscn") #για να κανουμε instance το κλειδι
onready var stats = $Stats
onready var sprite = $AnimationPlayer
onready var playerdetect = $PlayerDetectionZone
onready var playerrange = $PlayerInRange
var velocity = Vector2(0,0)
enum {
	IDLE,
	CHASE
	
}
var state = IDLE

func _ready():
	#απενεργοποιουμε τυχον ενεργα hitbox
	$Hitbox.set_collision_mask_bit(2,false)
	$HitboxStun.set_collision_mask_bit(2,false)
	sprite.play("idle")

	

func _physics_process(delta):
	apply_gravity()
	move_and_slide(velocity, UP)
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta) #το knockback που λαμβανει απο τον παιχτη
	knockback = move_and_slide(knockback)
	match state:
		IDLE:
			#οταν ειναι ακινητο και ψαχνει τον παιχτη
			if stats.health >0:
				sprite.play("idle")
				velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
				seek_player()
		CHASE:
			#οταν ο παιχτης εισερχεται στο area του 
			var player = playerdetect.player
			if hitflag == true and stats.health>0 and hurt == false:
				
				sprite.play("run")
			if player != null:
				#τρεχει προσ τον παιχτη
				var direction = (player.global_position - global_position).normalized()
				velocity = velocity.move_toward(direction * MAX_SPEED, ACC * delta)
			else:
				#σταματαει οταν δεν "βλεπει" τον παιχτη
				state = IDLE
			if velocity.x < 0 and stats.health > 0:
				#αλλαγη κατευθυβσης sprite
				scale.x = scale.y * 1
			elif velocity.x > 0 and stats.health > 0:
				#αλλαγη κατευθυβσης sprite
				scale.x = scale.y * -1
			if stats.health <= 0:
				velocity.x = 0
				_on_Stats_no_health()
			hit_player()
	velocity = move_and_slide(velocity)
func apply_gravity():
	#Εφαρμοζουμε τη βαρυτητα
	if is_on_floor() and velocity.y > 0 :
		velocity.y = 0
	elif is_on_ceiling():
		velocity.y = 1
	else:
		velocity.y += GRAVITY

func seek_player():
	if playerdetect.can_see_player():
		state = CHASE

func _on_Hurtbox_area_entered(area):
	velocity.x = 0
	knockback = area.knockback_vector * 250
	#	Με τις 2 παρακατω εντολες απενεργοποιουμε τα hitbox που τυχον εμειναν απο unfinished animation
	$Hitbox.set_collision_mask_bit(2,false)
	$HitboxStun.set_collision_mask_bit(2,false)
	hurt  = true
	if stats.health > 0:
		stats.health -= area.damage
		sprite.play("hit")
		hitflag = true
		yield(get_node("AnimationPlayer"), "animation_finished")
		sprite.play("idle")
		hurt = false


func _on_Stats_no_health():
	sprite.play("die")
	velocity = Vector2.ZERO
	#Με τις 2 παρακατω εντολες απενεργοποιουμε τα hitbox που τυχον εμειναν απο unfinished animation
	$Hitbox.set_collision_mask_bit(2,false)
	$HitboxStun.set_collision_mask_bit(2,false)
	yield(get_node("AnimationPlayer"), "animation_finished")
	queue_free()
	var enemyDeathEffect = deatheffect.instance()
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.global_position = global_position
	if has_key == true:
		#Ριχνει το κλειδι εαν το εχει
		if KEY:
			var key = KEY.instance()
			get_parent().add_child(key)
			key.global_position = global_position
		


func hit_player():
	#Αν ειναι σε κοντινο range ο παιχτης γινεται η επιθεση
	var player2 = playerrange.player
	if playerrange.can_hit_player() and stats.health > 0 and hurt ==false and hitflag == true:
		hitflag = false
		if player2 != null and stats.health > 0 and hurt ==false:
			sprite.play("attack1")
			velocity.x = 0
			yield(get_node("AnimationPlayer"), "animation_finished")
			sprite.play("idle")

func hit_finished1():
	#Ελεγχος οτι το animation τελειωσε
	hitflag = true
	seek_player()

func hitbox_enable():
#	Ενεργοποιουμε το hitbox της 1ης επιθεσης στο frame που θελουμε
	$Hitbox.set_collision_mask_bit(2,true)

func stun_hitbox_enable():
#	Ενεργοποιουμε το hitbox του stun στο frame που θελουμε
	$HitboxStun.set_collision_mask_bit(2,true)
