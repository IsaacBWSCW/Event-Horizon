extends Node2D

var G: float = 1000

func _ready() -> void:
	$Bodies.generate_system(5)
