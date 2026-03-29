extends Node3D

@export var god_mode := false

@onready var gridMap := $GridMap
@onready var gull := $gull
@onready var kill_screen := $score_control/kill_screen
@onready var dock := $dock_2
@onready var screen_size: Vector2
@onready var state_machine: StateMachine

var config: ConfigFile

signal increase_score
signal create_plank()
signal kill_screen_trigger(screen_size: Vector2)
signal exit_screen_trigger
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	state_machine = $state_machine
	
	screen_size = get_viewport().get_visible_rect().size
	
	config = ConfigFile.new()
#
	#config.set_value('tiles','HOLE_TILE', 0)
	#config.set_value('tiles','EMPTY_TILE', 1)
	#config.set_value('tiles','FISHERMAN_TILE',2)
	#
	#config.save('res://config.cfg')
	
	var err = config.load("res://config.cfg")
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_gull_check_position(final_position: Vector3, is_forward: bool):
	var check_tile
	if !is_forward:
		check_tile = dock.current_plank[gull.current_position]
	elif is_forward:
		check_tile = dock.next_plank[gull.current_position]
	#print(check_tile)
	if check_tile == config.get_value('tiles','HOLE_TILE'):
		_trigger_kill_screen()
	elif check_tile == config.get_value('tiles','FISHERMAN_TILE'):
		print("blocked")
		pass
	elif is_forward:
		state_machine.set_state('forward')
		create_plank.emit()
		increase_score.emit()
	
	pass # Replace with function body.

func _on_plank_check_char_fell() -> void:
	print("Check char fell")
	pass

func _on_retry_button_button_down() -> void:
	get_tree().reload_current_scene()


func _on_quit_button_button_down() -> void:
	get_tree().quit()


func _trigger_kill_screen():
	if !god_mode:
		kill_screen_trigger.emit(screen_size)
		state_machine.set_state('kill')
