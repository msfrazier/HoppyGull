extends Node3D

@export var casting = false

@onready var reeling_in = false

@onready var animation_player = $AnimationPlayer
@onready var soft_lure = $fisherman/soft_lure
@onready var bobber = $fisherman/bobber
@onready var above_head: Marker3D = $fisherman/above_head

@onready var t = 0.0
@onready var bobber_tween_time = 1
#@onready var soft_lure_pos = soft_lure.global_position
@onready var bobber_pos = bobber.global_position
var lure_tile: Vector3

signal cast_in
signal cast_out

func _process(delta: float) -> void:
	pass

func _ready():
	var parent_plank = get_parent_node_3d().get_parent_node_3d().get_parent_node_3d()
	cast_in.connect(parent_plank._on_cast_in.bind())
	pass
	
func _quadratic_bezier(t: float, p0: Vector3, p1: Vector3, p2: Vector3):
	var q0 = p0.lerp(p1, t)
	var q1 = p1.lerp(p2, t)
	var r = q0.lerp(q1, t)
	bobber.global_position = r
	#return r

func _on_cast_timer_timeout() -> void:
	if !casting:
		#Reeling in
		animation_player.play("cast")
		cast_in.emit()
		casting = true
	else:
		#Casting Out
		animation_player.play_backwards("cast")
		#cast_out.emit()
		casting = false
		reeling_in = false
		_cast_out()
	pass

func _on_lure_tile(lure_tile_pos: Vector3) -> void:
	lure_tile = lure_tile_pos
	var tween = get_tree().create_tween().set_parallel()
	tween.tween_method(
		_quadratic_bezier.bind(
			bobber_pos,
			above_head.global_position,
			lure_tile,
		), 0.0, 
		1.0, 
		bobber_tween_time
	)
	tween.tween_property(
		bobber,
		"rotation",
		Vector3(
			randf_range(-2*PI,2*PI),
			randf_range(-2*PI,2*PI),
			randf_range(-2*PI,2*PI)
		),
		bobber_tween_time
	)
	
	pass 

func _cast_out() -> void:
	var tween = get_tree().create_tween().set_parallel()
	tween.tween_method(
		_quadratic_bezier.bind(
			bobber.global_position,
			above_head.global_position,
			bobber_pos,
		), 0.0, 1.0, bobber_tween_time
	)
	tween.tween_property(
		bobber,
		"rotation",
		Vector3(
			randf_range(-2*PI,2*PI),
			randf_range(-2*PI,2*PI),
			randf_range(-2*PI,2*PI)
		),
		bobber_tween_time
	)
	pass
