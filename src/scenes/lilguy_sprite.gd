extends Sprite2D

@export var Sad1: Texture2D
@export var Sad2: Texture2D
@export var Open: Texture2D
@export var Idle: Texture2D

var sad = false
var sad_time = 0.1

@export var control: String = ""

func _process(delta: float) -> void:
	if sad:
		sad_time -= delta
		if sad_time <= 0.0:
			if texture == Sad1:
				texture = Sad2
			else:
				texture = Sad1
		
	if Input.is_action_pressed(control):
		texture = Open
	else:
		texture = Idle
