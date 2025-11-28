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
	var boundsprite: Sprite2D
	
	func _init(t: CATCHABLE_TYPE, s: bool, spr: Sprite2D):
		type = t
		side = s
		boundsprite = spr
		var location = Vector2(0.0, 830.0) if !side else Vector2(1920, 320)
		boundsprite.position = location
	func update(delta: float, curve: Curve) -> bool:
		time -= delta
		var initx = 0.0 if !side else 1920.0
		var endx = 640.0 if !side else 1280.0
		boundsprite.rotate(delta)
		boundsprite.position.x = lerpf(initx, endx, (2.0 - time) / 2.0)
		boundsprite.position.y = lerpf(830.0, 300.0, curve.sample(2.0 - time))
		return time <= -0.4
#endregion

var catchable_instances: Array[Catchable] = []

@onready var timer: Timer = $Timer
@onready var lilguy_left: Sprite2D = $lilguy_sprite1
@onready var lilguy_right: Sprite2D = $lilguy_sprite2
@onready var music: AudioStreamPlayer = $AudioStreamPlayer

var Score: int = 0
signal game_over

@export var heightcurve: Curve

var started = false

func start():
	randomize()
	music.play()
	lilguy_left.assigned_guy = PlayerData.SKINS.get(PlayerData.lilguy1_skin)
	lilguy_right.assigned_guy = PlayerData.SKINS.get(PlayerData.lilguy2_skin)
	lilguy_left.reset()
	lilguy_right.reset()
	timer.start()
	started = true

var increment = 0.0

func _on_timeout() -> void:
	spawn_catchable()
	var new_increment = Score / 10.0
	var maxtime = 5.0 - new_increment
	timer.start(randf_range(0.5, maxtime))

func _process(delta: float) -> void:
	if !started: return
	var cleanup = []
	for c in catchable_instances:
		if c.update(delta, heightcurve) and !c.type == CATCHABLE_TYPE.BOMB:
			timer.stop()
			game_over.emit()
		if Input.is_action_pressed("ui_left") and absf(c.time) < 0.12 and !c.side:
			match c.type:
				CATCHABLE_TYPE.FISH:
					Score += 1
					lilguy_left.particles.emitting = true
				CATCHABLE_TYPE.GOLD:
					Score += 1
					PlayerData.goldfish += 1
					lilguy_left.particles.emitting = true
				CATCHABLE_TYPE.BOMB:
					lilguy_left.went_boom = true
					lilguy_left.boomparticles.emitting = true
					timer.stop()
					game_over.emit()
			cleanup.append(c)
		if Input.is_action_pressed("ui_right") and absf(c.time) < 0.12 and c.side:
			match c.type:
				CATCHABLE_TYPE.FISH:
					Score += 1
					lilguy_right.particles.emitting = true
				CATCHABLE_TYPE.GOLD:
					Score += 1
					lilguy_right.particles.emitting = true
					PlayerData.goldfish += 1
				CATCHABLE_TYPE.BOMB:
					lilguy_right.went_boom = true
					lilguy_right.boomparticles.emitting = true
					timer.stop()
					game_over.emit()
			cleanup.append(c)
	
	for c in cleanup:
		c.boundsprite.queue_free()
		catchable_instances.erase(c)
		

func spawn_catchable():
	var c
	var side = randf() > 0.5
	var random_type = randf()
	var spr = Sprite2D.new()
	add_child(spr)
	if random_type < 0.25:
		spr.texture = BOMB_TEXTURE
		c = Catchable.new(CATCHABLE_TYPE.BOMB, side, spr)
	elif random_type < 0.97:
		spr.texture = FISH_1_TEXTURE
		c = Catchable.new(CATCHABLE_TYPE.FISH, side, spr)
	else:
		spr.texture = FISH_2_TEXTURE
		c = Catchable.new(CATCHABLE_TYPE.GOLD, side, spr)
	assert(c != null, "failed to create catchable")
	catchable_instances.append(c)
	


func _on_game_over() -> void:
	for c in catchable_instances:
		c.boundsprite.queue_free()
	catchable_instances.clear()
	music.stop()
	started = false
	await get_tree().create_timer(5.0).timeout
	$CanvasLayer.show()
