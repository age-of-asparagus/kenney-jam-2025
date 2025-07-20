extends GridMap

@export var top_left := Vector2(-7, -6)
@export var dimensions := Vector2(15, 17)

var grid_mesh_instance: MeshInstance3D

var grid_start_x = 0
var grid_start_z = 0
var grid_width = 0
var grid_depth = 0

func _ready():
	grid_mesh_instance = MeshInstance3D.new()
	add_child(grid_mesh_instance)
	_create_grid_mesh()

func _create_grid_mesh():
	var used_cells = get_used_cells()

	# Default grid size if empty
	if used_cells.is_empty():
		_build_grid_mesh(top_left.x, top_left.y, dimensions.x, dimensions.y)
		return

	# Find bounds of used cells in X and Z
	var min_x = 99999
	var max_x = -99999
	var min_z = 99999
	var max_z = -99999

	for cell in used_cells:
		if cell.x < min_x:
			min_x = cell.x
		if cell.x > max_x:
			max_x = cell.x
		if cell.z < min_z:
			min_z = cell.z
		if cell.z > max_z:
			max_z = cell.z

	var width = max_x - min_x + 1
	var depth = max_z - min_z + 1

	_build_grid_mesh(min_x, min_z, width, depth)
	
	# Store bounds so we can use them later
	grid_start_x = min_x
	grid_start_z = min_z
	grid_width = width
	grid_depth = depth

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
	
func get_random_location() -> Vector3:
	var cell_size = self.cell_size.x
	var x = (randi() % grid_width + grid_start_x) * cell_size
	var z = (randi() % grid_depth + grid_start_z) * cell_size
	var y = 0.0  # or whatever Y level you want
	return Vector3(x, y, z)
