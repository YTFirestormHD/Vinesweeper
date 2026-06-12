extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if GLOBAL.coins >= 100:
		GLOBAL.coins *= 0.05
		self.text = "HOWEVER, the government took 95% of them so in the end, you are only left with "+str(int(GLOBAL.coins))+" coins\n"  


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
