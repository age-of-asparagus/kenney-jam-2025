extends Node3D
@onready var button_host: Button = $HUD/MarginContainer/MultiplayerHUD/VBoxContainer/ButtonHost
@onready var button_join: Button = $HUD/MarginContainer/MultiplayerHUD/VBoxContainer/ButtonJoin

var peer = ENetMultiplayerPeer.new()
@export var player_scene : PackedScene

func _on_button_host_pressed() -> void:
	peer.create_server(1027)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(add_player)
	add_player()
	button_host.hide()


func _on_button_join_pressed() -> void:
	peer.create_client("127.0.0.1", 1027)
	multiplayer.multiplayer_peer = peer
	button_join.hide()

func add_player(id=1):
	var player = player_scene.instantiate()
	player.name=str(id)
	call_deferred("add_child", player)
	
func exit_game(id):
	multiplayer.peer_disconnected.connect(delete_player)
	delete_player(id)

func delete_player(id):
	rpc("_del_player", id)
	
@rpc("any_peer", "call_local")
func _del_player(id):
	get_node(str(id)).queue_free()
