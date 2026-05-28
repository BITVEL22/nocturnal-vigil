extends Node2D

var map_node 

var build_mode= false
var build_valid = false
var build_tile
var build_location
var build_type 

var current_wave = 0
var enemies_in_wave = 0


func _ready():
	map_node = get_node("Map1") 	
	for i in get_tree().get_nodes_in_group("build_buttons"):
		i.pressed.connect(initiate_build_mode.bind(i.name))
	start_new_wave()
	
func _process(delta):
	if build_mode:
		update_tower_preview()
	
func _unhandled_input(event):
	if event.is_action_released("ui_cancel") and build_mode == true:
		cancel_build_mode()
	if event.is_action_released("ui_accept") and build_mode == true:
		verify_and_build()
		cancel_build_mode()
	
	# Wave Function
func start_new_wave():
	var wave_data = retrieve_wave_data()
	await(get_tree().create_timer(0,2)).timeout
	spawn_enemies(wave_data)
	
func retrieve_wave_data():
	var wave_data = [["Proton", 0.7], ["Proton", 0.1]]
	current_wave += 1
	enemies_in_wave = wave_data.size()
	return wave_data
		
func spawn_enemies(wave_data):
	for i in wave_data:
		var new_enemy = load("res://enemies/" + i[0] + ".tscn").instantiate()
		map_node.get_node("Path").add_child(new_enemy, true)
		await (get_tree().create_timer(i[1])).timeout
	
	
	
	# Building Functions
	
	
	
func initiate_build_mode(tower_type):
	if build_mode:
		cancel_build_mode()
	build_type = tower_type
	build_mode = true 
	get_node("UI").set_tower_preview(build_type, get_global_mouse_position())

func update_tower_preview():
	var mouse_position = get_global_mouse_position()
	var current_tile = map_node.get_node("TowerExclusion").local_to_map(mouse_position)
	var title_position = map_node.get_node("TowerExclusion").map_to_local(current_tile)
	
	if map_node.get_node("TowerExclusion").get_cell_source_id(current_tile) != -1:
		get_node("UI").update_tower_preview(title_position, "ff0000ff")
		build_valid = false 
		
	else:
		get_node("UI").update_tower_preview(title_position, "00ff00ff")
		build_valid = true
		build_location = title_position
		build_tile = current_tile

func cancel_build_mode():
	build_mode = false 
	build_valid = false 
	get_node("UI/TowerPreview").free()
	
func verify_and_build():
	if build_valid:
		var new_tower = load("res://towers/" + build_type + ".tscn").instantiate()
		new_tower.position = build_location
		new_tower.build = true
		
		# TAMBAHKAN BARIS INI: Kirim tipe tower ke script Turrets.gd
		new_tower.type = build_type 
		
		map_node.get_node("Towers").add_child(new_tower, true)
		map_node.get_node("TowerExclusion").set_cell(build_tile, 7, Vector2(2, 0))
