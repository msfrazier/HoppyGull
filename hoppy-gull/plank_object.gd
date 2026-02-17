class_name plank
extends Node3D

@export var tile_arr := Array([],TYPE_INT,"",null)
@export var railing : bool
@onready var railing_1_scene = preload("res://railing_1.tscn")
@onready var railing_2_scene = preload("res://railing_2.tscn")
@onready var animation_player = $AnimationPlayer

signal check_char_fell

func _ready() -> void:
	build_plank(tile_arr)
	#print(get_tree().current_scene.get_node("gull"))
	check_char_fell.connect(get_tree().current_scene.get_node("dock_2").check_if_char_dead.bind())
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func set_tile_arr(new_tile_arr:Array):
	tile_arr = new_tile_arr

func build_plank(tile_arr):
	for tile in range(len(tile_arr)):
		if tile_arr[tile]==1:
			var rounded_plank_tile = load("res://rounded_plank_tile.tscn").instantiate()
			get_node("plank_object/tile_{0}".format([tile+1])).add_child(rounded_plank_tile)
	if railing:
		get_node("plank_object/end_tile").add_child(railing_1_scene.instantiate())
		get_node("plank_object/end_tile2").add_child(railing_1_scene.instantiate())
	else:
		get_node("plank_object/end_tile").add_child(railing_2_scene.instantiate())
		get_node("plank_object/end_tile2").add_child(railing_2_scene.instantiate())


func _on_plank_fall_timer_timeout() -> void:
	animation_player.stop()
	animation_player.play("fall")
	check_char_fell.emit(self)
	pass # Replace with function body.
