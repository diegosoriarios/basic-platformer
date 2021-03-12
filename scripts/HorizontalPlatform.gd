extends KinematicBody2D

export var time = 1
export var speed = 1
export var direction = 1

onready var timer = $Timer

func _ready():
	timer.wait_time = time

func _physics_process(delta):
	position.x += speed * direction

func _on_Timer_timeout():
	direction *= -1
