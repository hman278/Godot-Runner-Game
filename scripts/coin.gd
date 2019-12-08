extends Spatial

var timer: Timer = Timer.new()

func _ready():
	timer.wait_time = 5
	timer.autostart = true
# warning-ignore:return_value_discarded
	timer.connect("timeout", self, "timer_timeout")
	add_child(timer)
	add_to_group("coins")

func _process(delta):
	global_translate(Vector3(0, 0, 0.25))
	rotate_y(5 * delta)
	
func timer_timeout():
	#print("coin destroyed")
	queue_free()
