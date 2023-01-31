extends Node2D

var cageflag = false
var startflag = false
var ninjaflag = false
var bossflag = false
var hoodedflag = false
var ninja_died5 = false
var ninja_died4 = false
var starting_max_health = PlayerStats.max_health
onready var timer = $Timer
onready var label1 = $CanvasLayer/Label
onready var label2 = $CanvasLayer/Label2
onready var label3 = $CanvasLayer/Label3
onready var label4 = $CanvasLayer/Label4
onready var label5 = $CanvasLayer/Label5
onready var evilninja1 = $EvilNinjas/EvilNinja4
onready var evilninja2 = $EvilNinjas/EvilNinja5
onready var scene = get_tree()

func _ready():
	Music.play_music()
	LevelsUnlocked.level3_unlocked(true) #ξεκλειδωνεται το level3 στο μενου μολις μπαινουμε σε αυτο
	LevelsUnlocked.save_level() #κανουμε save το παραπανω
	PlayerStats.max_health_lv3 = starting_max_health #κραταμε το αρχικο max health σε περιπτωση που πεθανουμε και ξαναξεκινησουμε

func _physics_process(delta):
	# ελεγχοι για εμφανιση των label
	if startflag == true:
		label1.percent_visible += 0.005
	if cageflag == true:
		label2.percent_visible += 0.005
	if ninjaflag == true:
		label3.percent_visible += 0.005
	if bossflag == true:
		label5.percent_visible += 0.005
	if hoodedflag == true:
		label4.percent_visible += 0.005

func _on_Lever_body_entered(body):
	$Objects/Lever/AudioStreamPlayer.play()
	cageflag = true
	label1.visible = false
	timer.start(6)
	$Objects/Cage.position.y += 365
	$Objects/Lever/AnimatedSprite.play("default")
	$Objects/Lever.set_deferred("monitoring",false)
	$Objects/Rope.scale.y = 4.25 #μεγαλωνουμε το σκοινι ωστε να φαινεται οτι κατεβαινει
	$Objects/Rope.position.y = 408 #παει σε προκαθορισμενη θεση
	$Objects/Cage/Area2D/CollisionShape2D.set_deferred("disabled", false) #ενεργοποιουμε το area του κλουβιου
	
func _on_Cage_body_entered(body):
	#μολις ανοιξουμε το κλουβι ο companion μας δινει το κλειδι και ψαχνει εχθρους
	$Objects/Cage.set_collision_layer_bit(1, false)
	$Companion.give_key()
	$Companion.seek_enemy()

func _on_LabelArea_body_entered(body):
	timer.start(6)
	startflag = true

func _on_EvilNinjaArea_body_entered(body):
	timer.start(6)
	label2.visible = false
	ninjaflag = true
	
func _on_BossArea_body_entered(body):
	#μολις περασουμε την τελευταια πορτα πριν το boss o companion παυει να μας ακολουθει
	$Companion/PlayerDetectionZone.set_collision_mask_bit(0 , false)
	$Companion/EnemyDetectionZone.set_collision_mask_bit(0 , false)
	$Companion/AnimationPlayer.play("idle")
	$Companion.velocity.x = 0
	bossflag = true
	timer.start(6)
	label4.visible = false

func _on_Timer_timeout():
	#χρησιμοποιουμε ενα timer ωστε να μην μενει το label επ αοριστον στην οθονη
	if startflag == true :
		startflag = false
		label1.visible = false
	if cageflag == true :
		cageflag = false
		label2.visible = false
	if ninjaflag == true:
		ninjaflag = false
		label3.visible = false
	if hoodedflag == true:
		hoodedflag = false
		label4.visible = false
	if bossflag == true:
		bossflag = false
		label5.visible = false
func _on_HoodedNinjaArea_body_entered(body):
	label3.visible = false
	hoodedflag = true
	timer.start(6)

func _on_Boss3_boss_died():
	#οταν πεθανει το boss θελουμε να πεθανουν και οι 2 εχθροι-βοηθοι του
	Music.win_music()
	if ninja_died4 == false:
		evilninja1._on_Stats_no_health()
	if ninja_died5 == false:
		evilninja2._on_Stats_no_health()

func _on_EvilNinja5_is_dead():
	#για να αποφυγουμε την περιπτωση που εχει πεθανει ηδη ο εχθρος
	ninja_died5 = true


func _on_EvilNinja4_is_dead():
	#για να αποφυγουμε την περιπτωση που εχει πεθανει ηδη ο εχθρος
	ninja_died4 = true
