extends Area2D

var array = [] #δημιουργουμε ενα array καθως οι εχθροι μπορει να ειναι παραπανω του ενος
var player = null 

func can_see_player():
	#επιστρεφει ενα bool αναλογα με το εαν βλεπει εχθρο
	return player != null

func _on_EnemyDetectionZone_body_entered(body):
		#οταν βλεπει εχθρο μπαινει στο array 
		array.append(body)
		player = array[0]


func _on_EnemyDetectionZone_body_exited(body):
	#Οταν δεν βλεπει πλεον καποιον εχθρο διαγραφεται απο το array
		array.erase(body)
		if array != []:
			#επιστρεφει τον εχθρο που ειναι στην 1η θεση του array
			player = array[0]
		else:
			player = null
