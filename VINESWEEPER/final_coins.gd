extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_text("\nYou found a total of "+str(GLOBAL.coins)+" Coin(s) on your journey!")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
