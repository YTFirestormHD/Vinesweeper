extends Control
@onready var event_1: TextureRect = $event_1
@onready var event_2: TextureRect = $event_2

var events = [event_1,event_2]
var current_event

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_event = events.pick_random()
	current_event.visible = true
	for i in events:
		if i == event_1:
			pass
		if i == event_2:
			pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
