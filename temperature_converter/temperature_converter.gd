# Copyright © 2019 Hugo Locurcio and contributors - MIT License
# See `LICENSE.md` included in the source distribution for details.

extends HBoxContainer

onready var celsius_field := $CelsiusLineEdit as LineEdit
onready var fahrenheit_field := $FahrenheitLineEdit as LineEdit

var celsius := 0.0 setget set_celsius
var fahrenheit := 32.0 setget set_fahrenheit

func _ready() -> void:
	OS.window_size = Vector2(320, 60)

func _on_celsius_text_changed(new_text: String) -> void:
	self.celsius = float(new_text)

	# Empty the other field if this field is empty
	if new_text == "":
		fahrenheit_field.text = ""

func _on_fahrenheit_text_changed(new_text: String) -> void:
	self.fahrenheit = float(new_text)

	# Empty the other field if this field is empty
	if new_text == "":
		celsius_field.text = ""

func set_celsius(p_celsius: float) -> void:
	fahrenheit = p_celsius * 1.8 + 32
	fahrenheit_field.text = str(fahrenheit)
	celsius = p_celsius

func set_fahrenheit(p_fahrenheit: float) -> void:
	celsius = (p_fahrenheit - 32) / 1.8
	celsius_field.text = str(celsius)
	fahrenheit = p_fahrenheit
