extends Control

@onready var slot_1: TextureButton = $TextureRect3/slot_1
@onready var slot_2: TextureButton = $TextureRect3/slot_2
@onready var slot_3: TextureButton = $TextureRect3/slot_3
@onready var slot_4: TextureButton = $TextureRect3/slot_4

var slots
var item_available = {}
var check = preload("res://assets/items/check.png")
var empty = preload("res://assets/items/other_item.png")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	slots = [slot_1,slot_2,slot_3,slot_4]
	while item_available.is_empty():
		for i in slots:
			if randf() < 0.25:
				item_available.set(i,"add_check")
				print(i)
				i.texture_normal = check
				
			else:
				i.texture_normal = empty
			


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func add_check(slot):
	print(slot)
	if GLOBAL.coins >= 5:
		GLOBAL.coins -= 5
		GLOBAL.items["check"] += 1
		item_available.erase(slot)
		slot.texture_normal = empty

func _on_slot_1_pressed() -> void:
	#print(item_available)
	if item_available.has(slot_1):
		#print(slot_1)
		Callable(self,item_available[slot_1]).call(slot_1)


func _on_slot_2_pressed() -> void:
	if item_available.has(slot_2):
		Callable(self,item_available[slot_2]).call(slot_2)


func _on_slot_3_pressed() -> void:
	if item_available.has(slot_3):
		Callable(self,item_available[slot_3]).call(slot_3)


func _on_slot_4_pressed() -> void:
	if item_available.has(slot_4):
		Callable(self,item_available[slot_4]).call(slot_4)


func _on_return_pressed() -> void:
	GLOBAL.current_level += 1
	get_tree().change_scene_to_file("res://scenes/leveltree.tscn")
