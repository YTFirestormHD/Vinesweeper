extends Control

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


func _process(delta: float) -> void:
	pass


func _on_number_pressed() -> void:
	get_tree().change_scene_to_file("res://game_board.tscn")
