extends Control

var music_bus = AudioServer.get_bus_index("Music")
var sound_bus = AudioServer.get_bus_index("Sounds")

func _on_Back_pressed():
	get_tree().change_scene("res://UI/Menu.tscn")


func _on_HSlider_value_changed(value):
	AudioServer.set_bus_volume_db(music_bus,value)
	
	if value == 0:
		AudioServer.set_bus_mute(music_bus,true)
	else:
		AudioServer.set_bus_mute(music_bus,false)
		


func _on_HSlider2_value_changed(value):
	AudioServer.set_bus_volume_db(sound_bus,value)
	
	if value == 0:
		AudioServer.set_bus_mute(sound_bus,true)
	else:
		AudioServer.set_bus_mute(sound_bus,false)
