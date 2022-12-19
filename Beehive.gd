extends StaticBody2D

onready var stats = $Stats
const deatheffect = preload("res://HurtHitbox/DeathEffect.tscn")

func _on_Hurtbox_area_entered(area):
	stats.health -= area.damage

func _on_Stats_no_health():
	queue_free()
	var enemyDeathEffect = deatheffect.instance()
	enemyDeathEffect.scale = Vector2(10,10) #Μεγαλωνουμε το μεγεθος του deatheffect
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.global_position = global_position
