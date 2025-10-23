extends Label

#@export var fsm: FSMDescentralizado
#var last_state: State = null
#func _process(_delta: float) -> void:
	#if fsm and fsm.current_state != last_state:
		#last_state = fsm.current_state
		#text = str(last_state.name)

@export var player: PlatformPlayer = null
var timer: float = 0
var refresh_time: float = 0.1
func _process(delta: float) -> void:
	if not player: return
	timer += delta
	if timer >= refresh_time:
		text = str(int(player.velocity.x))
		timer = 0
