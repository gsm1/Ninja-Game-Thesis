extends PathFollow2D


export var SPEED = 200 #η ταχυτητα με την οποια η εχθροι κινουντε πανω στο μονοπατι
var flag = false
onready var boss = $Boss3/AnimationPlayer
onready var evilninja = $EvilNinja/AnimationPlayer
onready var evilninja2 = $EvilNinja2/AnimationPlayer
onready var timer = $Boss3/Timer
var cutsceneflag = false
var timerflag = false
func _process(delta):
	#Ελεγχοι ωστε αναλογα με τη θεση στο μονοπατι να γινονται ορισμενες ενεργειες
	if get_offset() == 0:
			boss.play("idle")
	elif get_offset() > 0 and cutsceneflag == false:
		boss.play("run")
		evilninja.play("run")
		evilninja2.play("run")
	if flag == true:
		set_offset(get_offset() + SPEED*delta)

func _on_Area2D_body_entered(body):
	flag=true

func _on_Area2DBoss_body_entered(body):
	#οταν μπαινουν οι εχθροι στο σθγκεκριμενο area γινεται η επιθεση
	cutsceneflag = true
	boss.play("attack")
	evilninja.play("idle")
	evilninja2.play("idle")
	flag = false
	timer.start(0.9)

func _on_Timer_timeout():
	#μετα το timeout γυρνανε και φευγουν
	timerflag = true
	turn_around()
	
func turn_around():
	if timerflag == true:
		#εντολες για να αλλαξουν κατευθυνση τα sprite
		flag = true
		$Boss3.scale.x = $Boss3.scale.y * -1
		$EvilNinja.scale.x = $EvilNinja.scale.y * -1
		$EvilNinja2.scale.x = $EvilNinja2.scale.y * -1
		boss.play("run")
		evilninja.play("run")
		evilninja2.play("run")
	
