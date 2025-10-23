extends Area2D
class_name HurtBox

signal hurt(attack: int)

@export var actor: CharacterBody2D
@export var iframe_time: float = 0.2

var _iframe_timer: Timer

#inicia hurtbox para interagir com o layer 3 (bit 4)
func _init() -> void:
	collision_layer = 4
	collision_mask = 0

func _ready() -> void:
	_create_timer()

func _create_timer():
	_iframe_timer = Timer.new()
	_iframe_timer.wait_time = iframe_time
	_iframe_timer.one_shot = true
	add_child(_iframe_timer)
	_iframe_timer.timeout.connect(_end_iframe)

func hit(attack: int):
	set_iframe()
	hurt.emit(attack)

func set_iframe(time: float = iframe_time):
	_iframe_timer.wait_time = time
	_iframe_timer.start()
	set_deferred("monitorable", false)

func _end_iframe():
	set_deferred("monitorable", true)
