extends HBoxContainer

# This caches the `get_node()` call and infers the type of the variable
# for better autocompletion in the editor
onready var line_edit := $LineEdit as LineEdit

var counter := 0 setget set_counter

func set_counter(p_counter: int) -> void:
	line_edit.text = str(p_counter)
	counter = p_counter

func _on_button_pressed() -> void:
	# `self` is required here, so that it calls the setter method defined above
	self.counter += 1
