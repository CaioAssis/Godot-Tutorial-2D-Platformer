extends Area2D
class_name HitBox

@export var actor: Node2D
@export var cut_area: Area2D = null
@export var has_memory: bool = false
@export var is_dot_area: bool = false

var _hit_memory: Array[HurtBox] = []

signal HIT(entity: Node2D)

var attack: int

#inicia hitbox para perceber com o layer 3 (bit 4)
func _init() -> void:
	collision_layer = 0
	collision_mask = 4

#adiciona os atributos do ataque
func _ready() -> void:
	if not is_dot_area:
		connect("area_entered", self._on_area_entered)
	

func _on_area_entered(hurtbox: Area2D) -> void:
	if hurtbox == null:
		#print('hurtbox null')
		return
	if not hurtbox is HurtBox:
		#print('not a hurtbox: ', hurtbox)
		return

	#ignora quem está dentro da cut_area
	if cut_area and cut_area.get_overlapping_areas().has(hurtbox):
		return

	var hb_actor = hurtbox.actor
	if hb_actor.group == actor.group:
		return
	
	#ignora se tem na memoria que ja hitou
	if not _hit_memory.is_empty() and _hit_memory.has(hurtbox):
		return

	#aqui vem dano!

	#Grava na memoria
	if has_memory:
		_hit_memory.append(hurtbox)
	_get_attack_props()
	
	if hb_actor is CharacterBody2D:
		HIT.emit(hb_actor)
	if hurtbox.has_method("hit"):
		hurtbox.hit(attack)

func _get_attack_props():
	attack = actor.damage

func reset_hit_memory():
	_hit_memory.clear()
	for area in get_overlapping_areas():
		_on_area_entered(area)
