extends KinematicBody2D
const MAX_SPEED = 400
const FRICTION = 200
const ACCELERATION = 300
onready var stats = $Stats
onready var playerdetect = $PlayerDetectionZone
onready var softCollision = $SoftCollision 
var knockback = Vector2.ZERO
const deatheffect = preload("res://HurtHitbox/DeathEffect.tscn") #κανουμε instance το deatheffect

enum {
	IDLE,
	CHASE
}

var velocity = Vector2.ZERO
var state = CHASE
onready var sprite = $AnimatedSprite

func _ready():
	sprite.play("fly")

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta) #το knockback που λαμβανει απο τον παιχτη
	knockback = move_and_slide(knockback)
#
#
	match state:
		IDLE:
			#οταν ειναι ακινητο και ψαχνει τον παιχτη
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			seek_player()
		CHASE:
			#οταν ο παιχτης εισερχεται στο area του bee
			var player = playerdetect.player
			if player != null:
				var direction = (player.global_position - global_position).normalized()
				velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
			else:
				state = IDLE
			if velocity.x < 0 and stats.health > 0 :
				#αλλαγη κατευθυβσης sprite
				scale.x = scale.y * 1
			elif velocity.x > 0 and stats.health > 0:
				#αλλαγη κατευθυβσης sprite
				scale.x = scale.y * -1
	velocity = move_and_slide(velocity)
	if softCollision.is_colliding():
		#εφαρμοζουμε μια ταχυτητα συγκρουσης μεταξυ των νυχτεριδων ωστε να μην εμφανιζονται σαν ενα σωμα
		velocity += softCollision.get_push_vector() * delta * 400

func seek_player():
	if playerdetect.can_see_player():
		state = CHASE

func _on_Hurtbox_area_entered(area):
	knockback = area.knockback_vector * 250
	sprite.play("hit")
	stats.health -= area.damage
	yield(get_node("AnimatedSprite"), "animation_finished")
	sprite.play("fly")

func _on_Stats_no_health():
	sprite.play("die")
	velocity = Vector2.ZERO
	#	Με τις 2 παρακατω εντολες απενεργοποιουμε τα hitbox που τυχον εμειναν απο unfinished animation
	$Hurtbox.set_collision_layer_bit(3, false)
	$Hitbox.set_collision_mask_bit(2,false)
	$PlayerDetectionZone.set_collision_mask_bit(0,false)
	yield(get_node("AnimatedSprite"), "animation_finished")
	queue_free()
	var enemyDeathEffect = deatheffect.instance()
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.global_position = global_position

func _on_Hitbox_area_entered(area):
	$AudioStreamPlayer.play()
