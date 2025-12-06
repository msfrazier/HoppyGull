extends TextureRect


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_main_kill_screen_trigger(screen_size: Vector2) -> void:
	var tween = create_tween()
	tween.tween_property(self,"position",Vector2(self.position.x, (screen_size.y/2)-(self.size.y/2)),0.25)
	tween.play()
	pass # Replace with function body.
