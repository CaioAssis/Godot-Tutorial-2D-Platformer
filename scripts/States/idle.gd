extends State
class_name  Idle

@export var actor: CharacterBody2D
@export var animated_sprite: AnimatedSprite2D
@export var ray_cast_vision: RayCast2D
@export var collision_shape_2d: CollisionShape2D

var idle_time: float

func randomize_idle():
	idle_time = randf_range(1,2)

func Enter():
	randomize_idle()

func Update(delta: float):
	if idle_time > 0:
		idle_time -= delta
	
	else:
		Transitioned.emit(self, "Wander")

func Physics_Update(delta: float):
	animated_sprite.play('idle')
	if has_seen_player():
			Transitioned.emit(self, "Charge")

func Exit():
	pass

func has_seen_player() -> bool:
	if ray_cast_vision.is_colliding():
		var collider = ray_cast_vision.get_collider()
		if collider.get_class() == 'CharacterBody2D':
			return true
	return false
