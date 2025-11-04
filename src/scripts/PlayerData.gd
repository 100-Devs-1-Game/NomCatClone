extends Node

var high_score: int = 0
var goldfish: int = 0

const SAVEDATA_PATH = "res://savedata/savedata.json"

#Will be added once those are a thing
#var skins: Array[int] = []

func _ready() -> void:
	#load save data
	var file
	if FileAccess.file_exists(SAVEDATA_PATH):
		file = FileAccess.open(SAVEDATA_PATH, FileAccess.READ).get_as_text()
	else:
		file = FileAccess.open(SAVEDATA_PATH, FileAccess.WRITE_READ).get_as_text()
	if file:
		var unpacked: Dictionary = JSON.parse_string(file)
		if unpacked:
			high_score = unpacked.get_or_add("high_score", 0)
			goldfish = unpacked.get_or_add("goldfish", 0)
		else:
			unpacked = {
				"high_score": high_score,"goldfish":goldfish
			}
		print(unpacked)

#Call this when closing the game
func save_data() -> void:
	var packed = {
		"high_score": high_score,"goldfish": goldfish
	}
	var stringify = JSON.stringify(packed)
	var file = FileAccess.open(SAVEDATA_PATH, FileAccess.WRITE_READ)
	file.store_string(stringify)
	file.flush()
	file.close()
