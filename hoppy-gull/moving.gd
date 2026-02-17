extends Node

var fsm: StateMachine

signal plank_wobble_timer_stop

func enter():
	#print('moving')
	#plank_wobble_timer_stop.emit()
	pass

func exit(next_state):
	fsm.change_to(next_state)

func _unhandled_key_input(event):
	pass
