extends KinematicBody2D

const UP = Vector2(0,-1)
const GRAVITY =150 #βαρυτητσ
const ACC = 500 #επιταχυνση
export var MAX_SPEED = 1500 #μεγιστη ταχυτητα
export var JUMP_SPEED: int = 2700 #ταχυτητα αλματος
var hurt = false
var hitflag = false
var won_flag = false
export var FRICTION = 1000 #τριβη
var state_machine 
const SPEED = 1000 #αρχικη ταχυτητα
var stats = PlayerStats # το autoload με τα stats του παιχτη
var GHOST = preload("res://Player/GhostNinja.tscn") #για να κανουμε instance το ghost που εμφανιζεται στην ultra attack
var flagbro = false #flag για το cutscene
enum {
	MOVE,
	ATTACK,
	HURT,
	DIE,
	CUTSCENE
}
var state = CUTSCENE
var velocity = Vector2(0,0)
onready var animationPlayer = $AnimationPlayer
onready var swordHitbox = $HitboxPivot/SwordHitbox 
onready var hurtbox = $Hurtbox
func _ready():
	if get_tree().current_scene.name != "Cutscene":
		state = MOVE
	stats.connect("no_health", self, "die_state")
	state_machine = $AnimationTree.get("parameters/playback") #τα διαφορετικα animations αλλαζουν μεσω αυτου
	swordHitbox.knockback_vector = Vector2.LEFT # το knockbak effect οταν χτυπαμε
func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)
		ATTACK:
			attack_state()
		HURT:
			hurt_state()
		DIE:
			die_state()
		CUTSCENE:
			cutscene()
	apply_gravity()
	crouch()
	jump()
	ultra_attack()

	move_and_slide(velocity, UP)
	
func apply_gravity():
	# Εφαρμοζουμε τη βαρυτητα
	if is_on_floor() and velocity.y > 0 :
		velocity.y = 0
	elif is_on_ceiling():
		velocity.y = 1
	else:
		velocity.y += GRAVITY


func move_state(delta):
	var input_vector = Vector2.ZERO
	if state != CUTSCENE and hurt == false and hitflag == false and won_flag == false :
		if Input.is_action_pressed("ui_left") and not Input.is_action_pressed("ui_right") :
			velocity.x = -SPEED
			input_vector = velocity.normalized()
			swordHitbox.knockback_vector = input_vector
		elif Input.is_action_pressed("ui_right") and not Input.is_action_pressed("ui_left"):
			velocity.x = SPEED
			input_vector = velocity.normalized()
			swordHitbox.knockback_vector = input_vector
		else:
			velocity.x = 0 
		if velocity.x > 0 :
			#για να αλλαζει φορα το sprite
			scale.x = scale.y * 1
		elif velocity.x < 0:
			#για να αλλαζει φορα το sprite
			scale.x = scale.y * -1
		if velocity.x != 0:
			state_machine.travel("run")
			velocity = velocity.move_toward(velocity * MAX_SPEED, ACC * delta)
		else:
			state_machine.travel("idle")
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		
		
		
		
		
		if Input.is_action_just_pressed("attack") or Input.is_action_just_pressed("heavyattack"):
			velocity = Vector2.ZERO
			state = ATTACK
			attack_state()
	
		


func hurt_state():
	if hitflag == false:
		hurt  = true
		state_machine.travel("hurt")
		



func crouch():
	if Input.is_action_pressed("crouch") and stats.health>0 and hurt == false and hitflag == false and won_flag == false:
		state_machine.travel("crouch")
	
	
func jump():
	if state != CUTSCENE and hurt == false and hitflag == false and won_flag == false:
		if Input.is_action_pressed("ui_up") and is_on_floor():
			velocity.y -= JUMP_SPEED 
			state_machine.travel("jump")

func attack_state():
	if state != CUTSCENE and hurt == false and won_flag == false:
		if Input.is_action_just_pressed("attack"):
	
			state_machine.travel("attack")
	
		elif Input.is_action_just_pressed("heavyattack"):
			
			state_machine.travel("heavyattack")
		hitflag = true
func attack_animation_finished():
	#ελεγχος οτι το animation τελειωσε 
	state = MOVE
	hitflag = false
func die_animation_finished():
	#ελεγχος οτι το animation τελειωσε 
	LoseScreen.set_paused(true)
	Music.lose_music()
	queue_free()
func hurt_animation_finished():
	#ελεγχος οτι το animation τελειωσε 
	hurt = false
	state = MOVE

func die_state():
	state_machine.travel("die")
	
func _on_Hurtbox_area_entered(area):
	# Mε το παρακατω if δινουμε το πλεονεκτημα της επιθεσης στον παιχτη, καθως αν επιτεθουν μαζι γινεται πρωτα το δικο του attack
	if hitflag == false:
		if area.damage != 0:
			#Συμβαινει μονο στην περιπτωση της stun attack του HoodedNinja οπου δεν θελουμε να δεχομαστε damage
			stats.health -= area.damage
			hurtbox.start_invincibility(1.5)
		hurt = true
		velocity = Vector2.ZERO
		state = HURT
	if stats.health <= 0 :
		state = DIE

func ultra_attack():
	if GHOST:
		#κανουμε instance το ghost αναλογα με την θεση του παιχτη μας
		if Input.is_action_just_pressed("Ultra") and PlayerStats.ultra == 3 and won_flag == false:
			var ghost = GHOST.instance()
			get_tree().current_scene.add_child(ghost)
			ghost.global_position.x = self.global_position.x - 800
			ghost.global_position.y = self.global_position.y - 400
			PlayerStats.ultra = 0

func cutscene():
	state = CUTSCENE
	if flagbro == false:
		state_machine.travel("run")
func _on_Area2D_body_entered(body):
	#για να σταματαει χωρις input στο cutscene
	state = CUTSCENE
	flagbro = true
	state_machine.travel("idle")

func _on_Boss3_boss_died():
	#οταν πεθαινει το boss του τελευταιου level θελουμε να μην μπορουμε να χειριστουμε τον παιχτη πλεον και να μην δεχεται damage
	won_flag = true
	hurtbox.start_invincibility(5)
