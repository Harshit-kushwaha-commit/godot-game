extends Node2D


@onready var player = $player
@onready var array_view = $array_view/CanvasLayer/Control

func _ready():
	player.input_array_update.connect(array_view.update_display)
