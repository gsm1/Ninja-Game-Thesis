extends KinematicBody2D


const UP = Vector2(0,-1) #οριζουμε το πανω
const GRAVITY =150
const ACC = 1000
var hitflag = true
var rockflag = true
var knockback = Vector2.ZERO
var hurt = false
export var MAX_SPEED = 300
const deatheffect = preload("res://HurtHitbox/DeathEffect.tscn") #για να κανουμε instance το deatheffect
export var FRICTION = 1000
onready var stats = $Stats
onready var portal = get_node(".Portal")
onready var sprite = $AnimationPlayer
onready var playerdetect = $PlayerDetectionZone
onready var playerrange = $PlayerInRange
onready var playerrock = $PlayerInRockThrow
onready var worldmusic = Music
var velocity = Vector2(0,0)
enum {
	IDLE,
	CHASE
}
var state = IDLE

func _ready():
	#απενεργοποιουμε τυχον ενεργα hitbox
	sprite.play("idle")
	$Hitbox.set_collision_mask_bit(2,false)
	$RockHitbox.set_collision_mask_bit(2,false)
	

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
			if hitflag == true and rockflag == true and stats.health>0 and hurt == false:
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
			throw_rock()



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
	knockback = area.knockback_vector * 250
	$Hitbox.set_collision_mask_bit(2,false)
	$RockHitbox.set_collision_mask_bit(2,false)
	hurt = true
	if stats.health > 0:
		stats.health -= area.damage
		sprite.play("hit")
#		Με τις 2 παρακατω εντολες κανουμε τα flags true, σε περιπτωση που δεν τελειωσαν τα αντιστοιχα animations επειδη ο εχθρος χτυπηθηκε
		rockflag = true
		hitflag = true
		yield(get_node("AnimationPlayer"), "animation_finished")
		sprite.play("idle")
		hurt = false

func _on_Stats_no_health():
	$Hitbox.set_collision_mask_bit(2,false)
	$RockHitbox.set_collision_mask_bit(2,false)
	sprite.play("die")
	velocity = Vector2.ZERO
	yield(get_node("AnimationPlayer"), "animation_finished")
	queue_free()
	var enemyDeathEffect = deatheffect.instance()
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.global_position = global_position
	enemyDeathEffect.scale = Vector2(5,5) #Μεγαλωνουμε το μεγεθος του deatheffect
	#Με τις παρακατω εντολες εμφανιζεται το portal ααφου πεθανει το boss και σταματαει η μουσικη του boss
	var portal = get_parent().get_node("Portal")
	portal.visible = true
	var area = portal.get_child(0)
	area.set_deferred("monitoring",true)
	worldmusic.stop_boss_music()
	worldmusic.play_music()

func hit_player():
	var player2 = playerrange.player
	#Αν ειναι σε κοντινο range ο παιχτης γινεται η πρωτη επιθεση
	if playerrange.can_hit_player() and stats.health > 0 and hurt == false and hitflag == true and rockflag == true:
		hitflag = false
		sprite.play("attack1")
		velocity.x = 0
		yield(get_node("AnimationPlayer"), "animation_finished")
		sprite.play("idle")
		
func throw_rock():
	#Αν ειναι σε πιο μακρινο range ο παιχτης γινεται η δευτερη επιθεση
	if playerrock.can_hit_player() and hitflag == true and rockflag == true and stats.health > 0 and hurt == false:
		rockflag = false
		velocity.x = 0
		sprite.play("attack2")
	
	
func rockthrow_finished():
	#Ελεγχος οτι το animation τελειωσε
	rockflag = true
	seek_player()

func hit_finished():
	#Ελεγχος οτι το animation τελειωσε
	hitflag = true
	seek_player()

func hitbox_enable():
#	Ενεργοποιουμε το hitbox της 1ης επιθεσης στο frame που θελουμε
	$Hitbox.set_collision_mask_bit(2,true)

func throw_hitbox_enable():
#	Ενεργοποιουμε το hitbox του τσεκουριου στο frame που θελουμε
	$RockHitbox.set_collision_mask_bit(2,true)
