extends PathFollow2D


export var SPEED = 400


func _process(delta):
	#η ταχυτητα με την οποια κινουνται πανω στο μονοπατι οι χαρακτηρες
	set_offset(get_offset() + SPEED*delta)
	




