extends KinematicBody2D


const UP = Vector2(0,-1)
const GRAVITY =150 #βαρυτητσ
const ACC = 1000 #επιταχυνση
export var MAX_SPEED = 300 #μεγιστη ταχυτητα
export var FRICTION = 1000 #τριβη
var hitflag = true
var hurt = false
const deatheffect = preload("res://HurtHitbox/DeathEffect.tscn") #για να κανουμε instance το deatheffect
var knockback = Vector2.ZERO
export var has_died = false #bool γιαν να γινει ελεγχος ωστε να εμφανιστει ενα label
var AXE = preload("res://HurtHitbox/Axe.tscn") #για να κανουμε instance το deatheffect
var KEY = preload("res://Objects/Key.tscn")	# για να κανουμε instance το deatheffect
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
	sprite.play("idle")
	
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
			#οταν ο παιχτης εισερχεται στο area του εχθρου
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
		#οταν βρισκει τον παιχτη παει σε state Chase
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
	sprite.play("die")
	velocity = Vector2.ZERO
	yield(get_node("AnimationPlayer"), "animation_finished")
	queue_free()
	var enemyDeathEffect = deatheffect.instance()
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.global_position = global_position
	has_died = true

func hit_player():
	var player2 = playerrange.player
	if playerrange.can_hit_player():
		hitflag = false
		if player2 != null and stats.health > 0 and hurt ==false:
			sprite.play("attack1")
			velocity.x = 0
			yield(get_node("AnimationPlayer"), "animation_finished")
			sprite.play("idle")
	hitflag = true
	
	
func throw_axe():
	if AXE:
		var player = playerrange.player
		if player != null:
			var axe = AXE.instance()
			get_tree().current_scene.add_child(axe)
			#Με τις παρακατω εντολες εμφανιζουμε το axe σε προκαθορισμενη θεση
			axe.global_position.y = self.global_position.y
			axe.global_position.x = self.global_position.x - 192
			var player_x = player.global_position.x
			var axe_rotation = self.global_position.direction_to(Vector2(player_x,self.global_position.y-10)).angle()
			axe.rotation = axe_rotation




