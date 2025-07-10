extends State
class_name  Wander

@export var move_speed := 20.0
@export var actor: CharacterBody2D
@export var animated_sprite: AnimatedSprite2D
@export var ray_cast_barrier: RayCast2D
@export var ray_cast_vision: RayCast2D

var move_direction: Vector2
var wander_time: float

func Enter():
	move_speed = move_speed * (randi_range(80, 100))/100
	randomize_wander()

func Exit():
	actor.velocity = Vector2(0,0)

func Update(delta: float):
	if wander_time > 0:
		wander_time -= delta
	
	else:
		Exit()
		Transitioned.emit(self, "Idle")

func Physics_Update(delta: float):
	if actor:
		actor.velocity = move_direction * move_speed
		if has_seen_player():
			Exit()
			Transitioned.emit(self, "Charge")
		if reached_wall():
			Exit()
			Transitioned.emit(self, "Idle")

##Prepara lado e tempo que a entidade se moverá.
func randomize_wander():
	
	if reached_wall():
		if facing():
			turn_vision(-1)
			move_direction = Vector2(-1, 0)
		else:
			turn_vision(1)
			move_direction = Vector2(1, 0)
		await get_tree().process_frame
	else:
		move_direction = Vector2(randf_range(-1,1), 0).normalized()
		turn_vision(move_direction.x)
	wander_time = randf_range(1,4)
	walk_direction()

## altera o lado que a entidade está olhando. Inicia animação.
func walk_direction():
	if animated_sprite:
		animated_sprite.play('walk')
		if move_direction.x > 0:
			animated_sprite.flip_h = false
		elif move_direction.x < 0:
			animated_sprite.flip_h = true

##Checa se chegou a um obstáculo. True = Sim
func reached_wall() -> bool:
	if ray_cast_barrier:
			if ray_cast_barrier.is_colliding():
				return true
	return false

##Checa lado que está olhando. True = Direita
func facing() -> bool:
	if ray_cast_barrier.target_position.x > 0:
		return true
	else:
		return false

##Altera o lado que está olhando. > 0 = Direita
func turn_vision(side: float):
	if side < 0 && ray_cast_barrier.target_position.x > 0:
		ray_cast_barrier.target_position.x = -1 * ray_cast_barrier.target_position.x
		ray_cast_vision.target_position.x = -1 * ray_cast_vision.target_position.x
	if side > 0 && ray_cast_barrier.target_position.x < 0:
		ray_cast_barrier.target_position.x = -1 * ray_cast_barrier.target_position.x
		ray_cast_vision.target_position.x = -1 * ray_cast_vision.target_position.x

func has_seen_player() -> bool:
	if ray_cast_vision.is_colliding():
		var collider = ray_cast_vision.get_collider()
		if collider.get_class() == 'CharacterBody2D':
			return true
	return false
	
