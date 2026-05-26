extends TileMapLayer

@onready var new_map: TileMapLayer = $"."

var row
var m_pos
var clicked
var all_cells
var all_rows: Array
var j: Vector2i
var current_row = []


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	'
	for i in range(5):
		var a = Vector2(i,i*2)
		var b = [a]	
		all_rows.append(b)
	print(all_rows)
	'
	all_cells = get_used_cells()
	all_cells.sort_custom(array_sort)
	
	for i in range(len(all_cells)):
		j = all_cells[i]
		if i == 0:
			print(j)
		if j.y == all_cells[i-1].y:
			print("^ same as v")
			print(j)
			current_row.append(j)
			#print(current_row)
		elif j.y >= all_cells[i-1].y:
			all_rows.append(current_row)
				
			#print(current_row)
			#current_row.clear()
			#print(j)
	print(all_rows)
	
	#for i in all_cells()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _input(event: InputEvent) -> void:
	if (event.is_action_pressed("action")):
		m_pos = get_global_mouse_position()
		clicked = get_used_cells().find(Vector2(m_pos.x/16,m_pos.y/16))
		if m_pos/16 in get_used_cells():
			row = self.map_to_local(event.position)/16


func array_sort(a: Vector2i,b: Vector2i):
	if a.y == b.y:
		return a.x < b.x
	return a.y < b.y
