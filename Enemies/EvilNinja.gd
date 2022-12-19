extends KinematicBody2D


const UP = Vector2(0,-1) #οριζουμε το πανω
const GRAVITY =150 #βαρυτητσ
const ACC = 1000 #επιταχυνση
export var MAX_SPEED = 300 #μεγιστη ταχυτητα
export var FRICTION = 1000 # τριβη
var hitflag = true
var hurt = false
signal is_dead
const deatheffect = preload("res://HurtHitbox/DeathEffect.tscn") #για να κανουμε instance το deatheffect
var knockback = Vector2.ZERO
var STAR = preload("res://HurtHitbox/Projectile.tscn") #για να κανουμε instance το star
onready var stats = $Stats
onready var sprite = $AnimationPlayer
onready var playerdetect = $PlayerDetectionZone
onready var playerrange = $PlayerInRange
var velocity = Vector2(0,0)
enum {
	IDLE,
	CHASE
	CUTSCENE
}
var state = IDLE

func _ready():
	if get_tree().current_scene.name != "Cutscene": #αν δεν βρισκομαστε στο cutscene μπορουμε να δουμε τον παιχτη
		sprite.play("idle")
		$PlayerInRange.set_deferred("monitoring",true)
		$PlayerDetectionZone.set_deferred("monitoring",true)
	

func _physics_process(delta):
	apply_gravity()
	move_and_slide(velocity, UP)
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta) #το knockback που λαμβανει απο τον παιχτη
	knockback = move_and_slide(knockback)
	velocity = move_and_slide(velocity)
	match state:
		#οταν ειναι ακινητο και ψαχνει τον παιχτη
		IDLE:
			if stats.health > 0:
				sprite.play("idle")
				velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
				seek_player()
		CHASE:
			#οταν ο παιχτης εισερχεται στο area του boss
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
			if velocity.x < 0  and stats.health > 0:
				#αλλαγη κατευθυβσης sprite
				scale.x = scale.y * 1
			elif velocity.x > 0 and stats.health > 0:
				#αλλαγη κατευθυβσης sprite
				scale.x = scale.y * -1
			if stats.health <= 0:
				velocity.x = 0
				_on_Stats_no_health()
			hit_player()
		CUTSCENE:
			#οταν ειναι σε cutscene δεν θελουμε να βλεπει τον παιχτη
			$PlayerInRange.set_deferred("monitoring",false)
			$PlayerDetectionZone.set_deferred("monitoring",false)

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
	hurt  = true
	if stats.health > 0:
		stats.health -= area.damage
		sprite.play("hit")
		yield(get_node("AnimationPlayer"), "animation_finished")
		sprite.play("idle")
		hurt = false


func _on_Stats_no_health():
	emit_signal("is_dead")
	sprite.play("die")
	velocity = Vector2.ZERO
	yield(get_node("AnimationPlayer"), "animation_finished")
	queue_free()
	var enemyDeathEffect = deatheffect.instance()
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.global_position = global_position


func hit_player():
	var player2 = playerrange.player
	if playerrange.can_hit_player():
		#αν ο παιχτης ειναι σε range επιτιθεται
		hitflag = false
		if player2 != null and stats.health > 0 and hurt ==false:
			sprite.play("attack1")
			velocity.x = 0
			yield(get_node("AnimationPlayer"), "animation_finished")
			sprite.play("idle")
	hitflag = true
	
func throw_star():
	if STAR:
		#κανουμε instance το αστερι
		var player = playerrange.player
		if player != null:
			var star = STAR.instance()
			get_tree().current_scene.add_child(star)
			star.global_position = self.global_position
			var star_rotation = self.global_position.direction_to(player.global_position).angle() #οριζουμε κατευθυνση και φορα του αστεριου
			star.rotation = star_rotation

func on_cutscene():
	state = CUTSCENE


