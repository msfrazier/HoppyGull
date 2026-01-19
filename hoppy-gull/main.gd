extends Node3D

@onready var gridMap := $GridMap
@onready var gull := $gull
@onready var kill_screen := $score_control/kill_screen
@onready var dock := $dock_2

@onready var screen_size: Vector2
@onready var state_machine: StateMachine


signal increase_score
signal create_plank()
signal kill_screen_trigger(screen_size: Vector2)
signal exit_screen_trigger
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	state_machine = $state_machine
	
	screen_size = get_viewport().get_visible_rect().size
	
	#var planks_arr = [Vector3(-1, 0, -1), Vector3(0, 0, -1), Vector3(-2, 0, -1),
	 #Vector3(1, 0, -1), Vector3(-3, 0, -1), Vector3(2, 0, -1), 
	#Vector3(-4, 0, -1)]
	#
	#var planks_arr_x = range(-4,3)
	#var planks_arr_z = range(-3,15)
#
	#for z in planks_arr_z:
		#var plank = Array()
		#for x in planks_arr_x:
			#gridMap.set_cell_item(Vector3(x,0,z), 0)
			#plank.push_back(Vector3(x,0,z))
		#dock.push_back(plank)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_gull_check_position(final_position: Vector3, is_forward: bool):
	var check_tile
	if !is_forward:
		check_tile = dock.current_plank[gull.current_position]
	elif is_forward:
		check_tile = dock.next_plank[gull.current_position]
	if check_tile==0:
		kill_screen_trigger.emit(screen_size)
		state_machine.set_state('kill')
	elif is_forward:
		create_plank.emit()
		increase_score.emit()
	
	pass # Replace with function body.


func _on_retry_button_button_down() -> void:
	get_tree().reload_current_scene()


func _on_quit_button_button_down() -> void:
	get_tree().quit()
