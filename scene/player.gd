extends CharacterBody2D
signal input_array_update(inputs)
# These are the variable for the player to move in 
@export var SPEED = 160.0
const JUMP_VELOCITY = -280.0
#This array hold the all input data for the movement of the player
var input_array = []
#This hold current varible equal to the input key of the player
var current_input = ""
#this is the limit at which the inuput can be holded for and the time the inputs will be executed 
@export var input_limit = 3
@export var input_loop = 2
#This is the speed at which the character moves
@export var up_and_dir_time = 0.25
@export var complete_run_time = 0.5
var input_valid := true

const jump_cmd = "jump"
const right_cmd = "right"
const left_cmd = "left"
const upper_left_cmd = "upper left"
const upper_right_cmd = "upper right"

func empthy_the_array():
	print("array emptied")

func append_array(command: String):
	if (input_array.size() < input_limit):
		input_array.append(command) 
		input_array_update.emit(input_array)
		print(command)
	else:
		print("limit exceeded")

func print_array():
	for i in range(input_array.size()):
		print("array is =")
		print(input_array[i])
		

func delete_element():
	if input_array.size() > 0:
			input_array.pop_back()
			input_array_update.emit(input_array)
			print("removed")
			

func start_movement():
			input_valid = false
			for i in range(input_loop):
				for j in range(input_array.size()):
					await movement(j)
			input_array.clear()
			input_array_update.emit(input_array)
			input_valid = true

func input_mapping():
	if (input_valid == true):
		if Input.is_action_just_pressed("jm") and is_on_floor():
			append_array("jm")
		elif Input.is_action_just_pressed("left"):
			append_array("left")
		elif Input.is_action_just_pressed("right"):
			append_array("right")
		elif Input.is_action_just_pressed("up_left"):
			append_array("up_left")
		elif Input.is_action_just_pressed("up_right"):
			append_array("up_right")
	if Input.is_action_just_pressed("back"):
		delete_element()
	elif Input.is_action_just_pressed("enter") and (input_valid == true):
		start_movement()
	elif Input.is_action_just_pressed("print_array"):
		print_array()

func movement(j: int):
	match input_array[j]:
		"jm":
			velocity.y = JUMP_VELOCITY
			await get_tree().create_timer(1.0).timeout
		"left":
			velocity.x = -SPEED
			await get_tree().create_timer(complete_run_time).timeout
			velocity.x = 0
		"right":
			velocity.x = +SPEED
			await get_tree().create_timer(complete_run_time).timeout
			velocity.x = 0
		"up_right":
			velocity.y = JUMP_VELOCITY
			velocity.x = +SPEED
			await get_tree().create_timer(up_and_dir_time).timeout
			velocity.x = 0
		"up_left":
			velocity.y = JUMP_VELOCITY
			velocity.x = -SPEED
			await get_tree().create_timer(up_and_dir_time).timeout
			velocity.x = 0
		_:
			velocity.x = move_toward(velocity.x, 0, SPEED)

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	input_mapping()
	
	move_and_slide()
