extends GridMap

var grid_mesh_instance: MeshInstance3D

@export var grid_start_x = 0
@export var grid_start_z = 0
@export var grid_width = 0
@export var grid_depth = 0

func _ready():
	grid_mesh_instance = MeshInstance3D.new()
	add_child(grid_mesh_instance)
	_create_grid_mesh()

func _create_grid_mesh():
	_build_grid_mesh(grid_start_x, grid_start_z, grid_width, grid_depth)

func _build_grid_mesh(start_x: int, start_z: int, width: int, depth: int) -> void:
	var cell_size = self.cell_size.x
	var half_cell = cell_size * 0.5
	var y_height = 0.01  # Slightly above ground

	var line_color = Color(0.15, 0.35, 0.15)  # Example color: orange

	var st = SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_LINES)
	st.set_color(line_color) 

	# Calculate start and end positions shifted to cell corners
	var start_pos_x = start_x * cell_size - half_cell
	var start_pos_z = start_z * cell_size - half_cell
	var end_x = (start_x + width) * cell_size - half_cell
	var end_z = (start_z + depth) * cell_size - half_cell

	# Draw lines parallel to X axis (varying Z)
	for z_i in range(start_z, start_z + depth + 1):
		var z = z_i * cell_size - half_cell
		st.set_color(line_color)
		st.add_vertex(Vector3(start_pos_x, y_height, z))
		st.set_color(line_color)
		st.add_vertex(Vector3(end_x, y_height, z))

	# Draw lines parallel to Z axis (varying X)
	for x_i in range(start_x, start_x + width + 1):
		var x = x_i * cell_size - half_cell
		st.set_color(line_color)
		st.add_vertex(Vector3(x, y_height, start_pos_z))
		st.set_color(line_color)
		st.add_vertex(Vector3(x, y_height, end_z))

	var mesh = st.commit()
	var mat := StandardMaterial3D.new()
	mat.vertex_color_use_as_albedo = true

	grid_mesh_instance.material_override = mat
	
	grid_mesh_instance.mesh = mesh
	
func mark_cell_occupied(world_position: Vector3):
	var cell_coords = local_to_map(world_position)
	set_cell_item(cell_coords, 1)  # Mark cell as occupied
	
func get_random_location(enemy := false, avoid_occupied := false) -> Vector3:
	var cell_size = self.cell_size.x
	var half_depth = grid_depth / 2
	var max_attempts = 100  # Prevent infinite loops

	for i in max_attempts:
		# Pick a random X
		var cell_x = randi() % grid_width + grid_start_x

		# Pick a random Z based on side
		var z_offset = grid_start_z
		if enemy:
			z_offset += half_depth
		var cell_z = randi() % half_depth + z_offset

		# If avoiding occupied cells, check GridMap
		if avoid_occupied:
			var cell_coords = Vector3i(cell_x, 0, cell_z)
			if get_cell_item(cell_coords) != -1:
				continue  # Try another cell

		# Return the center of the cell in world coordinates
		var world_x = cell_x * cell_size
		var world_z = cell_z * cell_size
		var world_y = 0.0
		return Vector3(world_x, world_y, world_z)

	# If no valid location was found
	push_warning("Failed to find a free grid cell after many attempts.")
	return Vector3.ZERO
