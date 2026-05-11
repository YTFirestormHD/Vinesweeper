extends Control
@onready var options: Panel = $"../TileMapLayer/Camera2D/Options"

var total_time_in_secs : int = 0


func _ready():
	# start Timer at specific time:
	# (or use 'Autostart' property)
	$Timer.start()


func _on_timer_timeout():
	if options.visible == false:
		total_time_in_secs += 1
		var m = int(total_time_in_secs / 60.0)
		var s = total_time_in_secs - m * 60
		$".".text = '%02d:%02d' % [m, s]
