extends Control


var count = 1	# irgendein Wert welcher gezählt wurde
@onready var level1 = $Stump/Level1
@onready var level2 = $Stump2/Level2
@onready var level3 = $Stump3/Level3
@onready var level4 = $Stump4/Level4

var levels
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	levels = [level1, level2, level3, level4]
	for level in levels:
		level.disabled = true
	levels[count-1].disabled = false
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_number_pressed() -> void:
	pass
	


func _on_number2_pressed() -> void:
	pass # Replace with function body.
	

func _on_number3_pressed() -> void:
	pass # Replace with function body.


func _on_number4_pressed() -> void:
	pass # Replace with function body.
