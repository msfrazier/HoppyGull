extends Node3D

@onready var gridMap := $GridMap
@onready var gull := $gull
@onready var kill_screen := $score_control/kill_screen
@onready var dock = Array(Array())
@onready var screen_size: Vector2

signal increase_score
signal exit_screen_trigger
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport().get_visible_rect().size
	
	var planks_arr = [Vector3(-1, 0, -1), Vector3(0, 0, -1), Vector3(-2, 0, -1),
	 Vector3(1, 0, -1), Vector3(-3, 0, -1), Vector3(2, 0, -1), 
	Vector3(-4, 0, -1)]
	
	var planks_arr_x = range(-4,3)
	var planks_arr_z = range(-3,15)

	for z in planks_arr_z:
		var plank = Array()
		for x in planks_arr_x:
			gridMap.set_cell_item(Vector3(x,0,z), 0)
			plank.push_back(Vector3(x,0,z))
		dock.push_back(plank)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_gull_create_plank() -> void:
	for tile in dock[0]:
		gridMap.set_cell_item(tile,-1)
	dock.pop_front()
	
	var new_plank = Array()
	for x in dock[-1]:
		var random_board = randf()
		var new_board = Vector3(x.x,x.y,x.z+1)
		if random_board<=0.85:
			gridMap.set_cell_item(new_board,0)
		else:
			gridMap.set_cell_item(new_board,1)
		new_plank.push_back(new_board)
	dock.push_back(new_plank)
	pass # Replace with function body.


func _on_gull_check_position(final_position: Vector3, is_forward: bool) -> void:
	var check_tile_val = gridMap.get_cell_item(gridMap.local_to_map(gridMap.to_local(final_position)))
	if check_tile_val == 0 and is_forward:
		increase_score.emit()
	if check_tile_val==1:
		var tween = create_tween()
		tween.tween_property(kill_screen,"position",Vector2(kill_screen.position.x, (screen_size.y/2)-(kill_screen.size.y/2)),0.25)
		tween.play()
	pass # Replace with function body.


func _on_retry_button_button_down() -> void:
	get_tree().reload_current_scene()


func _on_quit_button_button_down() -> void:
	get_tree().quit()
