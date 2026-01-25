extends Node

var fsm: StateMachine

func enter():
	print('moving')
	pass

func exit(next_state):
	fsm.change_to(next_state)


func _unhandled_key_input(event):
	pass
