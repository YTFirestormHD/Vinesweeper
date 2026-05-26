extends Control
@onready var cam: Camera2D = $Camera2D
@onready var map: TextureRect = $Map


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _input(event: InputEvent) -> void:
	if event.is_action("up") and not event.is_action_released("up"):
		if cam.global_position.y > map.position.y:
			cam.global_position.y -= 20
		#print(cam.global_position)
	if event.is_action("down") and not event.is_action_released("down"):
		if cam.global_position.y + get_viewport_rect().size.y + 2 <= map.size.y-10:
			cam.global_position.y += 20
			
