extends CharacterBody2D
class_name Slime

@onready var collision_shape: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	add_to_group("Hostile")

func _physics_process(delta: float):
	move_and_slide()

func on_attacked():
	var state_machine = self.get_node("State Machine")
	state_machine.change_state("Hurt")
