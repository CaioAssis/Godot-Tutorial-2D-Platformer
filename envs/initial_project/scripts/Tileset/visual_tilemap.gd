extends TileMapLayer
class_name TileMapHandler

@export var visual_tile_set: TileSet = null
@export var visual_tile_shader: ShaderMaterial = null

@onready var tile_dict: Dictionary = {
	[1,0,0,0] : [0,0],
	[0,1,0,0] : [1,0],
	[1,1,0,0] : [2,0],
	[0,0,1,0] : [3,0],
	[1,0,1,0] : [0,1],
	[0,1,1,0] : [1,1],
	[1,1,1,0] : [2,1],
	[0,0,0,1] : [3,1],
	[1,0,0,1] : [0,2],
	[0,1,0,1] : [1,2],
	[1,1,0,1] : [2,2],
	[0,0,1,1] : [3,2],
	[1,0,1,1] : [0,3],
	[0,1,1,1] : [1,3],
	[1,1,1,1] : [2,3]
}

var visual_layer: TileMapLayer
func _ready() -> void:
	if visual_tile_set:
		_create_visual_layer()
		apply_visual_layer()

func _create_visual_layer():
	visual_layer = TileMapLayer.new()
	visual_layer.tile_set = visual_tile_set
	visual_layer.global_position = Vector2(-visual_tile_set.tile_size.x/2.0, -visual_tile_set.tile_size.y/2.0)
	if visual_tile_shader:
		visual_layer.material = visual_tile_shader
	add_child(visual_layer)

func apply_visual_layer():
	for cell in get_used_cells():
		place_visual_tile(cell)

func place_visual_tile(tile_pos: Vector2i) -> void:
	for y: int in range(2):
		for x: int in range(2):
			var neighbors: Array = _get_tile_neighbors(tile_pos + Vector2i(x, y))
			if neighbors == [0,0,0,0]: continue
			var tile_placement: Array = tile_dict.get(neighbors)
			visual_layer.set_cell(tile_pos + Vector2i(x,y), 1, Vector2i(tile_placement[0], tile_placement[1]), 0)

func _get_tile_neighbors(coord: Vector2i) -> Array:
	var neighbors: Array = [0,0,0,0]
	var step: int = 0
	var neighbor: Vector2i = Vector2i(0,0)
	for y: int in range(2):
		for x: int in range(2):
			neighbor = get_cell_atlas_coords(coord - Vector2i(1,1) + Vector2i(x,y))
			if neighbor.y != -1:
				neighbors[step] = 1
			else:
				neighbors[step] = 0
			step += 1
	return neighbors
