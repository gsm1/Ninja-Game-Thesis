extends KinematicBody2D

export var SPEED = 1500 #ταχυτητα
export var FRICTION = 1000 #τριβη
onready var sprite = $AnimationPlayer

func _physics_process(delta):
	var direction = Vector2.RIGHT #φορα
	global_position += SPEED*direction*delta #κατευθυνση
	if get_tree().current_scene.name != "Cutscene": #αν δεν ειναι σε cutscene αναπαραγεται το attack animation
		sprite.play("attacklevel1")
		yield(get_node("AnimationPlayer"), "animation_finished")
		queue_free()
	elif get_tree().current_scene.name == "Cutscene":
		#αν ειναι σε cutscene εμφανιζεται σε προκαθορισμενη θεση
		global_position = Vector2(3328.06,1100)
		sprite.play("idle")

func _on_VisibilityNotifier2D_screen_exited():
	#οταν φευγει απο την οθονη εξαφανιζεται
	queue_free()
