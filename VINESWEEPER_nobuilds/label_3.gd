extends Label
@onready var slider: HSlider = $"../Max_Bombs_Slider"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_text("Max Bombs: "+str(int(slider.value))+"%")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_max_bombs_slider_value_changed(value: float) -> void:
	set_text("Max Bombs: "+str(int(slider.value))+"%")
	print(get_text())
