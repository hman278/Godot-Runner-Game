extends Spatial

signal body_entered


# warning-ignore:unused_argument
func _process(delta):
	global_translate(Vector3(0, 0, 0.25))


# warning-ignore:unused_argument
func _on_area_body_entered(body):
	emit_signal("body_entered")
