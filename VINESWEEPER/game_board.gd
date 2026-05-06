extends Node2D
@onready var options: Panel = $TileMapLayer/Camera2D/Options
@onready var background: Panel = $Background
@onready var tml: TileMapLayer = $TileMapLayer
@onready var lose: VBoxContainer = $Background/Result/Lose
@onready var win: VBoxContainer = $Background/Result/Win
@onready var timer_display: Label = $Timer_Display



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_background()
	load_timer()
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


func back_to_title() -> void:
	tml.safe_game()
	get_tree().change_scene_to_file("res://Main_Menu.tscn")


func load_background():
	var style_box: StyleBoxTexture = background.get_theme_stylebox("panel")
	style_box.texture = load("res://assets/bg_images/jungle-landscape-pixel-art-style.png")
	background.add_theme_stylebox_override("panel", style_box)
	background.set_position(Vector2(-(get_viewport_rect().size.x/2-$TileMapLayer/Camera2D.position.x),-(get_viewport_rect().size.y/2-$TileMapLayer/Camera2D.position.y)))


func load_timer():
	timer_display.set_position(Vector2(-(get_viewport_rect().size.x/2-$TileMapLayer/Camera2D.position.x),-(get_viewport_rect().size.y/2-$TileMapLayer/Camera2D.position.y)))


func result(result_bool):
	GLOBAL.board_revealed = false
	if result_bool == true:
		tml.visible = false
		win.visible = true
	else:
		tml.visible = false
		lose.visible = true
