extends KinematicBody2D

var wheel_base = 70
var steering_angle = 30
var friction_power = -0.5

var accelleration = Vector2.ZERO
var velocity = Vector2.ZERO
var steer_angle 

var brakesPower = -500
var enginePower = 500

func _physics_process(delta):
#	velocity = Vector2.ZERO
	accelleration = Vector2.ZERO
	handle_Input()
	calculate_steering(delta)
	handle_friction()
	velocity += accelleration * delta
	velocity = move_and_slide(velocity) 
	
func handle_friction():
	if velocity.length() < 5:
		velocity = Vector2.ZERO	
	var force = velocity * friction_power
	accelleration += force 

func handle_Input():
	var turn = 0
	if Input.is_action_pressed("ui_left"):
		turn -= 1
	if Input.is_action_pressed("ui_right"):
		turn += 1
	steer_angle = turn * deg2rad(steering_angle)
	if Input.get_action_strength("ui_up"):
		accelleration = transform.x * enginePower
	if Input.get_action_strength("ui_down"):
		accelleration = transform.x * brakesPower

func calculate_steering(delta):
	var rear_wheel = position - transform.x * wheel_base / 2.0
	var front_wheel = position + transform.x * wheel_base / 2.0
	rear_wheel += velocity * delta
	front_wheel += velocity.rotated(steer_angle) * delta
	var new_heading = (front_wheel - rear_wheel).normalized()
	velocity = new_heading * velocity.length()
	rotation = new_heading.angle()
	
