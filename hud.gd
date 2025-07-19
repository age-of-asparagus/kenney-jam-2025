extends CanvasLayer

func _physics_process(delta):
	
	Global.cash += 10
	
	$MarginContainer/HBoxContainer/Cash.text = "$"+str(Global.cash)
