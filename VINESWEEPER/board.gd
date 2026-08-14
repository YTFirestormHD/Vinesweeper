extends TileMapLayer
@onready var game_board: Node2D = $".."
@onready var options: Panel = $Camera2D/Options


var game_over: bool = false
var BOMB_POSITIONS = []
var NO_BOMBS = []
var FLAGGED = []
var CHECK_NEXT = []
var BOARD = []
var board_size
var REVEALED = []
var AROUND_X = [-1, -1, -1,  0,  0,  1,  1,  1]
var AROUND_Y = [-1,  0,  1, -1,  1, -1,  0,  1]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game_over = false
	var source_id = 10 # Source ID of your tileset
	var atlas_coords = Vector2(0, 0) # Coords of tile in atlas
	if GLOBAL.board_revealed == true:
		for x in range(GLOBAL.board_size_x):
			for y in range(GLOBAL.board_size_y):
				set_cell(Vector2(x, y), source_id, atlas_coords)
		BOMB_POSITIONS = GLOBAL.BOMBS_safe
		NO_BOMBS = GLOBAL.NO_BOMBS_safe
		REVEALED = GLOBAL.REVEALED_safe
		FLAGGED = GLOBAL.FLAGGED_safe
		for i in REVEALED:
			reveal(i)
		for j in FLAGGED:
			set_cell(get_used_cells()[j],11,Vector2(0,0))
	
	elif GLOBAL.board_revealed == false:
		GLOBAL.time_passed = 0
		GLOBAL.time_seconds = 0
		GLOBAL.time_minutes = 0
		var bias = randi_range(-2,3)
		if GLOBAL.difficulty_board_size < 10:
			bias = randi_range(0,3)
			#print(board_size)
			
		for x in range(GLOBAL.difficulty_board_size + bias):
			for y in range(GLOBAL.difficulty_board_size):
				set_cell(Vector2(x, y), source_id, atlas_coords)
				BOARD.append(get_used_cells().find(Vector2(x, y)))
		GLOBAL.board_size_x = GLOBAL.difficulty_board_size + bias
		GLOBAL.board_size_y = GLOBAL.difficulty_board_size

	var rect = get_used_rect()
	#print("\n-"+str(rect.size.x)+"-\n")
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


func _is_even(x: int):
	return x % 2 == 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _input(event : InputEvent) -> void:
	if game_over == false and options.visible == false:
		var m_pos: Vector2 = get_global_mouse_position()
		if get_used_rect().has_point(m_pos/32):
			var clicked = get_used_cells().find(Vector2(m_pos.x/32,m_pos.y/32))
			if (event.is_action_pressed("action")):
				if GLOBAL.board_revealed == false:
					generate_bombs(get_used_cells()[clicked])
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
			win()

		for i in CHECK_NEXT:
			reveal(i)


func win():
	$"../Timer".set_process(false)
	#print("*************************\nYOU WIN\n*************************")
	calc_income()
	game_over = true
	$"..".result("win")

func lose():
	$"../Timer".set_process(false)
	game_over = true
	GLOBAL.lives -= 1
	$"..".load_lives()
	#print("*************************\nYOU BLEW UP\n*************************")
	if GLOBAL.lives > 0:
		$"..".result("lose")
	else:
		$"..".result("dead")


func generate_bombs(safe_1):
	var board_size = GLOBAL.board_size_x * GLOBAL.board_size_y
	var safe = []
	
	safe.append(safe_1)
	for i in range(8):
		var safe_around = safe_1 + Vector2i(AROUND_X[i], AROUND_Y[i])
		safe.append(safe_around)
	print(safe)
	#print("bsz+mxb")
	#print(board_size)
	var max_bombs = ceil(board_size*GLOBAL.max_bombs/100)
	#print(max_bombs)
	#print("///")
	NO_BOMBS = BOARD
	var do_bomb: int
	while BOMB_POSITIONS.front() == null:
		for i in range(max_bombs):
			do_bomb = randi_range(0,board_size-1)
			if do_bomb not in BOMB_POSITIONS and get_used_cells()[do_bomb] not in safe:
				BOMB_POSITIONS.append(do_bomb)
				BOARD.erase(do_bomb)
	NO_BOMBS = BOARD
	BOMB_POSITIONS.sort()
	#print(NO_BOMBS)
	#print(BOMB_POSITIONS)
	if not game_over:
		GLOBAL.board_revealed = true


func reveal(clicked):
	if get_cell_source_id(get_used_cells()[clicked]) == 10:
		if BOMB_POSITIONS.has(clicked):
			lose()
		else:
			NO_BOMBS.erase(clicked)
			REVEALED.append(clicked)
			set_cell(get_used_cells()[clicked],check_around(clicked),Vector2(0,0))
			#print(NO_BOMBS)


func check_around(clicked) -> int:
	var cell_pos = get_used_cells()[clicked]
	var around_count: int = 0
	var valid_neighbors = []

	for i in range(8):
		var neighbor_pos = cell_pos + Vector2i(AROUND_X[i], AROUND_Y[i])
		var neighbor_index = get_used_cells().find(neighbor_pos)
		
		# Ensure the neighbor actually exists on the board
		if neighbor_index != -1:
			if BOMB_POSITIONS.has(neighbor_index):
				around_count += 1
			else:
				valid_neighbors.append(neighbor_index)

	# Classic Minesweeper rule: Only cascade/auto-reveal neighbors if 0 bombs are adjacent
	if around_count == 0:
		for neighbor_index in valid_neighbors:
			# Check if the tile is still hidden (source id 10) and not already queued or revealed
			if get_cell_source_id(get_used_cells()[neighbor_index]) == 10:
				if not CHECK_NEXT.has(neighbor_index) and not REVEALED.has(neighbor_index):
					CHECK_NEXT.append(neighbor_index)

	return around_count


func calc_income():
	var time_taken = GLOBAL.time_minutes*60 + GLOBAL.time_seconds
	var correct = 0
	var incorrect = 0
	var all_correct = false
	for i in FLAGGED:
		if i in BOMB_POSITIONS:
			correct += 1
		else:
			incorrect += 1
	if FLAGGED == BOMB_POSITIONS:
		all_correct = true
	#print("###########")
	#print("cor: "+str(correct))
	#print("inc: "+str(incorrect))
	#print("time:"+str(time_taken/5))
	if all_correct:
		correct *= 2
	#print(correct)
	#print(time_taken/20)
	#print(incorrect)
	var new_coins =  correct - time_taken/20 - incorrect
	#print(new_coins)
	GLOBAL.new_coins = new_coins if new_coins > 0 else 0 
	#print("new: "+str(GLOBAL.new_coins))
	#print("############")
	GLOBAL.coins += GLOBAL.new_coins


func safe_game():
	GLOBAL.BOMBS_safe = BOMB_POSITIONS
	GLOBAL.REVEALED_safe = REVEALED
	GLOBAL.FLAGGED_safe = FLAGGED


func _on_button_pressed() -> void:
	win()


func _on_check_pressed() -> void:
	if GLOBAL.board_revealed and not NO_BOMBS.is_empty() and FLAGGED != BOARD and FLAGGED != BOMB_POSITIONS and GLOBAL.items["check"] > 0:
		GLOBAL.items["check"] -= 1
		reveal(NO_BOMBS.pick_random())
