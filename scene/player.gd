extends CharacterBody2D
#jsut create function for the normal movemnt and maek the switch statement using the boolean value comes
signal input_array_update(inputs)
# Movement variables
@export var SPEED = 160.0
const JUMP_VELOCITY = -280.0
# Array that stores movement commands
var input_array = []
# Input settings
@export var input_limit = 3
@export var input_loop = 2
# Movement timing
@export var up_and_dir_time = 0.25
@export var complete_run_time = 0.5
# Controls whether the player can enter commands
var input_valid := true
# Controls whether the current movement sequence is cancelled
var movement_cancelled := false
# Called when the mushroom signal tells the player
# to empty the input array
var  normal_movement := true
func empthy_the_array():
	if normal_movement == true :
		pass
	else:
		input_array.clear()
		# Stop the player immediately
		velocity = Vector2.ZERO
		# Cancel the currently running movement sequence
		movement_cancelled = true
		# Update the array UI
		input_array_update.emit(input_array)
		print("array emptied")

# Add a command to the input array
func append_array(command: String):
	if input_array.size() < input_limit:
		input_array.append(command)
		input_array_update.emit(input_array)
		print(command)
	else:
		print("limit exceeded")
# Print every command in the array
func print_array():
	for i in range(input_array.size()):
		print("array is =")
		print(input_array[i])
# Remove the last command from the array
func delete_element():
	if input_array.size() > 0:
		input_array.pop_back()
		input_array_update.emit(input_array)
		print("removed")
# Start executing the stored movement commands
func start_movement():
	input_valid = false
	# A new movement sequence starts normally
	movement_cancelled = false
	for i in range(input_loop):
		for j in range(input_array.size()):
			# If the mushroom cancelled movement,
			# stop the whole sequence
			if movement_cancelled:
				input_valid = true
				return
			# Safety check:
			# if the array was cleared, don't access
			# an index that no longer exists
			if j >= input_array.size():
				input_valid = true
				return
			await movement(j)
			# Check again after await
			if movement_cancelled:
				input_valid = true
				return
	# Only reaches here if movement completed normally
	input_array.clear()
	input_array_update.emit(input_array)
	input_valid = true

func jump():
			velocity.y = JUMP_VELOCITY

func horizontal_movement(direction: int):
			velocity.x = SPEED * direction

func side_jump(direction: int):
			velocity.y = JUMP_VELOCITY
			velocity.x = SPEED * direction

func direct_movement():
	if Input.is_action_pressed("jm") and is_on_floor():
		jump()
	elif Input.is_action_pressed("left"):
		horizontal_movement(-1)
	elif Input.is_action_pressed("right"):
		horizontal_movement(1)
	elif Input.is_action_pressed("up_left"):
		side_jump(-1)
	elif Input.is_action_pressed("up_right"):
		side_jump(1)
	elif Input.is_action_pressed("back"):
		delete_element()
	else:
		velocity.x = move_toward(velocity.x,0,SPEED)


# Handle player input
func input_mapping():
	if input_valid == true:
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
	# Remove the last command
	if Input.is_action_just_pressed("back"):
		delete_element()
	# Start the movement sequence
	elif Input.is_action_just_pressed("enter") and input_valid == true:
		start_movement()
	elif Input.is_action_just_pressed("print_array"):
		print_array()


# Execute one movement command
func movement(j: int):
	# Extra safety check before accessing the array
	if movement_cancelled:
		return
	if j >= input_array.size():
		return
	match input_array[j]:
		"jm":
			velocity.y = JUMP_VELOCITY
			await get_tree().create_timer(1.0).timeout
		"left":
			velocity.x = -SPEED
			await get_tree().create_timer(complete_run_time).timeout
			velocity.x = 0
		"right":
			velocity.x = SPEED
			await get_tree().create_timer(complete_run_time).timeout
			velocity.x = 0
		"up_right":
			velocity.y = JUMP_VELOCITY
			velocity.x = SPEED
			await get_tree().create_timer(up_and_dir_time).timeout
			velocity.x = 0
		"up_left":
			velocity.y = JUMP_VELOCITY
			velocity.x = -SPEED
			await get_tree().create_timer(up_and_dir_time).timeout
			velocity.x = 0
		_:
			velocity.x = move_toward(velocity.x,0,SPEED)


func _physics_process(delta: float) -> void:
	# Apply gravity
	if not is_on_floor():
		velocity += get_gravity() * delta
	# Handle player commands
	if normal_movement == false:
		input_mapping()
		
	else:
		direct_movement()
		
	# Move the player
	move_and_slide()
