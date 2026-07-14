extends Node3D

@export var god_mode := false

@onready var gridMap := $GridMap
@onready var gull := $gull
@onready var kill_screen := $score_control/kill_screen
@onready var dock := $dock_2
@onready var screen_size: Vector2
@onready var state_machine: StateMachine

var config: ConfigFile
var curr_camera: Camera3D
var curr_camera_pos: Vector3

signal increase_score
signal create_plank()
signal kill_screen_trigger(screen_size: Vector2)
signal exit_screen_trigger
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	state_machine = $state_machine
	
	screen_size = get_viewport().get_visible_rect().size
	
	config = ConfigFile.new()
	
	curr_camera = get_viewport().get_camera_3d()
	curr_camera_pos = curr_camera.get_position()
#
	#config.set_value('tiles','HOLE_TILE', 0)
	#config.set_value('tiles','EMPTY_TILE', 1)
	#config.set_value('tiles','FISHERMAN_TILE',2)
	#
	#config.save('res://config.cfg')
	
	var err = config.load("res://config.cfg")
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
	pass
	
func fly_score_create_plank():
	create_plank.emit()
	increase_score.emit()

func _on_gull_check_position(final_position: Vector3, movement_state: int):
	var check_tile
	
	if movement_state==0:
		#check_tile = dock.current_plank[gull.current_position]
		check_tile = dock.plank_arr[6].tile_arr[gull.current_position]
	elif movement_state==1:
		#print(dock.current_plank)
		#print(dock.plank_arr[6].tile_arr)
		#check_tile = dock.next_plank[gull.current_position]
		check_tile = dock.plank_arr[7].tile_arr[gull.current_position]
	elif movement_state==2:
		check_tile = dock.plank_arr[6+gull.fly_dist].tile_arr[gull.current_position]
		pass
	#print(check_tile)
	if check_tile == config.get_value('tiles','HOLE_TILE'):
		_trigger_fall_death()
	elif check_tile == config.get_value('tiles','FISHERMAN_TILE'):
		print("blocked")
		pass
	elif movement_state==1:
		create_plank.emit()
		increase_score.emit()
		state_machine.set_state('forward')
	elif movement_state==2:
		var tween = get_tree().create_tween().set_loops(gull.fly_dist)
		tween.tween_callback(
			fly_score_create_plank
		).set_delay(gull.SPEED/gull.fly_dist)
		state_machine.set_state("forward")
	
	pass # Replace with function body.

func _on_plank_check_char_fell() -> void:
	print("Check char fell")
	pass

func _on_retry_button_button_down() -> void:
	get_tree().reload_current_scene()


func _on_quit_button_button_down() -> void:
	get_tree().quit()

##Kill screen that occurs when 
func _trigger_kill_screen():
	if !god_mode:
		kill_screen_trigger.emit(screen_size)
		state_machine.set_state('kill')
		
func _trigger_fall_death():
	if !god_mode:
		kill_screen_trigger.emit(screen_size)
		state_machine.set_state('kill')


func _on_v_scroll_bar_value_changed(value: float) -> void:
	var project_ray_normal = curr_camera.project_ray_normal(Vector2(screen_size.x/2,screen_size.y/2))
	curr_camera.position = (project_ray_normal*-value)+curr_camera_pos
	pass # Replace with function body.
