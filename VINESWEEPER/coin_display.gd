extends Control
@onready var options: Panel = $"../TileMapLayer/Camera2D/Options"
var coins = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_text()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func add_coin():
	coins += 1		# Generating coins after win
	update_text()

func update_text():
	$".".text = "Münzen: " + str(coins)
