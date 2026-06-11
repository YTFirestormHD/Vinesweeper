extends Control

@onready var options: Panel = $Options
@onready var margin_container: MarginContainer = $MarginContainer
@onready var v_box_container: VBoxContainer = $MarginContainer/HBoxContainer/VBoxContainer
#@onready var center_container: CenterContainer = $MarginContainer/HBoxContainer/CenterContainer
@onready var board_size_slider: HSlider = $Options/VBoxContainer/VBoxContainer2/VBoxContainer/Board_Size_Slider
@onready var max_bombs_slider: HSlider = $Options/VBoxContainer/VBoxContainer2/VBoxContainer/Max_Bombs_Slider
@onready var fullscreen_button: CheckButton = $Options/VBoxContainer/VBoxContainer2/Fullscreen_Button
@onready var continue_button: Button = $MarginContainer/HBoxContainer/VBoxContainer/Menu_Options/continue
@onready var credits_button: Button = $MarginContainer/HBoxContainer/VBoxContainer/Menu_Options/credits



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GLOBAL.difficulty_board_size = GLOBAL.difficulty_board_size_basis
	GLOBAL.max_bombs = GLOBAL.max_bombs_basis
	continue_button.visible = false
	credits_button.visible = false
	if GLOBAL.map_done:
		continue_button.visible = true
	if GLOBAL.beaten_once:
		credits_button.visible = true
	options.visible = false
	v_box_container.visible = true
	board_size_slider.set_value(GLOBAL.difficulty_board_size)
	max_bombs_slider.set_value(GLOBAL.max_bombs)
	fullscreen_button.set_pressed_no_signal(GLOBAL.fullscreen)
	print(GLOBAL.board_revealed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _continue_button_pressed() -> void:
	GLOBAL.continue_flag = true
	get_tree().change_scene_to_file("res://scenes/leveltree.tscn")


func _newgame_button_pressed() -> void:
	reset_game()
	get_tree().change_scene_to_file("res://scenes/leveltree.tscn")


func _options_button_pressed() -> void:
	options.visible = true
	margin_container.visible = false


func _leave_options():
	options.visible = false
	margin_container.visible = true


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_credits_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/credits.tscn")


func _input(event):
	if event.is_action_pressed("ui_cancel") and options.visible == true:
		options.visible = false
		margin_container.visible = true
		GLOBAL.difficulty_board_size = board_size_slider.value
		
	if event.is_action_pressed("F11"):
		if GLOBAL.fullscreen:
			go_fullscreen(false)
		else:
			go_fullscreen(true)


func _on_fullscreen_button_toggled(toggled_on: bool) -> void:
	go_fullscreen(toggled_on)


func go_fullscreen(toggled_on):
	if toggled_on == true:
		GLOBAL.fullscreen = true
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	else:
		GLOBAL.fullscreen = false
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)


func _on_options_close_pressed() -> void:
	options.visible = false
	margin_container.visible = true
	GLOBAL.difficulty_board_size = board_size_slider.value
	GLOBAL.max_bombs = (max_bombs_slider.value)/100


func reset_game():
	GLOBAL.board_revealed = false
	GLOBAL.difficulty_board_size = GLOBAL.difficulty_board_size_basis
	GLOBAL.max_bombs = GLOBAL.max_bombs_basis
	GLOBAL.current_level = 1
	GLOBAL.coins = 0
	GLOBAL.new_coins = 0
	GLOBAL.map_done = false
	GLOBAL.items = GLOBAL.start_items
