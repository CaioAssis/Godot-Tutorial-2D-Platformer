extends State
class_name  Hurt

@export var actor: CharacterBody2D
@export var animated_sprite: AnimatedSprite2D

func Enter():
	animated_sprite.play("hurt")

func Update(_delta: float):
	await get_tree().create_timer(0.3).timeout
	Transitioned.emit(self, "idle")
