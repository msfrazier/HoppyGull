class_name plank
extends Node3D

var config = ConfigFile.new()
var config_tiles

@export var tile_arr := Array([],TYPE_INT,"",null)
@export var railing : bool
@onready var railing_1_scene = preload("res://scenes/railing_1.tscn")
@onready var railing_2_scene = preload("res://scenes/railing_2.tscn")
@onready var animation_player = $AnimationPlayer
@onready var rounded_plank_tile_scene = load("res://scenes/plank_tile.tscn")
#@export var fisherman_scene = load("res://scenes/fisherman.tscn")
@onready var feather_scene = load("res://scenes/feather_2.tscn")
@onready var plank_object = $plank_object
@onready var plank_object_col = $plank_object/plank_object_col

signal check_char_fell
signal lure_tile_signal

func _ready() -> void:
	config_tiles = config.load("res://config.cfg")
	build_plank(tile_arr)
	check_char_fell.connect(get_tree().current_scene.get_node("dock_2").check_if_char_dead.bind())
	
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func set_tile_arr(new_tile_arr:Array):
	tile_arr = new_tile_arr

func build_plank(tile_arr):
	for tile in range(len(tile_arr)):
		if tile_arr[tile]!=0:
			var rounded_plank_tile = rounded_plank_tile_scene.instantiate()
			rounded_plank_tile.set_freeze_enabled(true)
			get_node("plank_object/tile_{0}".format([tile+1])).add_child(rounded_plank_tile)
		#if tile_arr[tile]==2:
			#var fisherman = fisherman_scene.instantiate()
			#if tile==0:
				#fisherman.rotate_y(PI)
			#get_node("plank_object/tile_{0}".format([tile+1])).add_child(fisherman)
			#lure_tile_signal.connect(fisherman._on_lure_tile.bind())
		#if tile_arr[tile]==3:
			#var feather = feather_scene.instantiate()
			#get_node("plank_object/tile_{0}".format([tile+1])).add_child(feather)
	if railing:
		get_node("end_tile").add_child(railing_1_scene.instantiate())
		get_node("end_tile2").add_child(railing_1_scene.instantiate())
	else:
		get_node("end_tile").add_child(railing_2_scene.instantiate())
		get_node("end_tile2").add_child(railing_2_scene.instantiate())

func _on_plank_fall_timer_timeout() -> void:
	animation_player.stop()
	#animation_player.play("fall")
	plank_object_col.disabled = true
	for tile in plank_object.get_children():
		if tile.get_node("plank") != null:
			tile.get_node("plank").freeze = false
	
	check_char_fell.emit(self)
	pass # Replace with function body.
	
func _get_tile_arr_indx() -> Array:
	var arr = []
	var i = 0
	for elem in tile_arr:
		if elem == 1:
			arr.append(i)
		i += 1
	return arr
	pass

func _on_cast_in() -> void:
	var viable_tile_arr = _get_tile_arr_indx()
	
	if $plank_object/tile_1.has_node("fisherman"):
		viable_tile_arr.erase(0)
	else:
		viable_tile_arr.erase(6)
	#var index_of_lure_tile:int = randi_range(1,len(tile_arr.filter(func(x): return x==config.get_value('tiles','EMPTY_TILE'))))
	var search_index:int = viable_tile_arr.pick_random()+1
	var lure_tile = get_node("plank_object/tile_{0}".format([search_index]))
	var lure_pos = Vector3(
		lure_tile.get_global_position().x,
		lure_tile.get_global_position().y+0.1,
		lure_tile.get_global_position().z
	)
	lure_tile_signal.emit(lure_pos)
	pass
	
func add_fisherman(tile: int, fisherman_scene):
	var fisherman = fisherman_scene.instantiate()
	if tile == 0:
		fisherman.rotate_y(PI)
		get_node("plank_object/tile_1").add_child(fisherman)
	else:
		get_node("plank_object/tile_7").add_child(fisherman)
	lure_tile_signal.connect(fisherman._on_lure_tile.bind())
	
func add_bench(tile: int, bench_scene):
	var bench = bench_scene.instantiate()
	if tile == 0:
		get_node("plank_object/tile_1").add_child(bench)
	else:
		bench.get_child(0).rotation_degrees.y = -90
		get_node("plank_object/tile_6").add_child(bench)
	pass
