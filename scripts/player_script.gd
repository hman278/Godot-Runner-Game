extends KinematicBody

# warning-ignore:unused_class_variable
onready var audio_player: AudioStreamPlayer3D = $AudioStreamPlayer3D
# warning-ignore:unused_class_variable
onready var animation_player: AnimationPlayer = $player/AnimationPlayer
onready var animation_tree: AnimationTree = $player/AnimationTree
onready var gui: Control = $gui

const MOVE_SPEED: float = 4.0
var starting_point: Vector3 = Vector3.ZERO

var is_jumping: bool = false

var is_dead: bool = false

func _ready() -> void:
	gui.get_node("label").text = "Coins: "
	starting_point = global_transform.origin

# warning-ignore:unused_argument
func _physics_process(delta) -> void:
	var velocity: Vector3 = Vector3.ZERO
	var direction: Vector3 = Vector3.ZERO
	if (Input.is_action_pressed("move_left")):
		direction.x -= 1
	if (Input.is_action_pressed("move_right")):
		direction.x += 1
	direction = direction.normalized()
	if (Input.is_action_just_pressed("jump")):
		is_jumping = true
	if (Input.is_action_just_released("jump")):
		is_jumping = false
	velocity = direction * MOVE_SPEED
	global_transform.origin.x = clamp(
		global_transform.origin.x,
		starting_point.x - 3,
		starting_point.x + 3
	)
# warning-ignore:return_value_discarded
	move_and_slide(velocity)
	if is_jumping: animation_tree.set("parameters/jump-shot/active", true)
	
	if is_dead:
		print('dead')
		is_dead = false

var coin_count: int = 0
func _on_collision_area_entered(area):
	var parent = area.get_parent()
	if parent.is_in_group("coins"):
		audio_player.play()
		#print("picked up a coin!")
		coin_count += 1
		gui.get_node("label").text = "Coins: " + str(coin_count)
		parent.queue_free()

