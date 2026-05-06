extends Node


var difficulty_board_size: int = 4
var max_bombs: float = 1
var fullscreen: bool = false
var board_revealed = false
var board_size_x: int
var board_size_y: int
var NO_BOMBS_safe = []
var FLAGGED_safe = []
var BOMBS_safe = []
var REVEALED_safe = []


func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
