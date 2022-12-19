extends AnimatedSprite


func _ready():
	#συνδεουμε το signal που δειχνει οτι τελειωσε το animation
	connect("animation_finished", self, "_on_animation_finished")
	play("effect")

func _on_animation_finished():
	queue_free()
