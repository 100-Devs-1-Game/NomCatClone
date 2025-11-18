extends Node2D

#region Catchables
enum CATCHABLE_TYPE {
	FISH,
	GOLD,
	BOMB,
}

const BOMB_TEXTURE = preload("uid://imvh7h76e3js")
const FISH_1_TEXTURE = preload("uid://jdu6l0h120ji")
const FISH_2_TEXTURE = preload("uid://455fx1txtqdf")

class Catchable extends RefCounted:
	var type: CATCHABLE_TYPE
	var time: float = 2.0
	var side: bool
	
	func _init(t: CATCHABLE_TYPE, s: bool):
		type = t
		side = s
	func update(delta: float) -> bool:
		time -= delta
		return time <= -1.0
#endregion

var catchable_instances: Array[Catchable] = []

@onready var timer: Timer = $Timer
@onready var lilguy_left: Sprite2D = $lilguy_sprite1
@onready var lilguy_right: Sprite2D = $lilguy_sprite2

var Score: int = 0
signal game_over

@export var heightcurve: Curve

func _ready() -> void:
	start()

func start():
	randomize()
	timer.start()

func _on_timeout() -> void:
	spawn_catchable()
	timer.start(randf_range(1.0, 3.0))

func _process(delta: float) -> void:
	var cleanup = []
	for c in catchable_instances:
		if c.update(delta) and !c.type == CATCHABLE_TYPE.BOMB:
			timer.stop()
			game_over.emit()
		if Input.is_action_pressed("ui_left") and absf(c.time) < 0.25 and !c.side:
			match c.type:
				CATCHABLE_TYPE.FISH:
					Score += 1
				CATCHABLE_TYPE.GOLD:
					Score += 1
					PlayerData.goldfish += 1
				CATCHABLE_TYPE.BOMB:
					lilguy_left.went_boom = true
					timer.stop()
					game_over.emit()
			cleanup.append(c)
		if Input.is_action_pressed("ui_right") and absf(c.time) < 0.25 and c.side:
			match c.type:
				CATCHABLE_TYPE.FISH:
					Score += 1
				CATCHABLE_TYPE.GOLD:
					Score += 1
					PlayerData.goldfish += 1
				CATCHABLE_TYPE.BOMB:
					lilguy_right.went_boom = true
					timer.stop()
					game_over.emit()
			cleanup.append(c)
	
	for c in cleanup:
		catchable_instances.erase(c)
	
	queue_redraw()

func _draw() -> void:
	for c in catchable_instances:
		var txtr
		match c.type:
			CATCHABLE_TYPE.FISH:
				txtr = FISH_1_TEXTURE
			CATCHABLE_TYPE.GOLD:
				txtr = FISH_2_TEXTURE
			CATCHABLE_TYPE.BOMB:
				txtr = BOMB_TEXTURE
		if txtr:
			var startlocationX = 0.0 if !c.side else 1920.0
			var endlocationX = 640.0 if !c.side else 1280.0
			var weight = 1.0 - c.time
			draw_texture(txtr, Vector2(
				lerpf(startlocationX, endlocationX, clampf(weight, -1.0,1.0)),
				800 - (300 * heightcurve.sample(weight))
			))

func spawn_catchable():
	var c
	var side = randf() > 0.5
	var random_type = randf()
	if random_type < 0.25:
		c = Catchable.new(CATCHABLE_TYPE.BOMB, side)
	elif random_type < 0.9:
		c = Catchable.new(CATCHABLE_TYPE.FISH, side)
	else:
		c = Catchable.new(CATCHABLE_TYPE.GOLD, side)
	assert(c != null, "failed to create catchable")
	catchable_instances.append(c)
