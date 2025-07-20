extends CanvasLayer
@onready var structure_selector: ItemList = $MarginContainer/StructureSelector

@export var structures: Array[Structure] = []

signal structure_selected

func _ready():
	set_inventory()

func _physics_process(delta):
	Global.cash += 5
	$MarginContainer/HBoxContainer/Cash.text = "$"+str(Global.cash)
	$MarginContainer/HBoxContainer2/Energy_Available.text = str(Global.total_energy-Global.energy_used)
	
	update_inventory(Global.cash)
	
func update_inventory(cash : int):
	for i in structure_selector.item_count:
		# the Array structures should match the selector structures, 
		# since the selector structure were generated based off the Array
		var structure = structures[i]
		var set_disabled = false
		
		if structure.cost > cash:
			set_disabled = true
			
		# re-enable this we can afford, disable the rest
		structure_selector.set_item_disabled(i, set_disabled)
	
func set_inventory():
	for structure in structures:
		var text = structure.name + "\n" + "$" + str(structure.cost) + " " + str(structure.energyUse) + "MW"
		structure_selector.add_item(text, structure.icon)

func deselect_structure():
	structure_selector.deselect_all()

func _on_structure_selector_item_selected(index: int) -> void:
	var structure = structures[index]
	emit_signal("structure_selected", structure)
