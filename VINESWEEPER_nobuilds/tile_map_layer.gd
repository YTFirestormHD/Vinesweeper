extends TileMapLayer
@onready var game_board: Node2D = $".."

var BOMB_POSITIONS = []
var NO_BOMBS = []
var FLAGGED = []
var CHECK_NEXT = []


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var source_id = 10 # Source ID of your tileset
	var atlas_coords = Vector2(0, 0) # Coords of tile in atlas
	var bias = randi_range(-3,3)
	if GLOBAL.difficulty_board_size < 10:
		bias = randi_range(0,3)
	var board_size = (GLOBAL.difficulty_board_size + bias) * GLOBAL.difficulty_board_size
	var max_bombs = round(board_size*GLOBAL.max_bombs/100)
	print(board_size)
	print(GLOBAL.max_bombs)
	print(max_bombs)
	
	for x in range(GLOBAL.difficulty_board_size + bias):
		for y in range(GLOBAL.difficulty_board_size):
			set_cell(Vector2(x, y), source_id, atlas_coords)
			
			
			var do_bomb = randi_range(1,100)
			if do_bomb < 20 and max_bombs != 0:
				var bomb_pos = get_used_cells().find(Vector2(x,y))
				BOMB_POSITIONS.append(bomb_pos)
				max_bombs -= 1
				#print(GLOBAL.max_bombs)
				print(str(BOMB_POSITIONS)+" (up->down, left->right ...remember to start counting from zero)")
			else:
				var no_bomb_pos = get_used_cells().find(Vector2(x,y))
				NO_BOMBS.append(no_bomb_pos)
	
	var rect = get_used_rect()
	print("\n-"+str(rect.size.x)+"-\n")
	var center
	if _is_even(rect.size.x):
		#print(rect.position)
		#print(rect.size)
		
		center = map_to_local(rect.position + rect.size/2)
		center.x = center.x - 8
	else:	
		center = map_to_local(rect.position + rect.size/2)
		
	#print(center)
	#print(NO_BOMBS)
	BOMB_POSITIONS.sort()
	$Camera2D.position = center


func _is_even(x: int):
	return x % 2 == 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:	
	pass


func _input(event : InputEvent) -> void:
	if (event.is_action_pressed("action")):
		var m_pos: Vector2 = get_global_mouse_position()
		if get_used_rect().has_point(m_pos/16):
			var clicked = get_used_cells().find(Vector2(m_pos.x/16,m_pos.y/16))
			reveal(clicked)
			#print("\n***"+str(FLAGGED)+" =?= "+str(BOMB_POSITIONS)+"***\n")

	if (event.is_action_pressed("action_r")):
		var m_pos: Vector2 = get_global_mouse_position()
		if get_used_rect().has_point(m_pos/16):
			var clicked = get_used_cells().find(Vector2(m_pos.x/16,m_pos.y/16))
			
			if get_cell_source_id(get_used_cells()[clicked]) == 10:
				set_cell(get_used_cells()[clicked],11,Vector2(0,0))
				if FLAGGED.has(get_used_cells()[clicked]) == false:
					FLAGGED.append(clicked)
					FLAGGED.sort()
					#print(FLAGGED)
				
			elif get_cell_source_id(get_used_cells()[clicked]) == 11:
				set_cell(get_used_cells()[clicked],10,Vector2(0,0))
				FLAGGED.erase(clicked)
				FLAGGED.sort()
				#print(FLAGGED)

	for i in CHECK_NEXT:
		reveal(i)

	if NO_BOMBS.is_empty() and FLAGGED == BOMB_POSITIONS:
		print("*************************\nYOU WIN\n*************************")
		$"..".result(true)


func reveal(clicked):
	if get_cell_source_id(get_used_cells()[clicked]) == 10:
		if BOMB_POSITIONS.has(clicked):
			print("*************************\nYOU BLEW UP\n*************************")
			$"..".result(false)
		else:
			NO_BOMBS.erase(clicked)
			set_cell(get_used_cells()[clicked],check_around(clicked),Vector2(0,0))
			#print(NO_BOMBS)


func check_around(clicked) -> int:
	var m_pos: Vector2 = get_global_mouse_position()
	var around_count: int = 0
	var AROUND_X = [-1,-1,-1,0,0,+1,+1,+1]
	var AROUND_Y = [-1,0,+1,-1,+1,-1,0,+1]
	var any_around = false
	for i in range(8):
		#print(get_used_cells()[clicked]-Vector2i(AROUND_X[i],AROUND_Y[i]))
		#print(get_cell_source_id(get_used_cells()[clicked]-Vector2i(AROUND_X[i],AROUND_Y[i])))
		if BOMB_POSITIONS.has(get_used_cells().find(get_used_cells()[clicked]-Vector2i(AROUND_X[i],AROUND_Y[i]))):
			around_count += 1
			any_around = true
		elif get_cell_source_id(get_used_cells()[clicked]-Vector2i(AROUND_X[i],AROUND_Y[i])) == 10 and any_around == false:
			if not CHECK_NEXT.has(get_used_cells().find(get_used_cells()[clicked]-Vector2i(AROUND_X[i],AROUND_Y[i]))):
				CHECK_NEXT.append(get_used_cells().find(get_used_cells()[clicked]-Vector2i(AROUND_X[i],AROUND_Y[i])))
	return around_count
