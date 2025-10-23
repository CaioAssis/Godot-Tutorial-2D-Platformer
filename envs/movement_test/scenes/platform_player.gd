extends CharacterBody2D
class_name PlatformPlayer

const SPEED = 180.0
const JUMP_VELOCITY = -220.0
const ACCEL: float = 1200

var run_speed_increase: float = 0.2

var wall_pushback: float = 200


var damage: int = 1

@onready var sfx_player: AudioStreamPlayer2D = $PlayerSfx
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var fsm: FSMDescentralizado = $FSM

var side: String = "right"
var is_running: bool = false

var run_buffer: float = 0.2
var _run_direction: bool = true
var _start_buffer: bool = false
var _run_timer: float = 0

var max_jump = 2
var jump_counter = 0
var is_jump_buffer: bool = false

var was_on_floor: bool = false

func _ready() -> void:
	fsm.init(self)

func _physics_process(delta: float) -> void:
	was_on_floor = is_on_floor()
	_watch_running(delta)
	move_and_slide()

func accelerate(speed: float, direction: Vector2, acceleration: float):
	velocity = velocity.move_toward(speed * direction, acceleration)

func accelerate_x(speed: float, direction: float, acceleration: float):
	velocity.x = velocity.move_toward(speed * Vector2(direction, 0), acceleration).x

func accelerate_y(speed: float, direction: float, acceleration: float):
	velocity.y = velocity.move_toward(speed * Vector2(0, direction), acceleration).y

func _watch_running(delta: float):
	if Input.is_action_just_pressed("move_right"):
		if _start_buffer and _run_direction:
			is_running = true
			_run_timer = 0
			_start_buffer = false
		else:
			_run_direction = true
			_run_timer = 0
			_start_buffer = true
	
	elif Input.is_action_just_pressed("move_left"):
		if _start_buffer and not _run_direction:
			is_running = true
			_run_timer = 0
			_start_buffer = false
		else:
			_run_direction = false
			_run_timer = 0
			_start_buffer = true

	if _start_buffer:
		_run_timer += delta
		if _run_timer >= run_buffer:
			_start_buffer = false
			_run_timer = 0
	
	if (is_running and 
		not Input.is_action_pressed("move_left") and
		not Input.is_action_pressed("move_right")
	):
		is_running = false
