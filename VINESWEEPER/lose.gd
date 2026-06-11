extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_visibility_changed() -> void:
	set_text("You exploded and died a painful death!\nYour "+str(GLOBAL.coins)+" Coin(s) are all destroyed!")
