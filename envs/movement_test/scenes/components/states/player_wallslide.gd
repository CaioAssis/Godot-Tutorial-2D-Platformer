extends State
class_name PlayerWallslide


@export_group("States", "state_")
@export var state_ground: State = null
@export var state_air: State = null
@export var state_ledge_grab: State = null

@export var wall_friction: float = 0.3
@export var jump_buffer: float = 0.1

var anim: String = "wall_slide_"

var direction: float = 0

func Update(_delta: float):
	if parent.is_on_floor():
		if state_ground:
			Transitioned.emit(self, state_ground)
	
	var wall_side = parent.get_wall_normal().x
	if (not parent.is_on_wall() or 
		(wall_side < 0 and not Input.is_action_pressed("move_right")) or
		(wall_side > 0 and not Input.is_action_pressed("move_left"))
	):
		if state_air:
			Transitioned.emit(self, state_air)
	
	elif not Input.is_action_pressed('crouch') and parent.check_ledge():
		if state_ledge_grab:
			Transitioned.emit(self, state_ledge_grab)

func Physics_Update(delta: float):
	_handle_movement(delta)
	_handle_animation()

func _handle_movement(delta: float):
	if not parent.is_on_floor():
		var wf: float = wall_friction
		if Input.is_action_pressed('crouch'): wf = 0.8
		parent.accelerate_y(parent.SPEED * wf, 1, parent.ACCEL * 5/4 * delta)
	
	direction = Input.get_axis("move_left", "move_right")
	parent.accelerate_x(parent.SPEED, direction, (parent.ACCEL * 3/4 * delta))
	if Input.is_action_just_pressed("jump"):
		if parent.is_on_wall():
			var side: float 
			if parent.get_wall_normal().x > 0:
				side = 1
			elif parent.get_wall_normal().x < 0:
				side = -1
			parent.velocity = Vector2(parent.wall_pushback * side, parent.JUMP_VELOCITY)
		elif parent.jump_counter < parent.max_jump:
			parent.velocity.y = parent.JUMP_VELOCITY
			parent.jump_counter+=1
		else:
			_set_jump_buffer()

func _handle_animation():
	if direction > 0:
		parent.side = "right"
	elif direction < 0:
		parent.side = "left"
	
	parent.animation_player.play(anim + parent.side)

func _set_jump_buffer():
	parent.is_jump_buffer = true
	get_tree().create_timer(jump_buffer).timeout.connect(func(): parent.is_jump_buffer = false)
