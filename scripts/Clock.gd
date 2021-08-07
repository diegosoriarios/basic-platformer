extends Area2D

func _on_Clock_body_entered(body):
	if body.name == "Player":
		queue_free()
