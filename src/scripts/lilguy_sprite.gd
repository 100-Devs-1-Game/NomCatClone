extends Sprite2D

@export var assigned_guy: LilGuySkin:
	set(value):
		assigned_guy = value
		Idle = assigned_guy.IdleImage
		Open = assigned_guy.OpenImage
		Sad1 = assigned_guy.SadImage1
		Sad2 = assigned_guy.SadImage2
		Boomed = assigned_guy.BoomedImage

var Sad1: Texture2D
var Sad2: Texture2D
var Open: Texture2D
var Idle: Texture2D
var Boomed: Texture2D

var went_boom = false
var sad = false
var sad_time = 0.1

@export var control: String = ""

@onready var particles: CPUParticles2D = $particles
@onready var boomparticles: CPUParticles2D = $boomparticles


func _ready() -> void:
	get_parent().game_over.connect(func(): sad = true)
	reset()

func reset() -> void:
	sad = false
	went_boom = false
	if Idle:
		texture = Idle

func _process(delta: float) -> void:
	if sad:
		if went_boom: texture = Boomed
		else:
			sad_time -= delta
			if sad_time <= 0.0:
				if texture == Sad1:
					texture = Sad2
				else:
					texture = Sad1
	else:
		if Input.is_action_pressed(control):
			texture = Open
		else:
			texture = Idle
