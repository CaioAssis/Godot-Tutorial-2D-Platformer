extends State
class_name PlayerLedgeGrab


@export_group("States", "state_")
@export var state_ground: State = null
@export var state_air: State = null
@export var state_wall_slide: State = null

@export var y_offset: float = 20
@export var x_offset: float = 10

var anim: String = "wall_grab_"
var _is_wallclimbing: bool = false

var direction: float = 0

func Enter():
	parent.velocity.y = Vector2.ZERO.y
	if not parent.animation_player.animation_finished.is_connected(_on_climb_end):
		parent.animation_player.animation_finished.connect(_on_climb_end)

func Update(_delta: float):
	if _is_wallclimbing: return
	
	if parent.is_on_floor():
		if state_ground:
			Transitioned.emit(self, state_ground)
	
	elif not parent.check_ledge():
		if parent.velocity.y >= 0:
			if state_wall_slide:
				Transitioned.emit(self, state_wall_slide)
		elif state_air:
			Transitioned.emit(self, state_air)
	
	elif((parent.side == "right" and Input.is_action_just_pressed("move_left")) or
		(parent.side == "left" and  Input.is_action_just_pressed("move_right"))
	):
		if state_air:
			parent.set_ledge_cd()
			Transitioned.emit(self, state_air)
	elif((parent.side == "left" and Input.is_action_just_pressed("move_left")) or
		(parent.side == "right" and  Input.is_action_just_pressed("move_right"))
	):
		_is_wallclimbing = true
	
	

func Physics_Update(_delta: float):
	_handle_movement()
	_handle_animation()

func _handle_movement():
	if _is_wallclimbing:
		return
	
	if Input.is_action_just_pressed('crouch'):
		if state_wall_slide:
			parent.set_ledge_cd()
			Transitioned.emit(self, state_wall_slide)
	
	elif Input.is_action_just_pressed("jump"):
		parent.velocity.y = parent.JUMP_VELOCITY
	
	if parent.side == "right":
		parent.velocity.x = 200
	else: parent.velocity.x = -200
	

func _handle_animation():
	if direction > 0:
		parent.side = "right"
	elif direction < 0:
		parent.side = "left"
	
	if _is_wallclimbing: anim = "wall_climb_"
	else: anim = "wall_grab_"
	
	parent.animation_player.play(anim + parent.side)

func _on_climb_end(animation: String):
	if animation == str("wall_climb_"+parent.side):
		_is_wallclimbing = false
		var x_ref = x_offset
		if parent.side == "left": x_ref = -x_ref
		parent.global_position = parent.global_position + Vector2(x_ref, -y_offset)
