extends Node

var level2 = false #αρχικα τα level2 και 3 ειναι κλειδωμενα
var level3 = false
var levels = ["false", "false"] #δημιουργω μια λιστα με values για τα level2 και 3

func level2_unlocked(value):
	level2 = value

func level3_unlocked(value):
	level3 = value

func save_level():
	var file = File.new()
	file.open("user://levels.save", File.WRITE)
	#ανοιγουμε ενα αρχειο και αναλογα με τις τιμες των level2,level3 αποθηκευουμε τα αντιστοιχα strings
	if level2 and not level3:
		levels = ["true", "false"]
	elif not level2 and not level3:
		levels = ["false", "false"]
	elif level3 and not level2:
		levels = ["false", "true"]
	else:
		levels = ["true", "true"]
	file.store_var(levels)
	file.close()

func load_level():
	var file = File.new()
	if file.file_exists("user://levels.save"):
		file.open("user://levels.save", File.READ)
		levels = file.get_var()
		file.close()
		#ανοιγουμε το αρχειο και αναλογα με τις τιμες των strings αποθηκευουμε τα αντιστοιχα bool στα level2 και 3
		if levels == ["true", "true"]:
			level2 = true
			level3 = true
		elif levels == ["false", "true"]:
			level2 = false
			level3 = true
		elif levels == ["true", "false"]:
			print("sosto")
			level2 = true
			level3 = false
		else:
			level3 = false
			level2 = false
		
	else:
		#αν δεν υπαρχει αρχειο αποθηκευουμε και στα 2 false
		level2 = false
		level3 = false
