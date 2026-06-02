extends TileMapLayer

@onready var new_map: TileMapLayer = $"."
@onready var cam: Camera2D = $"../Camera2D"


var row
var m_pos
var clicked
var all_cells
var all_rows: Array
var current_row = []
var point_a = Vector2(0,0)
var point_b = Vector2(0,0)
var connections = []
var has_connection = []
var current_level
var path = -1
var PATHS = []
var current_path = []
var path_nodes = {}
var previous_nodes = {}
var previous_node = 0
var finished = []


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if GLOBAL.map_done:
		load_map()
	else:
		current_path = GLOBAL.current_path
		current_level = GLOBAL.current_level-1
		all_cells = get_used_cells()
		all_cells.sort_custom(array_sort)
		
		for i in range(len(all_cells)):
			var j = all_cells[i]
			if i == 0:
				#print(j)
				current_row.append(j)
			if j.y == all_cells[i-1].y:
				#print("^ same as v")
				#print(j)
				#print(j.y)
				current_row.append(j)
				#print(current_row)
			elif j.y >= all_cells[i-1].y:
				#print("not the same")
				all_rows.append(current_row.duplicate())
					
				current_row.clear()
				current_row.append(j)
				#print(j)
		all_rows.append(current_row.duplicate())
		current_row.clear()
		#print(all_rows)
		
		for j in range(len(all_rows[0])):
				PATHS.append([])
			
		for i in all_rows[0]:
			path += 1
			make_path(i,0,path)
			
	for i in all_cells:
		if not has_connection.has(i) and i != all_cells.back():
			#print(i)
			new_map.erase_cell(i)
		GLOBAL.map_done = true
	cam.global_position.y = map_to_local(all_rows[current_level][0]).y
	set_types()
	safe()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _draw():
	for connection in connections:
		draw_line(connection[0], connection[1], Color.RED, 3)


func _input(event: InputEvent) -> void:
	if (event.is_action_pressed("action")):
		m_pos = get_global_mouse_position()
		clicked = local_to_map(m_pos)
		if current_path == []:
			choose_path(clicked)
			#print(current_path)
		
		if clicked.y != all_rows[0][0].y:
			#print(previous_nodes[current_path[current_level]])
			#print("Previous: "+str(previous_node))
			#print("Previous_2: "+str(previous_nodes[clicked]))
			#print(previous_nodes)
			if all_cells.has(clicked) and clicked.y == all_rows[current_level][0].y and check_previous(clicked):
				#print(previous_nodes)
				previous_node = clicked
				#print(previous_node)
				safe()
				enter_level(clicked)
		elif all_cells.has(clicked) and clicked.y == all_rows[current_level][0].y:
			previous_node = clicked
			#print(previous_node)
			safe()
			enter_level(clicked)


func array_sort(a: Vector2i,b: Vector2i):
	if a.y == b.y:
		return a.x < b.x
	return a.y < b.y


func make_path(start,row,path):
	#if not PATHS[path].has(start):
	PATHS[path].append(start)
	PATHS[path].sort_custom(array_sort)
	generate_type(start,row)
	if row < len(all_rows)-1:
		has_connection.append(start)
		point_a = map_to_local(start)
		#print(point_a)
		#var next = (all_rows[row]).pick_random()
		var next = pick_closest(start, row)
		row += 1
		var may_next = pick_random(start, row, next)
		point_b = map_to_local(next)
		connections.append([point_a,point_b])
		if may_next != Vector2i(0,0):
			connections.append([point_a,map_to_local(may_next)])
			previous_nodes[may_next] = start
			make_path(may_next,row,path)
		previous_nodes[next] = start
		make_path(next,row,path)
		if may_next != Vector2i(0,0):
			print(str(may_next)+ " : " + str(previous_nodes[may_next]))
			print(str(next)+ " : " + str(previous_nodes[next]))
	else:
		point_a = map_to_local(start)
		#print(point_a)
		var next = (all_rows[row]).pick_random()
		point_b = map_to_local(next)
		#print(next)
		previous_nodes[next] = start
		connections.append([point_a,point_b])
		#print(previous_nodes)


func pick_closest(pos, row):
	var closest
	var distance = 10000000
	#print("///")
	#print(pos)
	for i in all_rows[row+1]:
		#print(i)
		if abs(pos.x - i.x) < distance:
			distance = abs(pos.x - i.x)
			closest = i
	#print(closest)
	return closest


func pick_random(start, row, used):
	var chance = len(all_rows[row])*5
	#print("chance: "+str(chance))
	var pop = all_rows[row].find(used)
	var pool = all_rows[row].duplicate()
	pool.remove_at(pop)
	var roll = randi_range(0,100)
	if chance >= roll and len(pool) != 0:
		#print(pool)
		var next = pool.pick_random()
		#print("Random next: "+str(next))
		return next
	else:
		return Vector2i(0,0)


func choose_path(from):
	for i in PATHS:
		if i.has(from):
			current_path = i
			GLOBAL.current_path = i


func enter_level(clicked):
	finished.append(clicked)
	GLOBAL.difficulty_board_size += (GLOBAL.current_level - 1) * 1.2
	if GLOBAL.difficulty_board_size > 18:
		GLOBAL.difficulty_board_size = 18
	GLOBAL.max_bombs += (GLOBAL.current_level) * (GLOBAL.current_level*2/3)
	if GLOBAL.max_bombs > 40:
		GLOBAL.max_bombs = 40
	if GLOBAL.current_level == len(all_rows):
		get_tree().change_scene_to_file("res://end_screen.tscn")
	else:
		get_tree().change_scene_to_file("res://game_board.tscn")


func safe():
	GLOBAL.leveltree = [all_cells,all_rows,current_row,connections,has_connection,PATHS,current_path,path_nodes,previous_node,previous_nodes,finished]


func load_map():
	all_cells = GLOBAL.leveltree[0]
	all_rows = GLOBAL.leveltree[1]
	current_row = GLOBAL.leveltree[2]
	connections = GLOBAL.leveltree[3]
	has_connection = GLOBAL.leveltree[4]
	PATHS = GLOBAL.leveltree[5]
	current_path = GLOBAL.leveltree[6]
	#print(current_path)
	current_level = GLOBAL.current_level-1
	path_nodes = GLOBAL.leveltree[7]
	previous_node = GLOBAL.leveltree[8]
	previous_nodes = GLOBAL.leveltree[9]
	finished = GLOBAL.leveltree[10]


func generate_type(node,row):
	var roll = randi_range(1,100)
	if row <= 1:
		path_nodes[node] = 3
	elif row == len(all_rows)-2:
		path_nodes[node] = 2
	elif row == len(all_rows)-1:
		path_nodes[node] = 4
	elif roll < 10:
		path_nodes[node] = 1
		#Random Event
	elif roll < 30:
		path_nodes[node] = 2
		#Shop
	else:
		path_nodes[node] = 3
		#Normal Encounter


func set_types():
	for i in path_nodes:
		#print(i, path_nodes[i])
		if i in current_path or current_path == []:
			set_cell(i,path_nodes[i],Vector2(0,0))
		else:
			set_cell(i,path_nodes[i]+10,Vector2(0,0))
	for i in finished:
		set_cell(i,path_nodes[i]+10,Vector2(0,0))


func check_previous(clicked):
	if current_path.has(clicked):
		print("///")
		print(str(previous_node) + "==" + str(previous_nodes[clicked]))
		if previous_nodes[clicked] == previous_node:
			#print(str(previous_node)+ " : " + str(previous_nodes[clicked]))
			#print(str(previous_node)+ " : " + str(previous_nodes[clicked]))
			return true
	else:
		return false
