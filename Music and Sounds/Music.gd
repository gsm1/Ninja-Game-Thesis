extends Node

var slider_music = 0.5
var slider_sound = 0.5

func play_music():
	# αν δεν παιζει ηδη, ξεκιναει η μουσικη
	if $WorldMusic.playing == false:
		$WorldMusic.play()

func stop_music():
	$WorldMusic.stop()

func play_boss_music():
	# αν δεν παιζει ηδη, ξεκιναει η μουσικη του boss
	if $BossMusic.playing == false:
		$BossMusic.play()
#
func stop_boss_music():
	$BossMusic.stop()
#
func lose_music():
	#η μουσικη οταν χανουμε
	$LoseMusic.play()

func stop_lose_music():
	$LoseMusic.stop()

func win_music():
	#η μουσικη οταν τερματιζουμε το παιχνιδι
	$WinMusic.play()

func stop_win_music():
	$WinMusic.stop()
