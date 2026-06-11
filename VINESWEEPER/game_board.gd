extends Node2D
@onready var options: Panel = $board/Camera2D/Options
@onready var background: Panel = $Background
@onready var tml: TileMapLayer = $board
@onready var lose: VBoxContainer = $Background/Result/MarginContainer/Lose
@onready var win: VBoxContainer = $Background/Result/MarginContainer/Win
@onready var dead: VBoxContainer = $Background/Result/MarginContainer/Dead
@onready var timer: Label = $Timer
@onready var level_display_during_game: Label = $Level_display_during_game
@onready var level: Label = $Level
@onready var cam: Camera2D = $board/Camera2D
@onready var heart_1: TextureRect = $Background/Hearts/heart_1
@onready var heart_2: TextureRect = $Background/Hearts/heart_2
@onready var heart_3: TextureRect = $Background/Hearts/heart_3

var delta = 1/60
var heart_dead = preload("res://assets/other/heart_dead.png")
var heart = preload("res://assets/other/heart.png")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_background()
	load_displays()
	options.visible = false
	win.visible = false
	lose.visible = false
	dead.visible = false


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
	load_lives()


func load_lives():
	var hearts = [heart_3,heart_2,heart_1]
	for i in hearts:
		i.texture = heart_dead
	for i in range(GLOBAL.lives):
		hearts[i].texture = heart
	


func result(res):
	#true = win
	if res == "win":
		tml.visible = false
		win.visible = true
		dead.visible = false
	elif res == "lose":
		tml.visible = false
		lose.visible = true
		dead.visible = false
	else:
		tml.visible = false
		lose.visible = false
		dead.visible = true
	GLOBAL.board_revealed = false
