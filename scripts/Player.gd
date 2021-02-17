extends KinematicBody2D

export var snap = false
export var move_speed = 200
export var jump_force = -500
export var gravity = 10
export var slope_slide_threshold = 50.0
var floorNormal = Vector2(0, -1)

var canJumpEvenMaybeNotTouchingTheGround = true
var jumpWasPressed = false
var isCrouched = false
var is_dashing = false
var can_dash = true
var dash_direction = Vector2()
export var dash_speed = 1000 
export var dash_length = 0.2
onready var dash_timer = $Timer 

var velocity = Vector2()

func _ready():
	dash_timer.connect("timeout",self,"dash_timer_timeout")

func _physics_process(delta):
	var goDown = Input.is_action_pressed("ui_down") and Input.is_action_just_pressed("jump")
	var jump = Input.is_action_just_pressed("jump")
	var left = Input.is_action_pressed("ui_left")
	var right = Input.is_action_pressed("ui_right")
	var crouch = Input.is_action_just_pressed("ui_down")
	
	if is_on_floor():
		canJumpEvenMaybeNotTouchingTheGround = true
		if jumpWasPressed:
			velocity.y = jump_force
	
	if goDown:
		for platform in get_parent().get_children():
			if platform.is_in_group('through'):
				platform.disableCollision()
	elif jump:
		jumpWasPressed = true
		rememberJumpTime()
		if canJumpEvenMaybeNotTouchingTheGround:
			velocity.y = jump_force
	
	if Input.is_action_just_released("jump"):
		jump_cut()
	
	if !is_on_floor():
		coyoteTime()
		velocity.y += gravity
		
	if left:
		velocity.x = -move_speed
	elif right:
		velocity.x = move_speed
	else:
		velocity.x = 0
	
	if crouch:
		isCrouched = true
	if Input.is_action_just_released("ui_down"):
		isCrouched = false
	
	if isCrouched:
		$Stand.disabled = true
		$Crouch.disabled = false
		$Sprite.scale.y = 1
		velocity.x = 0
	else:
		$Stand.disabled = false
		$Crouch.disabled = true
		$Sprite.scale.y = 1.5
		
	handle_dash(delta)
	
	if is_on_floor():
		can_dash = true
		
	if(is_dashing):
		velocity = move_and_slide(dash_direction, floorNormal)
		#vSpeed = 0
		#hSpeed = 0
	else:
		velocity = move_and_slide(velocity, floorNormal)

func coyoteTime():
	yield(get_tree().create_timer(.1), "timeout")
	canJumpEvenMaybeNotTouchingTheGround = false
	pass

func rememberJumpTime():
	yield(get_tree().create_timer(.1), "timeout")
	jumpWasPressed = false
	pass

func handle_dash(var delta):
	if(Input.is_action_just_pressed("dash") and can_dash and !is_on_floor()):
		is_dashing = true
		can_dash = false
		dash_direction = get_direction_from_input()
		dash_timer.start(dash_length)
	
	if(is_dashing):
		if(is_on_floor()):
			is_dashing = false
		if(is_on_wall()):
			is_dashing = false
		pass
	
func get_direction_from_input():
	var move_dir = Vector2()
	
	move_dir.x = -Input.get_action_strength("ui_left") + Input.get_action_strength("ui_right")
	move_dir.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
		
	move_dir = move_dir.clamped(1)
	
	#check if no movement is pressed further enough... then dash towards ur facing position
	if (move_dir == Vector2(0,0)):
		if($Sprite.flip_h):
			move_dir.x = -1
		else:
			move_dir.x = 1
			
	return move_dir * dash_speed
	
func dash_timer_timeout():
	is_dashing = false

func jump_cut():
	if velocity.y < -100:
		velocity.y = -100
