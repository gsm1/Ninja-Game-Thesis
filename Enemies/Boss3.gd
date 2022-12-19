extends KinematicBody2D

const UP = Vector2(0,-1) #οριζουμε το πανω
const GRAVITY =150 #βαρυτητσ
const ACC = 1000 #επιταχυνση
export var MAX_SPEED = 300 #μεγιστη ταχυτητα
export var FRICTION = 1000 #τριβη
var hitflag = true
var dashflag = true
var cutsceneflag = false
var knockback = Vector2.ZERO
var hurt = false
const deatheffect = preload("res://HurtHitbox/DeathEffect.tscn") #για να κανουμε instance το deatheffect
onready var stats = $Stats
onready var sprite = $AnimationPlayer
onready var playerdetect = $PlayerDetectionZone
onready var playerrange = $PlayerInRange
onready var playerdash = $PlayerInDash
onready var worldmusic = Music
signal boss_died
var velocity = Vector2(0,0)

enum {
	IDLE,
	CHASE
	CUTSCENE
}
var state = IDLE

func _ready():
	if get_tree().current_scene.name != "Cutscene":
		#αν δεν βρισκομαστε σε cutscene ενεργοποιουμε ολες τις δυνατοτητες του boss
		$PlayerInDash.set_deferred("monitoring",true)
		$Hitbox.set_collision_mask_bit(2,false)
		$HitboxDash.set_collision_mask_bit(2,false)
		$PlayerDetectionZone.set_deferred("monitoring",true)
		playerrange.set_deferred("monitoring",true)

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
			if hitflag == true and dashflag == true and stats.health>0 and hurt == false:
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
			dash_attack()
		CUTSCENE:
			#oταν ειναι σε cutscene απενεργοποιουμε τις δυνατοτητες του boss
			$PlayerInRange.set_deferred("monitoring",false)
			$PlayerDetectionZone.set_deferred("monitoring",false)
			$PlayerInDash.set_deferred("monitoring",false)

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
		if worldmusic.play_boss_music() == true:
			#οταν βρισκει τον παιχτη αν δεν παιζει η μουσικη του boss ξεκιναει,αλλιως pass
			pass
		else:
			worldmusic.play_boss_music()
		worldmusic.stop_music()
		state = CHASE

func _on_Hurtbox_area_entered(area):
	velocity.x = 0
	knockback = area.knockback_vector * 250
#	Με τις 2 παρακατω εντολες απενεργοποιουμε τα hitbox που τυχον εμειναν απο unfinished animation
	$Hitbox.set_collision_mask_bit(2,false)
	$HitboxDash.set_collision_mask_bit(2,false)
	hurt = true
	if stats.health > 0:
		stats.health -= area.damage
		sprite.play("hit")
		#Με τις 2 παρακατω εντολες κανουμε τα flags true, σε περιπτωση που δεν τελειωσαν τα αντιστοιχα animations επειδη ο εχθρος χτυπηθηκε
		dashflag = true
		hitflag = true
		yield(get_node("AnimationPlayer"), "animation_finished")
		sprite.play("idle")
		hurt = false
		
func _on_Stats_no_health():
#	Με τις 2 παρακατω εντολες απενεργοποιουμε τα hitbox που τυχον εμειναν απο unfinished animation
	$Hitbox.set_collision_mask_bit(2,false)
	$HitboxDash.set_collision_mask_bit(2,false)
	sprite.play("die")
	velocity = Vector2.ZERO
	yield(get_node("AnimationPlayer"), "animation_finished")
	queue_free()
	var enemyDeathEffect = deatheffect.instance() #κανουμε instance το deatheffect
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.global_position = global_position
	enemyDeathEffect.scale = Vector2(5,5) #Μεγαλωνουμε το μεγεθος του deatheffect
	worldmusic.stop_boss_music()
	PlayerStats.game_finsihed = true #ωστε να μην μπορουμε να κανουμε pause στο winscreen
	var winscreen = get_parent().get_node("WinScreen") #εμφανιζουμε το winscreen kai παιζουμε τη μουσικη του
	emit_signal("boss_died")
	winscreen.visible = true

func hit_player():
	#Αν ειναι σε κοντινο range ο παιχτης γινεται η πρωτη επιθεση
	var player2 = playerrange.player
	if playerrange.can_hit_player() and stats.health > 0 and hurt == false and dashflag == true and hitflag == true:
		hitflag = false
		sprite.play("attack")
		velocity.x = 0
		yield(get_node("AnimationPlayer"), "animation_finished")
		sprite.play("idle")
func dash_attack():
	#Αν ειναι σε πιο μακρινο range ο παιχτης γινεται η δευτερη επιθεση
	var player = playerdash.player
	if playerdash.can_hit_player() and hitflag == true and stats.health > 0 and hurt == false and dashflag == true:
		dashflag = false
		velocity.x = 0
		sprite.play("attack2")
		yield(get_node("AnimationPlayer"), "animation_finished")

func dash_finished():
	#	Ελεγχος οτι το animation τελειωσε
	dashflag = true
	seek_player()

func hit_finished1():
	#	Ελεγχος οτι το animation τελειωσε
	hitflag = true
	seek_player()

func hitbox_enable():
#	Ενεργοποιουμε το hitbox της 1ης επιθεσης στο frame που θελουμε
	$Hitbox.set_collision_mask_bit(2,true)

func dash_hitbox_enable():
#	Ενεργοποιουμε το hitbox της 2ης επιθεσης στο frame που θελουμε
	$HitboxDash.set_collision_mask_bit(2,true)


func teleport():
	#η επιθεση που το boss τηλεμεταφερεται προς τον παιχτη
	var player = playerdash.player
	if player != null:
		if self.position.x - player.global_position.x > 0:
			self.position.x = player.global_position.x + 50
		else:
			self.position.x = player.global_position.x - 50

func boss_on_cutscene():
	#αν ειναι σε cutscene
	state = CUTSCENE


