extends Node2D

#region Catchables
enum CATCHABLE_TYPE {
	FISH,
	GOLD,
	BOMB,
}

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

var Score: int = 0
signal game_over

func start():
	randomize()
	timer.start()

func _on_timeout() -> void:
	spawn_catchable()
	timer.start(randf_range(1.0, 3.0))

func _process(delta: float) -> void:
	for c in catchable_instances:
		if c.update(delta):
			timer.stop()
			game_over.emit()
		if Input.is_action_pressed("ui_left") and absf(c.time) < 0.25 and !c.side:
			pass # add score and erase instance, also handle type specific cases
		if Input.is_action_pressed("ui_right") and absf(c.time) < 0.25 and c.side:
			pass # ditto

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
