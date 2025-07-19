extends Node3D

@onready var placement_marker = $"Placement/Sprite3D-Place"
@onready var target_marker = $"Placement/Sprite3D-Target"
@onready var placement = $Placement
@onready var preview_container = $Placement/StructureContainer
@export var structures: Array[Structure] = []
var index:int = 0 # Index of structure being built within the structures Array

@export var instance_container : Node3D
@export var camera:Camera3D # Used for raycasting mouse
@export var gridmap:GridMap
#@export var cash_display:Label

var plane:Plane # Used for raycasting mouse

# Use for second click to set rotation
var placement_position := Vector3.ZERO
var structure_position := Vector3.ZERO
var preview_instance

var targetting := false
var is_out_of_bounds := false

func _ready():

	plane = Plane(Vector3.UP, Vector3.ZERO)
	# Create new MeshLibrary dynamically, can also be done in the editor
	# See: https://docs.godotengine.org/en/stable/tutorials/3d/using_gridmaps.html
	
	#var mesh_library = MeshLibrary.new()
	#
	##for structure in structures:
		##
		##var id = mesh_library.get_last_unused_item_id()
		##
		##mesh_library.create_item(id)
		##mesh_library.set_item_mesh(id, get_mesh(structure.model))
		##mesh_library.set_item_mesh_transform(id, Transform3D())
		#
	#gridmap.mesh_library = mesh_library
	#
	update_preview_structure()
	
func _process(delta):
	
	update_preview_structure()
	
	# Map position based on mouse
	var world_position = plane.intersects_ray(
		camera.project_ray_origin(get_viewport().get_mouse_position()),
		camera.project_ray_normal(get_viewport().get_mouse_position()))

	var gridmap_position = Vector3(round(world_position.x), 0, round(world_position.z))
	placement.position = lerp(placement.position, gridmap_position, delta * 40)
	
	is_out_of_bounds = out_of_bounds(gridmap_position)
	if is_out_of_bounds:
		# don't process anything else below, quit process function for this frame
		return
		
	# If we are currently setting the rotation of a placement
	if targetting:
		# Live update rotation to face current mouse grid pos
		var target_rotation = get_rotation_to_target(gridmap_position, structure_position)
		preview_instance.rotation = target_rotation
	
	var structure : Structure = structures[index]
	
	if Input.is_action_just_pressed("place"):
		
		if not targetting:
			
			# if this structure needs to target, then we need to place a preview first
			if structure.target_placement:

				# We need to click a second time to set a target
				targetting = true
				# Store the placement position so we can instantiate the structure there
				# and calculate the target angle
				structure_position = gridmap_position
				
			# else the strucutre does NOT need to target and we can place it right away
			else:
				place_structure(structure, gridmap_position, Vector3.ZERO)
					
						
		else:
			# Second click: rotate unit to face this second clicked grid cell
			var target_rotation = get_rotation_to_target(gridmap_position, structure_position)
			place_structure(structure, structure_position, target_rotation)
			
			# done targetting, go back to normal placement
			targetting = false


func place_structure(structure: Structure, gridmap_position: Vector3, rotation: Vector3):
		var structure_instance = structure.scene.instantiate()
		Global.cash -= structure.cost
		Global.energy_used += structure.energyUse
		structure_instance.global_position = gridmap.map_to_local(gridmap_position)
		structure_instance.rotation = rotation
		structure_instance.on = true
		structure_instance.start()
		instance_container.add_child(structure_instance)
		
		gridmap.set_cell_item(
			gridmap_position, 
			index, 
			gridmap.get_orthogonal_index_from_basis(placement.basis)
		)
			
func out_of_bounds(gridmap_position: Vector3):
	var x = gridmap_position.x
	var y = gridmap_position.z
	if x < gridmap.top_left.x:
		return true
	if x >= gridmap.top_left.x + gridmap.dimensions.x:
		return true
	if y < gridmap.top_left.y:
		return true
	if y >= gridmap.top_left.y + gridmap.dimensions.y:
		return true
	else:
		return false

func get_rotation_to_target(target, source):
	var dir = (target - source).normalized()
	if dir.length() > 0:
		var dir_2d = Vector2(dir.x, dir.z)
		var angle = Vector2(0, 1).angle_to(dir_2d)
		return Vector3(0, -angle, 0)
	else:
		return Vector3.ZERO
	

## Retrieve the mesh from a PackedScene, used for dynamically creating a MeshLibrary
#func get_mesh(packed_scene):
	#var scene_state:SceneState = packed_scene.get_state()
	#for i in range(scene_state.get_node_count()):
		#if(scene_state.get_node_type(i) == "MeshInstance3D"):
			#for j in scene_state.get_node_property_count(i):
				#var property_name = scene_state.get_node_property_name(i, j)
				#if property_name == "mesh":
					#var property_value = scene_state.get_node_property_value(i, j)
					#
					#return property_value.duplicate()

# Update the structure visual in the placement marker
func update_preview_structure():
	
	if is_out_of_bounds:
		placement_marker.visible = false
		target_marker.visible = false
	else:
		placement_marker.visible = not targetting
		target_marker.visible = targetting
	
	# Clear previous structure preview in placement marker
	for n in preview_container.get_children():
		preview_container.remove_child(n)
	if preview_instance:
		preview_instance.queue_free()
		
	# Create new structure preview in placement marker (or at clicked location if still targetting)
	if targetting or not is_out_of_bounds:
		var _model = structures[index].scene.instantiate()
		set_transparency(_model, 0.5)
		# place the preview structure in the initial placement position
		if targetting:
			_model.global_position = gridmap.map_to_local(structure_position)
			instance_container.add_child(_model)
			# so we can delete it after
			preview_instance = _model
		elif not is_out_of_bounds:
			_model.position.y += 0.25  # place it above the marker
			preview_container.add_child(_model)
			
		

	
# recursively traverses all children of a Node and modifies the 
# transparency of any MeshInstance3D (or similar) it finds:
func set_transparency(node: Node, alpha: float) -> void:
	if node is MeshInstance3D:
		var mesh = node.mesh
		if mesh:
			for surface_index in mesh.get_surface_count():
				var mat = node.get_active_material(surface_index)
				if mat == null:
					continue
				var new_mat = mat.duplicate()
				node.set_surface_override_material(surface_index, new_mat)

				new_mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
				new_mat.albedo_color.a = alpha
				new_mat.flags_transparent = true
				new_mat.depth_draw_mode = BaseMaterial3D.DEPTH_DRAW_ALWAYS
				new_mat.alpha_scissor_threshold = 0.0
				new_mat.cull_mode = BaseMaterial3D.CULL_BACK
				new_mat.emission_enabled = false
				new_mat.shading_mode = BaseMaterial3D.SHADING_MODE_PER_PIXEL

	# Recurse into all children
	for child in node.get_children():
		set_transparency(child, alpha)
