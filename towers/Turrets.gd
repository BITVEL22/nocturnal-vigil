extends Node2D

var enemy_array = []
var build = false

func _ready() -> void:
	if build:
		self.get_node("Range/CollisionShape2D").get_shape().radius = 0.5 * GameData.tower_data[self.get_name()]["range"]

func _physics_process(delta: float) -> void:
	turn()
	
func turn():
	var enemy_position = get_global_mouse_position()
	get_node("Muzzle").look_at(enemy_position)


func _on_range_body_entered(body: Node2D) -> void:
	enemy_array.append(body.get_parent())
	print(enemy_array)

func _on_range_body_exited(body: Node2D) -> void:
	enemy_array.erase(body.get_parent())
