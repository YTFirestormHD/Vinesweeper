extends Label
@onready var slider: HSlider = $"../Board_Size_Slider"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_text("Max Board Size: "+str(int(slider.value)))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_board_size_slider_value_changed(value: float) -> void:
	set_text("Max Board Size: "+str(int(slider.value)))
