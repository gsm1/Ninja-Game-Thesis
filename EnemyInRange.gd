extends Area2D



var enemy = null

var target_list_range = []
func can_hit_player():
	if target_list_range != []:
		enemy = target_list_range[0]
#		print (enemy)
		return enemy != null




func _on_EnemyInRange_body_entered(body):
	if body.is_in_group("Enemies"):
		print("bike sto range")
		target_list_range.append(body) 


func _on_EnemyInRange_body_exited(body):
	if body.is_in_group("Enemies"):
#		print("vgike")
		target_list_range.erase(body) 
