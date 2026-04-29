extends TileMapLayer
@onready var game_board: Node2D = $".."

var BOMB_POSITIONS = []
var NO_BOMBS = []
var FLAGGED = []
var CHECK_NEXT = []
var BOARD = []
var board_size


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var source_id = 10 # Source ID of your tileset
	var atlas_coords = Vector2(0, 0) # Coords of tile in atlas
	var bias = randi_range(-3,3)
	if GLOBAL.difficulty_board_size < 10:
		bias = randi_range(0,3)
	board_size = (GLOBAL.difficulty_board_size + bias) * GLOBAL.difficulty_board_size
	print(board_size)
	
	for x in range(GLOBAL.difficulty_board_size + bias):
		for y in range(GLOBAL.difficulty_board_size):
			set_cell(Vector2(x, y), source_id, atlas_coords)
			BOARD.append(get_used_cells().find(Vector2(x, y)))
	
	var rect = get_used_rect()
	print("\n-"+str(rect.size.x)+"-\n")
	var center
	if _is_even(rect.size.x):
		#print(rect.position)
		#print(rect.size)
		
		center = map_to_local(rect.position + rect.size/2)
		center.x = center.x - 16
	else:	
		center = map_to_local(rect.position + rect.size/2)
		
	#print(center)
	#print(NO_BOMBS)
	$Camera2D.position = center

func generate_bombs(safe):
	var max_bombs = round(board_size*GLOBAL.max_bombs/100)
	NO_BOMBS = BOARD
	var do_bomb: int
	for i in range(max_bombs):
		do_bomb = randi_range(0,board_size)
		if do_bomb not in BOMB_POSITIONS and do_bomb != safe:
			BOMB_POSITIONS.append(do_bomb)
			BOARD.erase(do_bomb)
	NO_BOMBS = BOARD
	BOMB_POSITIONS.sort()
	print(NO_BOMBS)
	print(BOMB_POSITIONS)
	GLOBAL.board_revealed = true
	


func _is_even(x: int):
	return x % 2 == 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _input(event : InputEvent) -> void:
	var m_pos: Vector2 = get_global_mouse_position()
	if get_used_rect().has_point(m_pos/32):
		var clicked = get_used_cells().find(Vector2(m_pos.x/32,m_pos.y/32))
		if (event.is_action_pressed("action")):
			if GLOBAL.board_revealed == false:
				generate_bombs(clicked)
			reveal(clicked)
				#print("\n***"+str(FLAGGED)+" =?= "+str(BOMB_POSITIONS)+"***\n")

		if (event.is_action_pressed("action_r")):
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

	if NO_BOMBS.is_empty() and FLAGGED == BOMB_POSITIONS and GLOBAL.board_revealed == true:
		print("*************************\nYOU WIN\n*************************")
		$"..".result(true)


	for i in CHECK_NEXT:
		reveal(i)


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
	#var m_pos: Vector2 = get_global_mouse_position()
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
