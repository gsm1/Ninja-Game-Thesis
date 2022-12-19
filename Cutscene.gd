extends Node2D


onready var label1 = $CanvasLayer/Label
onready var label2 = $CanvasLayer/Label2
onready var label3 = $CanvasLayer/Label3
onready var label4 = $CanvasLayer/Label4

var labelflag = false
func _ready():
	Music.play_boss_music()
	Music.stop_music()
	#εμφανιζει το ghost σε μικροτερη κλιμακα
	$GhostNinja.scale = Vector2(-1,1)
	$GhostNinja.visible = false
	label1.percent_visible = 0
	#βαζουμε ολους τους παρακατω χαρακτηρες σε κατασταση cutscene
	$Path2D/PathFollow2D/AnimationPlayer.play("cutscene")
	$Path2DBoss/PathFollow2DBoss/EvilNinja.on_cutscene()
	$Path2DBoss/PathFollow2DBoss/EvilNinja2.on_cutscene()
	$Path2DBoss/PathFollow2DBoss/Boss3.boss_on_cutscene()

func _process(delta):
	#Με τις παρακατω εντολες εμφανιζουμε τα label
	label1.percent_visible += 0.005
	if label1.percent_visible == 1:
		label2.percent_visible += 0.005
	if label1.percent_visible == 1 and label2.percent_visible == 1:
		if labelflag == true:
			label3.percent_visible += 0.005
			if label3.percent_visible == 1:
				label4.percent_visible += 0.005
				if label4.percent_visible == 1:
					#οταν τελειωσει το τελευταιο label εμφανιζεται το κουμπι για να ξεκινησει το παιχνιδι
					$CanvasLayer/Button.visible = true

func _on_Area2DGhost_body_entered(body):
	#Εμφανιζουμε το ghost σε προκαθορισμενο χρονο
	labelflag = true
	label1.visible = false
	label2.visible = false
	$GhostNinja.visible = true

func _on_Button_pressed():
	#Το κουμπι που μας παει στο 1ο level
	get_tree().change_scene("res://World/Level1.tscn")


func _on_Skip_pressed():
	#Το κουμπι που προχωραει το cutscene και μας παει στο 1ο level
	get_tree().change_scene("res://World/Level1.tscn")
