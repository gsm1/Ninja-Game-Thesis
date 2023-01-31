extends Control

var music_bus = AudioServer.get_bus_index("Music")
var sound_bus = AudioServer.get_bus_index("Sounds")
var value = 0.5
var value2 = 0.5

func _ready():
	$OptionsContainer/HBoxContainer/Label3/VBoxContainer/HBoxContainer/HSlider.set_value(Music.slider_music)
	$OptionsContainer/HBoxContainer/Label3/VBoxContainer/HBoxContainer2/HSlider2.set_value(Music.slider_sound)
	value = db2linear(AudioServer.get_bus_volume_db(music_bus))
	value2 = db2linear(AudioServer.get_bus_volume_db(sound_bus))

func _on_Back_pressed():
	get_tree().change_scene("res://UI/Menu.tscn")


func _on_HSlider_value_changed(value):
	AudioServer.set_bus_volume_db(music_bus, linear2db(value))
	Music.slider_music = value
	if value == 0:
		AudioServer.set_bus_mute(music_bus,true)
	else:
		AudioServer.set_bus_mute(music_bus,false)
		


func _on_HSlider2_value_changed(value2):
	AudioServer.set_bus_volume_db(sound_bus, linear2db(value2))
	Music.slider_sound = value2
	if value2 == 0:
		AudioServer.set_bus_mute(sound_bus,true)
	else:
		AudioServer.set_bus_mute(sound_bus,false)
