extends State
class_name  Charge

@export var move_speed := 20.0
@export var actor: CharacterBody2D
@export var animated_sprite: AnimatedSprite2D
@export var animated_sprite_emotion: AnimatedSprite2D
@export var ray_cast_barrier: RayCast2D

var move_direction: Vector2

func Enter():
	if ray_cast_barrier.target_position.x > 0:
		move_direction = Vector2(1, 0)
		emote_side(true)
	else:
		move_direction = Vector2(-1, 0)
		emote_side(false)
	animated_sprite_emotion.play('Atention')
	actor.velocity = move_direction * move_speed * 1.4

func Update(delta: float):
	if reached_wall():
		Exit()

func Physics_Update(delta: float):
	animated_sprite.play('walk')

func Exit():
	actor.velocity = Vector2(0,0)
	animated_sprite_emotion.stop()
	Transitioned.emit(self, "idle")

func reached_wall() -> bool:
	if ray_cast_barrier:
			if ray_cast_barrier.is_colliding():
				return true
	return false

##Altera o lado do emote. True = Direita
func emote_side(side: bool):
	if side && animated_sprite_emotion.position.x < 0:
		animated_sprite_emotion.position.x = animated_sprite_emotion.position.x * -1
	elif not side && animated_sprite_emotion.position.x > 0:
		animated_sprite_emotion.position.x = animated_sprite_emotion.position.x * -1
