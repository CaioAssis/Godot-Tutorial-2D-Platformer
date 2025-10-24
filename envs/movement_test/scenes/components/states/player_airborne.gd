extends State
class_name PlayerAirborne


@export_group("States", "state_")
@export var state_ground: State = null
@export var state_wall_slide: State = null
@export var state_ledge_grab: State = null

@export var jump_buffer: float = 0.1
@export var coyote_time: float = 0.1

var peak_range: float = 30

var anim: String = "jump_"
var y_motion: String = "asc_"

var direction: float = 0

var _run_start: bool = false

func Enter():
	if parent.is_running:
		_run_start = true
	else: _run_start = false

func Update(_delta: float):
	if parent.is_on_floor():
		if state_ground:
			Transitioned.emit(self, state_ground)
	elif parent.was_on_floor and parent.velocity.y >= 0:
		get_tree().create_timer(coyote_time).timeout.connect(
			func(): if parent.jump_counter == 0: parent.jump_counter +=1
			)
	
	elif not Input.is_action_pressed('crouch') and parent.check_ledge():
		if state_ledge_grab:
			Transitioned.emit(self, state_ledge_grab)
	
	elif (parent.is_on_wall() and parent.velocity.y >= 0 and
		(Input.is_action_pressed("move_left") or 
		Input.is_action_pressed("move_right"))
	):
		if state_wall_slide:
			Transitioned.emit(self, state_wall_slide)

func Physics_Update(delta: float):
	_handle_movement(delta)
	_handle_animation()

func _handle_movement(delta: float):
	var mod: float = 1
	if _run_start and parent.is_running: mod = 1 + parent.run_speed_increase
	if not parent.is_on_floor():
		parent.velocity += parent.get_gravity() * delta
	direction = Input.get_axis("move_left", "move_right")
	
	var _accel: float = 3/4.0
	if not direction: _accel = 1/5.0
	
	parent.accelerate_x(parent.SPEED * mod, direction, (parent.ACCEL * _accel * delta))
	if Input.is_action_just_pressed("jump"):
		if parent.is_on_wall():
			var side: float = sign(parent.get_wall_normal().x)
			parent.velocity = Vector2(parent.wall_pushback * side, parent.JUMP_VELOCITY)
		elif parent.jump_counter < parent.max_jump:
			parent.velocity.y = parent.JUMP_VELOCITY
			parent.jump_counter+=1
		else:
			_set_jump_buffer()

func _handle_animation():
	var y_force = parent.velocity.y
	if y_force < -peak_range:
		y_motion = "asc_"
	elif y_force > peak_range:
		y_motion = "dsc_"
	else:
		y_motion = "peak_"
	
	var dir = sign(parent.velocity.x)
	
	if dir > 0:
		parent.side = "right"
	elif dir < 0:
		parent.side = "left"
	
	parent.animation_player.play(anim + y_motion + parent.side)

func _set_jump_buffer():
	parent.is_jump_buffer = true
	get_tree().create_timer(jump_buffer).timeout.connect(func(): parent.is_jump_buffer = false)
