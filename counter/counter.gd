# Copyright © 2019 Hugo Locurcio and contributors - MIT License
# See `LICENSE.md` included in the source distribution for details.

extends HBoxContainer

# This caches the `get_node()` call and infers the type of the variable
# for better autocompletion in the editor
onready var line_edit := $LineEdit as LineEdit

var counter := 0 setget set_counter

func _ready() -> void:
	OS.window_size = Vector2(240, 60)

func _on_button_pressed() -> void:
	# `self` is required here, so that it calls the setter method defined above
	self.counter += 1

func set_counter(p_counter: int) -> void:
	line_edit.text = str(p_counter)
	counter = p_counter
