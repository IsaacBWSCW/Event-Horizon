extends Control

const BASE_SPEED := 60.0
const SPEED_UP_MULT := 10.0
const TITLE_COLOR := Color.BLUE_VIOLET

@onready var credits_container: VBoxContainer = $CreditsContainer
@onready var line_template: Label = $CreditsContainer/Line

var speed_up := false
var finished := false

var credits: Array = [
	[ "Esc to end credits"],
	[ "Down arrow to go faster"],
	[ "A game by Reuben, Isaac and Cy" ],
	[ "Primary Programming", "Isaac"],
	[ "Secondary Programming", "Reuben" ],
	[ "Art", "Reuben" ],
	[ "Music", "Cy(?)" ],
	[ "Sound Effects", "Cy(?)" ],
	[ "Testers", "Ruby", "Isaac", "You ;)" ],
	[ "Tools used", "Developed with Godot Engine", "https://godotengine.org/license", "Art created with Krita", "https://krita.org/en/" ],
	[ "Special thanks", "My teacher", "My parents", "My friends", "My pet rabbit (/j i dont have a rabbit)" ],
	[ "Exremely special thanks...", "You, for playing!"],
	[ "BYE!"],
	]


func _ready() -> void:
	line_template.visible = false

	# Spawn every credit line up front
	for section_arr in credits:
		for i in range(section_arr.size()):
			var new_line := line_template.duplicate() as Label
			new_line.visible = true
			new_line.text = section_arr[i]
			if i == 0:
				new_line.add_theme_color_override("font_color", TITLE_COLOR)
			credits_container.add_child(new_line)

	await get_tree().process_frame
	credits_container.reset_size() # ensures layout updates

	var viewport_h := get_viewport_rect().size.y
	credits_container.position.y = viewport_h

	# calculate total height manually
	var total_height := 0.0
	for child in credits_container.get_children():
		if child is Label:
			total_height += child.size.y + credits_container.get_theme_constant("separation")
	credits_container.custom_minimum_size.y = total_height


func _process(delta: float) -> void:
	var multiplier := SPEED_UP_MULT if speed_up else 1.0
	var scroll_amount := BASE_SPEED * multiplier * delta
	credits_container.position.y -= scroll_amount

	# Recalculate bounds using actual height
	var container_bottom := credits_container.position.y + credits_container.custom_minimum_size.y

	if not finished and container_bottom < 0:
		_finish()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		_finish()
	if event.is_action_pressed("ui_down") and not event.is_echo():
		speed_up = true
	if event.is_action_released("ui_down") and not event.is_echo():
		speed_up = false


func _finish() -> void:
	if finished:
		return
	finished = true
	get_tree().change_scene_to_file("res://scenes/main_menu/main_menu.tscn")
