extends Node2D

onready var label1 = $CanvasLayer/Label
onready var label2 = $CanvasLayer/Label2
onready var label3 = $CanvasLayer/Label3
onready var label4 = $CanvasLayer/Label4
onready var timer = $Timer
var hiveflag = false
var gateflag = false
var treeflag = false

func _ready():
#	pass
	Music.play_music()
	Music.stop_boss_music()

func _process(delta):
	#Χρησιμοποιουμε τα παρακατω flag ωστε να εμφανιζεται το Label στην προκαθορισμενη περιοχη
	if hiveflag == true:
		label1.percent_visible += 0.005
	if gateflag == true:
		label2.percent_visible += 0.005
	if $Portal.visible == true:
		PlayerStats.max_health_lv2 = PlayerStats.max_health
		label3.percent_visible += 0.005
	if treeflag == true:
		label4.percent_visible += 0.005
func _on_LabelArea_body_entered(body):
	hiveflag = true
	timer.start(4)
	


func _on_LabelGate_body_entered(body):
	gateflag = true
	timer.start(4)

func _on_LabelGate_body_exited(body):
	if label2.percent_visible == 1:
			label2.visible = false


func _on_LabeBossArea_body_entered(body):
	treeflag = true
	timer.start(4)


func _on_Timer_timeout():
	#Ο ρολος του timer ειναι να εξαφανιζεται το κειμενο μετα απο προκαθορισμενο χρονο
	if hiveflag == true:
		hiveflag = false
		label1.visible = false
	if gateflag == true:
		gateflag = false
		label2.visible = false
	if treeflag == true:
		treeflag = false
		label4.visible =false
