extends Control
@onready var timer: Timer = $Timer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	GLOBAL.map_done = false
	GLOBAL.board_revealed = false
	get_tree().change_scene_to_file("res://Main_Menu.tscn")
