extends Node

var high_score: int = 0
var goldfish: int = 0

const SAVEDATA_PATH = "res://savedata/savedata.json"

const SKINS = {
	1: preload("res://misc_resources/lilguy1.tres"),
	2: preload("res://misc_resources/lilguy2.tres"),
	3: preload("res://misc_resources/lilguy3.tres"),
	4: preload("res://misc_resources/lilguy4.tres"),
	5: preload("res://misc_resources/lilguy5.tres"),
	6: preload("res://misc_resources/lilguy6.tres"),
	7: preload("res://misc_resources/lilguy7.tres"),
	8: preload("res://misc_resources/lilguy8.tres"),
}
var unlocked_skins: Array = [
	1
]
var lilguy1_skin: int = 1
var lilguy2_skin: int = 1

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

func _exit_tree() -> void:
	save_data()

#Call this when closing the game
func save_data() -> void:
	if OS.has_feature("editor"): return
	var packed = {
		"high_score": high_score,"goldfish": goldfish
	}
	var stringify = JSON.stringify(packed)
	var file = FileAccess.open(SAVEDATA_PATH, FileAccess.WRITE_READ)
	file.store_string(stringify)
	file.flush()
	file.close()
