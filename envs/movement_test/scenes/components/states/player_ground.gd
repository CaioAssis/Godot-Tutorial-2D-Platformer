extends State
class_name PlayerGround

@export_group("States", "state_")
@export var state_air: State = null

var anim: String = "idle_"
var direction: float = 0

func Enter():
	parent.jump_counter = 0

func Update(_delta: float):
	if not parent.is_on_floor() and state_air:
		Transitioned.emit(self, state_air)

func Physics_Update(delta: float):
	_handle_movement(delta)
	_handle_animation()

func _handle_movement(delta: float):
	var mod: float = 1
	if parent.is_running: mod = 1 + parent.run_speed_increase
	
	direction = Input.get_axis("move_left", "move_right")
	parent.accelerate_x(parent.SPEED, direction * mod, parent.ACCEL * delta) 
	if Input.is_action_just_pressed("jump") or parent.is_jump_buffer:
		parent.velocity.y = parent.JUMP_VELOCITY
		parent.jump_counter +=1

func _handle_animation():
	if direction > 0:
		if parent.is_running:
			anim = "run_"
		else:
			anim = "walk_"
		parent.side = "right"
	elif direction < 0:
		if parent.is_running:
			anim = "run_"
		else:
			anim = "walk_"
		parent.side = "left"
	else:
		anim = "idle_"
	
	parent.animation_player.play(anim + parent.side)
