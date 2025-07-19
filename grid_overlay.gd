extends Node3D

@export var cell_size := 1.0
@export var grid_size := Vector2i(10, 10)

func _ready():
	var mesh := ImmediateMesh.new()
	var material := StandardMaterial3D.new()
	material.albedo_color = Color(1, 1, 1, 0.5)
	material.flags_unshaded = true
	material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	material.flags_transparent = true

	mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
