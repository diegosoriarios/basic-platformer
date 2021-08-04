extends Area2D

onready var color_rect = $ColorRect

func _on_SecretSpot_body_entered(body):
	if body.name == "Player":
		$AnimationPlayer.play("fade_out")


func _on_SecretSpot_body_exited(body):
	if body.name == "Player":
		$AnimationPlayer.play("fade_in")
