extends Node

var fsm: StateMachine

func enter():
	print("Moving")


func exit(next_state):
	fsm.change_to(next_state)


func _unhandled_key_input(event):
	print("From Moving")
	pass
