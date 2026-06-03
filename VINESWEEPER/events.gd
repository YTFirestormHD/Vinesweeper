extends Control

@onready var statincrease: Label = $TextBox/Event_StatIncrease
@onready var coins: Label = $TextBox/Event_Coins
@onready var first_aid: Label = $TextBox/Event_FirstAid
@onready var discount: Label = $TextBox/Event_Discount

var events = []

func _ready() -> void:
	randomize()
	events = [statincrease, coins, first_aid, discount]

	for event in events:
		event.visible = false

	var zufaelliges_event = events[randi() % events.size()]
	zufaelliges_event.visible = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
