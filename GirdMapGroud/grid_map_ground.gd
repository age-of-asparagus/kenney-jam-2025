extends GridMap
@onready var grid_map: GridMap = $"../GridMap"

#func _ready():
	#randomize()
	#
	#var start_x = grid_map.grid_start_x
	#var start_z = grid_map.grid_start_z
	#var width = grid_map.grid_width
	#var depth = grid_map.grid_depth
	#var height = 1  # Optional: number of vertical layers (Y)
	#
	## Get mesh IDs from the mesh library
	#var mesh_ids = []
	#for id in mesh_library.get_item_list():
		#mesh_ids.append(id)
#
	## Fill the defined grid area
	#for x in range(start_x, start_x + width):
		#for z in range(start_z, start_z + depth):
			#for y in range(height):  # Optional vertical layers
				#var cell = Vector3i(x, y, z)
				#var mesh_id = mesh_ids[randi() % mesh_ids.size()]
				#set_cell_item(cell, mesh_id)
