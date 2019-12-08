extends Spatial

var timer: Timer = Timer.new()

signal player_entered


func _ready():
	timer.wait_time = 5
	timer.autostart = true
# warning-ignore:return_value_discarded
	timer.connect("timeout", self, "timer_timeout")
	add_child(timer)


# warning-ignore:unused_argument
func _process(delta):
	global_translate(Vector3(0, 0, 0.25))


func timer_timeout():
	#print("tree destroyed")
	queue_free()


# every rock is connected to the player script each time a new instance is spawned
func _on_Area_area_entered(area):
	if area.is_in_group("player_skeleton"):
		emit_signal("player_entered")
