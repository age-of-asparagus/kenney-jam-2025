extends CanvasLayer
@onready var structure_selector: ItemList = $MarginContainer/StructureSelector

func _physics_process(delta):
	
	Global.cash += 10
	
	$MarginContainer/HBoxContainer/Cash.text = "$"+str(Global.cash)
	
	$MarginContainer/HBoxContainer2/Energy_Available.text = str(Global.total_energy-Global.energy_used)

func set_inventory(structures:Array[Structure]) -> void:
	for structure in structures:
		var text = structure.name + "\n" + "$" + str(structure.cost) + " " + str(structure.energyUse) + "MW"
		structure_selector.add_item(text, structure.icon)
