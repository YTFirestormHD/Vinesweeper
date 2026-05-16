extends Control
@onready var map: TextureRect = $Map
@onready var cam: Camera2D = $Camera2D
@onready var level1 = $Stump/Level1
@onready var level2 = $Stump2/Level2
@onready var level3 = $Stump3/Level3
@onready var level4 = $Stump4/Level4

var levels



func _ready() -> void:
	levels = [level1, level2, level3, level4]
	for level in levels:
		level.disabled = true
	levels[GLOBAL.current_level-1].disabled = false		#Not possible to generate random levels with this system. Will keep this for now, but i´ll optimize/change it once i got time.
	GLOBAL.difficulty_board_size += (GLOBAL.current_level - 1) * 1.7
	GLOBAL.max_bombs += ((GLOBAL.current_level - 1) + 1) * ((GLOBAL.current_level + 1) - 1)
	print(GLOBAL.max_bombs)


func _process(delta: float,) -> void:
	pass


func _input(event: InputEvent) -> void:
	if event.is_action("up") and not event.is_action_released("up"):
		if cam.global_position.y > map.position.y:
			cam.global_position.y -= 10
		#print(cam.global_position)
	if event.is_action("down") and not event.is_action_released("down"):
		if cam.global_position.y + get_viewport_rect().size.y + 2 <= map.size.y:
			cam.global_position.y += 10
			print(cam.global_position.y + get_viewport_rect().size.y + 2)
			print(map.size.y)
			print("///")


func _on_number_pressed() -> void:
	get_tree().change_scene_to_file("res://game_board.tscn")
