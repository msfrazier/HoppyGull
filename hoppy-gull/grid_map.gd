extends GridMap

@onready var dock = Array(Array())

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var planks_arr = [Vector3(-1, 0, -1), Vector3(0, 0, -1), Vector3(-2, 0, -1),
	 Vector3(1, 0, -1), Vector3(-3, 0, -1), Vector3(2, 0, -1), 
	Vector3(-4, 0, -1)]
	
	var planks_arr_x = range(-4,3)
	var planks_arr_z = range(-3,15)

	for z in planks_arr_z:
		var plank = Array()
		for x in planks_arr_x:
			self.set_cell_item(Vector3(x,0,z), self.mesh_library.find_item_by_name("rounded_plank"))
			plank.push_back(Vector3(x,0,z))
		dock.push_back(plank)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_main_create_plank() -> void:
	
	for plank in dock:
		for tile in plank:
			print(tile)
			#if tile.z == -3:
				#self.set_cell_item(tile,-1)
			#else:
				##print(self.get_cell_item(Vector3(tile.x,tile.y,tile.z+1)))
			self.set_cell_item(tile,self.get_cell_item(Vector3(tile.x,0,tile.z+1)))
				
	dock.pop_back()	
				
	var new_plank = Array()
	for tile in dock[-1]:
		var random_board = randf()
		var new_board = Vector3(tile.x,tile.y,tile.z+1)
		if random_board<=0.85:
			self.set_cell_item(new_board,self.mesh_library.find_item_by_name("rounded_plank"))
		else:
			if new_board.x == -4.0 or new_board.x == 2.0:
				self.set_cell_item(new_board, self.mesh_library.find_item_by_name("fisherman_plank"))
			else:
				self.set_cell_item(new_board,self.mesh_library.find_item_by_name("empty_plank"))
		new_plank.push_back(new_board)
	dock.push_back(new_plank)
			
	
	
	
	#for tile in self.get_used_cells():
		#print(tile.z)
		#tile.z = tile.z - 1
	
	
	

	pass # Replace with function body.
