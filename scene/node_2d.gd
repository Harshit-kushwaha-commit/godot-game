extends Node2D


@onready var player = $player
@onready var array_view = $array_view/CanvasLayer/Control
@onready var empty_the_array = $Area2Da

func _ready():
	player.input_array_update.connect(array_view.update_display)
	empty_the_array.empty_input_array.connect(player.empthy_the_array)
