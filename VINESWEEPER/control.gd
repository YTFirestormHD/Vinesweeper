extends TileMapLayer


func _ready():
	var grid_size: Vector2i = Vector2i(GLOBAL.difficulty_board_size, GLOBAL.difficulty_board_size)
	var tile_size = tile_set.tile_size
	
	var total_grid_size = Vector2(grid_size.x * tile_size.x, grid_size.y * tile_size.y)
	
	var screen_center = get_viewport_rect().size / 2
	
	position = screen_center - (total_grid_size / 2)
