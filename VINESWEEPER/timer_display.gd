extends Control
@onready var options: Panel = $"../TileMapLayer/Camera2D/Options"


func _ready():
	pass


func _process(delta: float) -> void:
	if options.visible == false:
		GLOBAL.time_passed += delta
		if GLOBAL.time_passed >= 1:
			GLOBAL.time_passed = 0
			GLOBAL.time_seconds += 1
		if GLOBAL.time_seconds == 60:
			GLOBAL.time_seconds = 0
			GLOBAL.time_minutes += 1	
		$".".text = '%02d:%02d' % [GLOBAL.time_minutes, GLOBAL.time_seconds]
