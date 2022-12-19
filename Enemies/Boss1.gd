extends KinematicBody2D


const UP = Vector2(0,-1) #οριζουμε το πανω
const GRAVITY =150 #βαρυτητσ
const ACC = 1000 #επιταχυνση
export var MAX_SPEED = 300 #μεγιστη ταχυτητα
export var FRICTION = 1000 #τριβη
var hitflag = true
var axeflag = true
var knockback = Vector2.ZERO
var hurt = false
const deatheffect = preload("res://HurtHitbox/DeathEffect.tscn") #για να κανουμε instance το deatheffect
onready var stats = $Stats
onready var sprite = $AnimationPlayer
onready var playerdetect = $PlayerDetectionZone
onready var playerrange = $PlayerInRange
onready var playeraxe = $PlayerInAxeThrow
onready var worldmusic = Music
var velocity = Vector2(0,0)
onready var portal = get_node(".Portal") 

enum {
	IDLE,
	CHASE
}
var state = IDLE

func _ready():

	sprite.play("idle")
	#απενεργοποιουμε τυχον ενεργα hitbox
	$Hitbox.set_collision_mask_bit(2,false)
	$ThrowHitbox.set_collision_mask_bit(2,false)

	

func _physics_process(delta):
	
	apply_gravity()
	move_and_slide(velocity, UP)
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta) #το knockback που λαμβανει απο τον παιχτη
	knockback = move_and_slide(knockback)
	velocity = move_and_slide(velocity)
	match state:
		IDLE:
			#οταν ειναι ακινητο και ψαχνει τον παιχτη
			sprite.play("idle")
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			seek_player()
		CHASE:
			#οταν ο παιχτης εισερχεται στο area του boss
			var player = playerdetect.player
			if hitflag == true and axeflag == true and stats.health>0 and hurt == false:
				sprite.play("run")
				if player != null:
					#τρεχει προσ τον παιχτη
					var direction = (player.global_position - global_position).normalized()
					velocity = velocity.move_toward(direction * MAX_SPEED, ACC * delta)
				else:
					#σταματαει οταν δεν "βλεπει" τον παιχτη
					state = IDLE
			if velocity.x < 0 and hurt == false and stats.health > 0:
				#αλλαγη κατευθυβσης sprite
				scale.x = scale.y * 1
			elif velocity.x > 0 and hurt == false and stats.health > 0:
				#αλλαγη κατευθυβσης sprite
				scale.x = scale.y * -1
			if stats.health <= 0:
				velocity.x = 0
				_on_Stats_no_health()
			hit_player()
			throw_axe()



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
		#οταν βρισκει τον παιχτη αν δεν παιζει η μουσικη του boss ξεκιναει,αλλιως pass
		if worldmusic.play_boss_music() == true:
			pass
		else:
			worldmusic.play_boss_music()
		worldmusic.stop_music()
		state = CHASE

func _on_Hurtbox_area_entered(area):
	velocity.x = 0
	knockback = area.knockback_vector * 350
#	Με τις 2 παρακατω εντολες απενεργοποιουμε τα hitbox που τυχον εμειναν απο unfinished animation
	$Hitbox.set_collision_mask_bit(2,false)
	$ThrowHitbox.set_collision_mask_bit(2,false)
	hurt = true
	if stats.health > 0:
		stats.health -= area.damage
		sprite.play("hit")
#		Με τις 2 παρακατω εντολες κανουμε τα flags true, σε περιπτωση που δεν τελειωσαν τα αντιστοιχα animations επειδη ο εχθρος χτυπηθηκε
		axeflag = true
		hitflag = true
		yield(get_node("AnimationPlayer"), "animation_finished")
		sprite.play("idle")
		hurt = false
func _on_Stats_no_health():
#	Με τις 2 παρακατω εντολες απενεργοποιουμε τα hitbox που τυχον εμειναν απο unfinished animation
	$Hitbox.set_collision_mask_bit(2,false)
	$ThrowHitbox.set_collision_mask_bit(2,false)
	sprite.play("die")
	velocity = Vector2.ZERO
	yield(get_node("AnimationPlayer"), "animation_finished")
	queue_free()
	var enemyDeathEffect = deatheffect.instance()
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.scale = Vector2(5,5) #Μεγαλωνουμε το μεγεθος του deatheffect
	enemyDeathEffect.global_position = global_position
	#Με τις παρακατω εντολες εμφανιζεται το portal ααφου πεθανει το boss και σταματαει η μουσικη του boss
	var portal = get_parent().get_node("Portal") 
	var area = portal.get_child(0)
	area.set_deferred("monitoring",true)
	portal.visible = true
	worldmusic.stop_boss_music()
	worldmusic.play_music()

func hit_player():
	var player2 = playerrange.player
	#Αν ειναι σε κοντινο range ο παιχτης γινεται η πρωτη επιθεση
	if playerrange.can_hit_player() and stats.health > 0 and hurt == false and axeflag == true and hitflag == true:
		hitflag = false
		sprite.play("attack")
		velocity.x = 0
		yield(get_node("AnimationPlayer"), "animation_finished")
		sprite.play("idle")

func throw_axe():
	#Αν ειναι σε πιο μακρινο range ο παιχτης γινεται η δευτερη επιθεση
	if playeraxe.can_hit_player() and hitflag == true and stats.health > 0 and hurt == false and axeflag == true:
		axeflag = false
		velocity.x = 0
		sprite.play("axethrow")


func throw_axe_finished():
#	Ελεγχος οτι το animation τελειωσε
	axeflag = true
	seek_player()

func hit_finished1():
#	Ελεγχος οτι το animation τελειωσε
	hitflag = true
	seek_player()
func hitbox_enable():
#	Ενεργοποιουμε το hitbox της 1ης επιθεσης στο frame που θελουμε
	$Hitbox.set_collision_mask_bit(2,true)

func throw_hitbox_enable():
#	Ενεργοποιουμε το hitbox του τσεκουριου στο frame που θελουμε
	$ThrowHitbox.set_collision_mask_bit(2,true)

