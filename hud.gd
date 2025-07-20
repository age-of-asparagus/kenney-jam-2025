extends CanvasLayer
@onready var structure_selector: ItemList = $MarginContainer/StructureSelector

var inventory: Array[Structure] = []

signal structure_selected

func _physics_process(delta):
	
	Global.cash += 10
	
	$MarginContainer/HBoxContainer/Cash.text = "$"+str(Global.cash)
	
	$MarginContainer/HBoxContainer2/Energy_Available.text = str(Global.total_energy-Global.energy_used)

func set_inventory(structures: Array[Structure]) -> void:
	inventory = structures
	for structure in structures:
		var text = structure.name + "\n" + "$" + str(structure.cost) + " " + str(structure.energyUse) + "MW"
		structure_selector.add_item(text, structure.icon)


func _on_structure_selector_item_selected(index: int) -> void:
	var structure = inventory[index]
	emit_signal("strucutre_selected", structure)
