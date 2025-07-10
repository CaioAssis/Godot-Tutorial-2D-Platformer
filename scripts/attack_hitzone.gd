extends Area2D

signal hit_registered(attacker: Node, target: Node)

func _on_body_entered(body: Node2D) -> void:
	if body.get_class() == "CharacterBody2D" && body.get_groups().has("Hostile"):
		hit_registered.emit(get_parent(), body)
