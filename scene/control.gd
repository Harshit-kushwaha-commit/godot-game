extends Control

@onready var slot1 = $slot1/Label1
@onready var slot2 = $slot2/Label2
@onready var slot3 = $slot3/Label3



func update_display(inputs):
	slot1.text = ""
	slot2.text = ""
	slot3.text = ""
	if inputs.size() > 0:
		slot1.text = convert_command(inputs[0])
	if inputs.size() > 1:
		slot2.text = convert_command(inputs[1])
	if inputs.size() > 2:
		slot3.text = convert_command(inputs[2])

func convert_command(command):
	print("Converting:", command)
	match command:
		"left":
			return "←"
		"right":
			return "→"
		"jm":
			return "↑"
		_:
			return "?"
