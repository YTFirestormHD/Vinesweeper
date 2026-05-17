extends Label
@onready var slider: HSlider = $"../Board_Size_Slider"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_text("Board Size: "+str(int(slider.value)))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	slider.value = GLOBAL.difficulty_board_size


func _on_board_size_slider_value_changed(value: float) -> void:
	set_text("Board Size: "+str(int(slider.value)))
	#print(get_text())
