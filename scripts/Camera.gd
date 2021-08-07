extends Camera2D

var move_front = false
var move_back = false
var body_entered = false
var can_collide = true
var difference = 0

const MOVE_SPEED = 10

export(PackedScene) var next_scene

func _ready():
	pass

func _process(delta):
	if move_front:
		yield(get_tree().create_timer(.1), "timeout")
		self.position.x += MOVE_SPEED
		
		difference += MOVE_SPEED
		
		if difference >= 1024:
			difference = 0
			can_collide = true
			move_front = false
	elif move_back:
		yield(get_tree().create_timer(.1), "timeout")
		self.position.x -= MOVE_SPEED
		
		difference += MOVE_SPEED
		
		if difference >= 1024:
			difference = 0
			can_collide = true
			move_back = false

func _on_Area2D_body_entered(body):
	if body.name == "Player" and can_collide:
		#get_tree().change_scene_to(next_scene)
		current = true
		#print('aqui')
		#can_collide = false
		#move_front = true
		#body.transition_on()

func _on_Area2D_body_exited(body):
	#body_left(body)
	pass


func _on_Back_body_entered(body):
	if body.name == "Player" and can_collide:
		print('aqui')
		can_collide = false
		move_back = true
		body.transition_on()

func _on_Back_body_exited(body):
	body_left(body)

func body_left(body):
	if body.name == "Player":
		body_entered = false
		body.transition_off()
