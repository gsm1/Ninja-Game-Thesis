extends StaticBody2D


onready var stats = $Stats
export var has_key = false #Μεταβλητη που καθοριζει αν το βαρελι περιεχει κλειδι
var KEY = preload("res://Objects/Key.tscn")




func _on_Hurtbox_area_entered(area):
	stats.health -= 1


func _on_Stats_no_health():
	$AnimatedSprite.play("default")
	self.set_collision_layer_bit(1,false)
	if has_key == true:
		if KEY:
			#Οι παρακατω εντολες εμφανιζουν το κλειδι σε προκαθορισμενη θεση
			var key = KEY.instance()
			get_parent().add_child(key)
			key.global_position.x = global_position.x
			key.global_position.y = global_position.y - 80
