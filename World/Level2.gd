extends Node2D

onready var label1 = $CanvasLayer2/Label
onready var label2 = $CanvasLayer2/Label2
onready var label3 = $CanvasLayer2/Label3
onready var label4 = $CanvasLayer2/Label4
onready var label5 = $CanvasLayer2/Label5
onready var label6 = $CanvasLayer2/Label6
onready var label7 = $CanvasLayer2/Label7
onready var timer = $Timer
onready var rock = $Objects/Rock
onready var rock2 = $Objects/Rock2
var starting_max_health = PlayerStats.max_health
var startflag = false
var leverflag = false
var leverflag2 = false
var leverflag3 = false
var boulderflag = false
var gateflag = false
func _ready():
	LevelsUnlocked.level2_unlocked(true)
	LevelsUnlocked.save_level()
	Music.play_music()
	Music.stop_boss_music()
	PlayerStats.max_health_lv2 = starting_max_health   #κραταμε το αρχικο max health σε περιπτωση που πεθανουμε και ξαναξεκινησουμε

func _physics_process(delta):
	#Χρησιμοποιουμε τα παρακατω flag ωστε να εμφανιζεται το Label στην προκαθορισμενη περιοχη
	if startflag ==  true:
		label1.percent_visible += 0.005
	if leverflag == true :
		label1.visible = false
		label2.percent_visible += 0.005
	if boulderflag == true :
		label1.visible = false
		label2.visible = false
		label3.percent_visible += 0.005
	if gateflag == true:
		label3.visible = false
		label4.percent_visible += 0.005
	if leverflag2 == true:
		label5.percent_visible += 0.005
	if $Skeletons/Skeleton == null and $Skeletons/Skeleton2 == null:
		label6.percent_visible += 0.005
		
	if PlayerStats.key_obtained == true:
		label6.visible = false
	if $Portal.visible == true:
		PlayerStats.max_health_lv3 = PlayerStats.max_health
		label7.percent_visible += 0.005


func _on_LabelArea_body_entered(body):
	startflag = true
	timer.start(4)
	

func _on_Lever_body_entered(body):
	$Objects/Lever/AudioStreamPlayer.play()
	$Objects/Lever/AnimatedSprite.play("default")
	leverflag3 = true
	boulderflag = false
	$Objects/Lever.set_deferred("monitoring",false)
	rock.position.y -= 500


func _on_LabelLeverFound_body_entered(body):
	if boulderflag == false:
		leverflag = true
		timer.start(5)
	if boulderflag == true:
		leverflag2 = true
		timer.start(5)
		

func _on_LabelBoulderFound_body_entered(body):
	if leverflag3 == false:
		boulderflag = true
		timer.start(4)


func _on_LabelGate_body_entered(body):
	gateflag = true
	timer.start(5)

func _on_Lever2_body_entered(body):
	$Objects/Lever/AudioStreamPlayer.play()
	$Objects/Lever2/AnimatedSprite.play("default")
	$Objects/Lever2.set_deferred("monitoring",false)
	rock2.position.y += 580

func _on_Timer_timeout():
	#Ο ρολος του timer ειναι να εξαφανιζεται το κειμενο μετα απο προκαθορισμενο χρονο
	if startflag == true :
		startflag = false
		label1.visible = false
	if boulderflag == true :
		label3.visible = false
	if leverflag == true:
		leverflag = false
		label2.visible = false
	if leverflag2 == true:
		leverflag2 = false
		label5.visible = false
	if gateflag == true:
		gateflag = false
		label4.visible = false
