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

	var st = SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_LINES)

	# Calculate start and end positions shifted to cell corners
	var start_pos_x = start_x * cell_size - half_cell
	var start_pos_z = start_z * cell_size - half_cell
	var end_x = (start_x + width) * cell_size - half_cell
	var end_z = (start_z + depth) * cell_size - half_cell

	# Draw lines parallel to X axis (varying Z)
	for z_i in range(start_z, start_z + depth + 1):
		var z = z_i * cell_size - half_cell
		st.add_vertex(Vector3(start_pos_x, y_height, z))
		st.add_vertex(Vector3(end_x, y_height, z))

	# Draw lines parallel to Z axis (varying X)
	for x_i in range(start_x, start_x + width + 1):
		var x = x_i * cell_size - half_cell
		st.add_vertex(Vector3(x, y_height, start_pos_z))
		st.add_vertex(Vector3(x, y_height, end_z))

	var mesh = st.commit()
	grid_mesh_instance.mesh = mesh
	
func get_random_location(enemy := false) -> Vector3:
	var cell_size = self.cell_size.x

	# X range is always full width
	var x = (randi() % grid_width + grid_start_x) * cell_size

	# Split the grid in half along Z
	var half_depth = grid_depth / 2

	var z_offset = grid_start_z
	if enemy:
		z_offset += half_depth

	var z = (randi() % half_depth + z_offset) * cell_size

	var y = 0.0
	return Vector3(x, y, z)
