extends Control

@onready var title: Label = $VBoxContainer/MarginContainer/Title
@onready var event_discount: Label = $VBoxContainer/HBoxContainer/TextBox/MarginContainer/Event_Discount
@onready var event_first_aid: Label = $VBoxContainer/HBoxContainer/TextBox/MarginContainer/Event_FirstAid
@onready var event_coins: Label = $VBoxContainer/HBoxContainer/TextBox/MarginContainer/Event_Coins
@onready var event_stat_increase: Label = $VBoxContainer/HBoxContainer/TextBox/MarginContainer/Event_StatIncrease
@onready var options: Label = $VBoxContainer/HBoxContainer/TextBox/MarginContainer/Options
@onready var textbox: TextureRect = $VBoxContainer/HBoxContainer/TextBox
@onready var possible_options: VBoxContainer = $VBoxContainer/HBoxContainer/possible_options
@onready var return_button: Button = $return
@onready var event: Label = $VBoxContainer/HBoxContainer/TextBox/MarginContainer/Event



var current_event
var events = []
var c_events = []
var event_name
var event_action
var event_values
#var possible_actions = ["heal","heal_p","damage","damage_p","lose_coins","lose_coins_p","gain_coins","gain_coins_p","gain_special","lose_special","gain_item"]

func _ready() -> void:
	load_events_from_file("res://event_texts/all_events.txt")
	var n = randf()
	if n < 0.001:
		title.text = "Franz has cursed your journey"
	elif n < 0.01:
		title.text = "Moritz has blessed your run"
	elif n < 0.05:
		title.text = "Matias Easter egg!"
	
	if randf() <= 0:#for now only 1 choice event is possible
		show_choice_event()
	else:
		show_normal_event()
# Called every frame. 'delta' is the elapsed time since the previous frame.


func _process(delta: float) -> void:
	pass


func load_events_from_file(file):
	var f = FileAccess.open(file,FileAccess.READ)
	var x = 0
	var y = 0
	var loop
	while not f.eof_reached():
		var line = f.get_line()
		#print(line)
		if line == "event:":
			loop = true
			events.append("")
			while not f.eof_reached() and loop == true:
				line = f.get_line()
				line = line.replace('\t','')
				#print(line)
				if line.contains('#'):
					pass
				elif line == "_end_":
					loop = false
				else:
					events[x] += line
					events[x] += "\n"
					#print(events)
			x += 1
		if line == "c_event:":
			loop = true
			c_events.append("")
			while not f.eof_reached() and loop == true:
				line = f.get_line()
				line = line.replace('\t','')
				#print(line)
				if line.contains('#'):
					pass
				elif line == "_end_":
					loop = false
				else:
					c_events[y] += line
					c_events[y] += "\n"
					#print(c_events)
			y += 1
	f.close()
	return


func show_normal_event():
	current_event = events.pick_random()
	print([current_event])
	event_name = current_event.get_slice("\n",0)
	#print(event_name)
	event_action = current_event.get_slice("\n",1)
	#print(event_action)
	event_values = current_event.get_slice("\n",2)
	#print(event_values)
	var x = event_action.count(";")+1
	#print(x)
	var y = current_event.count("\n")-3
	#print(y)
	for i in range(x):
		var callable = Callable(self,event_action.get_slice(";",i))
		callable.call(event_values.get_slice(";",i))
	var text: String
	for i in range(y):
		print(i)
		text += current_event.get_slice("\n",3+i)+"\n"
		print(text)
	event.text = text
	event.visible = true
	return_button.visible = true
	#current_event.visible = true


func show_choice_event():
	current_event = c_events.pick_random()
	possible_options.visible = true
	options.visible = true


func event_finished():
	return_button.visible = true


func _on_return_pressed() -> void:
	GLOBAL.current_level += 1
	get_tree().change_scene_to_file("res://scenes/leveltree.tscn")


func heal():
	pass

func heal_p():
	pass

func damage():
	pass

func damage_p():
	pass

func lose_coins():
	pass

func lose_coins_p():
	pass

func gain_coins():
	pass

func gain_coins_p():
	pass

func gain_special():
	pass

func lose_special():
	pass

func gain_item(item):
	GLOBAL.items[item.get_slice("+",1)] += int(item.get_slice("+",0))
	#print()
	#print(item.get_slice("+",1))
	return
