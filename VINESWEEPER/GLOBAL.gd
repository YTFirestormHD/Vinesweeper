extends Node


var current_level: int = 1
var difficulty_board_size
var difficulty_board_size_basis: int = 4
var max_bombs
var max_bombs_basis: float = 2
var fullscreen: bool = false
var board_revealed = false
var board_size_x: int
var board_size_y: int
var NO_BOMBS_safe = []
var FLAGGED_safe = []
var BOMBS_safe = []
var REVEALED_safe = []
var time_passed
var time_seconds
var time_minutes
var coins = 0
var new_coins
var end_of_game
var current_path = []
var leveltree
var map_done = false
var continue_flag = false
var beaten_once = false
var start_items = {"check" : 3}
var items = {"check" : 3}

func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
