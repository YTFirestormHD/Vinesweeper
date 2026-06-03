extends Control

@onready var statincrease: Label = $TextBox/Event_StatIncrease
@onready var coins: Label = $TextBox/Event_Coins
@onready var first_aid: Label = $TextBox/Event_FirstAid
@onready var discount: Label = $TextBox/Event_Discount
@onready var optionen: Label = $Optionen
@onready var option1: Button = $Option1
@onready var option2: Button = $Option2

var events = []
var current_event = null
var use_choice_event = false

func _ready() -> void:
	randomize()
	events = [statincrease, coins, first_aid, discount]

	use_choice_event = randf() < 0.3

	if use_choice_event:
		show_choice_event()
	else:
		show_normal_event()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
	
func show_normal_event():
	current_event = events[randi() % events.size()]

	for event in events:
		event.visible = false

	current_event.visible = true

	$TextBox.visible = true
	optionen.visible = false
	option1.visible = false
	option2.visible = false
	
func show_choice_event():
	for event in events:
		event.visible = false
	$TextBox.visible = false
	
	optionen.visible = true
	option1.visible = true
	option2.visible = true
