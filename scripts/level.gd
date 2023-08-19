extends Node

# for coins
onready var player: KinematicBody = $player_body
onready var spawn_timer: Timer = $spawn_timer
onready var spawn_env_timer: Timer = $spawn_env_timer
onready var spawn_obstacle_timer: Timer = $spawn_obstacle_timer

onready var coin: PackedScene = preload("res://scenes/coin.tscn")

onready var tree1: PackedScene = preload("res://models/cartoon-assets/tree1.tscn")
onready var tree2: PackedScene = preload("res://models/cartoon-assets/tree2.tscn")

onready var fence: PackedScene = preload("res://models/cartoon-assets/fence.tscn")
onready var rock:  PackedScene = preload("res://models/cartoon-assets/rock.tscn")

var startz: float = -50.0
var road_spawnx: Array = [-2, 0, 2]
var tree_startx: Array = [10, -10]

onready var env_assets: Array = [tree1, tree2]

const FENCE_COUNT: int = 30
# example of using object pooling for fences
var fences: Array = []
var fencez: float = 0.0


func _ready():
	var x = 0
	var y = 0
	var z = 5
	for i in FENCE_COUNT:
		var fence_inst = fence.instance()
		fence_inst.connect("body_entered", self, "fence_area_body_entered")
		fences.append(fence_inst)
		add_child(fence_inst)
		fence_inst.global_transform.origin = Vector3(
			x, y, z
		)
		z -= 1.5
		fencez = z


func fence_area_body_entered():
	var first_fence = fences.front()
	first_fence.global_transform.origin = Vector3(
		0, 0, fencez
	)
	fences.pop_front()
	fences.append(first_fence)


func _on_spawn_timer_timeout():
	randomize()
	#print("spawned a coin!")
	spawn_timer.wait_time = randi() % 5 + 1 
	
	var random_line_num = randi() % 3
	var prev_rand_line_n = null
	
	var line_count: int = randi() % 4 + 1
	
	for i in line_count:
		while (prev_rand_line_n != null and prev_rand_line_n == random_line_num):
				random_line_num = randi() % 3
		prev_rand_line_n = random_line_num

		for n in rand_range(4, 10):
		
			var coin_inst: MeshInstance = coin.instance()
	
			add_child(coin_inst)
	
			coin_inst.global_transform.origin = Vector3(
				road_spawnx[random_line_num],
				1.0,
				startz + i * 2.5 # set distance between coins
			)


func _on_spawn_env_timer_timeout():
	randomize()
	#print("tree spawned")
	var side: int = tree_startx[randi() % 2]
	var asset = env_assets[randi() % env_assets.size()].instance()
	add_child(asset)
	asset.global_transform.origin = Vector3(
		side,
		0,
		startz
	)
	asset.rotation_degrees.y = rand_range(0, 360)
	spawn_env_timer.wait_time = rand_range(1, 2)


func _on_spawn_obstacle_timer_timeout():
	randomize()
	#print("spawned an obstacle!")
	spawn_obstacle_timer.wait_time = randi() % 5 + 1
	
	var random_line_num = randi() % 3
	var prev_rand_line_n = null
	
	var line_count: int = randi() % 4 + 1
	
	for i in line_count:
		while (prev_rand_line_n != null and prev_rand_line_n == random_line_num):
				random_line_num = randi() % 3
		prev_rand_line_n = random_line_num

		var rock_inst = rock.instance()
# warning-ignore:return_value_discarded
		rock_inst.connect("player_entered", self, "on_player_entered_rock")
	
		add_child(rock_inst)
	
		rock_inst.global_transform.origin = Vector3(
			road_spawnx[random_line_num],
			0.0,
			startz
		)
		rock_inst.rotation_degrees.y = rand_range(0, 360)


func on_player_entered_rock():
	player.is_dead = true
