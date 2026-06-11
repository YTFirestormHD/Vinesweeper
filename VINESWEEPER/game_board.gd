extends Node2D
@onready var options: Panel = $board/Camera2D/Options
@onready var background: Panel = $Background
@onready var tml: TileMapLayer = $board
@onready var lose: VBoxContainer = $Background/Result/MarginContainer/Lose
@onready var win: VBoxContainer = $Background/Result/MarginContainer/Win
@onready var timer: Label = $Timer
@onready var level_display_during_game: Label = $Level_display_during_game
@onready var level: Label = $Level
@onready var cam: Camera2D = $board/Camera2D
var delta = 1/60


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_background()
	load_displays()
	options.visible = false
	win.visible = false
	lose.visible = false


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") and options.visible == false:
		options.visible = true
	elif event.is_action_pressed("ui_cancel") and options.visible == true:
		options.visible = false
	
	if event.is_action_pressed("ui_text_backspace"):
		get_tree().quit()


func _process(delta: float) -> void:
	pass


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_back_button_pressed() -> void:
	back_to_title()


func _on_continue_button_pressed() -> void:
	back_to_levels()


func back_to_title() -> void:
	tml.safe_game()
	get_tree().change_scene_to_file("res://scenes/Main_Menu.tscn")


func back_to_levels():
	GLOBAL.current_level += 1
	get_tree().change_scene_to_file("res://scenes/leveltree.tscn")


func load_background():
	var style_box: StyleBoxTexture = background.get_theme_stylebox("panel")
	#style_box.texture = load("res://assets/bg_images/jungle-landscape-pixel-art-style.png")
	#background.add_theme_stylebox_override("panel", style_box)
	background.set_position(Vector2(-(get_viewport_rect().size.x/2-cam.position.x),-(get_viewport_rect().size.y/2-cam.position.y)))


func load_displays():
	timer.set_position(Vector2(-(get_viewport_rect().size.x/2-cam.position.x),-(get_viewport_rect().size.y/2-cam.position.y)))
	level.set_position(Vector2(-(get_viewport_rect().size.x/2-cam.position.x),-(get_viewport_rect().size.y/2-cam.position.y)+20))


func result(result_win):
	#true = win
	if result_win == true:
		tml.visible = false
		win.visible = true
	else:
		tml.visible = false
		lose.visible = true
		reset_game()
	GLOBAL.board_revealed = false


func reset_game():
	GLOBAL.board_revealed = false
	GLOBAL.difficulty_board_size = GLOBAL.difficulty_board_size_basis
	GLOBAL.max_bombs = GLOBAL.max_bombs_basis
	GLOBAL.current_level = 1
	GLOBAL.coins = 0
	GLOBAL.new_coins = 0
	GLOBAL.map_done = false
	GLOBAL.items = GLOBAL.start_items
