# Copyright © 2019 Hugo Locurcio and contributors - MIT License
# See `LICENSE.md` included in the source distribution for details.

extends VBoxContainer

enum FlightMode { ONE_WAY_FLIGHT, RETURN_FLIGHT }

onready var start_date_field := $StartDate as LineEdit
onready var end_date_field := $EndDate as LineEdit
onready var book_button := $Book as Button

var flight_mode: int = FlightMode.ONE_WAY_FLIGHT
var start_date := { valid = true, year = 2019, month = 5, day = 11 } setget set_start_date
var end_date := { valid = true, year = 2019, month = 5, day = 11 } setget set_end_date

func _ready() -> void:
	OS.window_size = Vector2(180, 160)

func _on_flight_mode_selected(id: int) -> void:
	if id == FlightMode.ONE_WAY_FLIGHT:
		flight_mode = id
		end_date_field.editable = false
	else:
		# "return flight"
		flight_mode = id
		end_date_field.editable = true

func _on_start_date_changed(new_text: String) -> void:
	self.start_date = parse_date(new_text)

func _on_end_date_changed(new_text: String) -> void:
	self.end_date = parse_date(new_text)

func _on_book_button_pressed() -> void:
	var confirmation_text := (
		"You have booked a one-way flight on {start_date}." if flight_mode == FlightMode.ONE_WAY_FLIGHT
		else "You have booked a return flight from {start_date} to {end_date}."
	)

	# NOTE: `OS.alert()` is a blocking operation.
	# We reuse the field text as it's already formatted as a date string
	OS.alert(confirmation_text.format({
			start_date = start_date_field.text,
			end_date = end_date_field.text,
	}))

# Parses a date in `YYYY.MM.DD` format into a date dictionary.
func parse_date(date: String) -> Dictionary:
	var date_components := date.split(".")
	var invalid_date := { valid = false, year = 0, month = 0, day = 0 }

	# Detect invalid characters in the date string
	for character in date:
		if not character in "0123456789.":
			return invalid_date

	# Detect empty date components
	for component in date_components:
		if component == "":
			return invalid_date

	# Check for the number of date components (we need 3, for year/month/day)
	if date_components.size() == 3:
		return {
			valid = true,
			year = int(date_components[0]),
			month = int(date_components[1]),
			day = int(date_components[2]),
		}
	else:
		return invalid_date

# Makes the field passed as argument red if it's invalid.
func validate_date(field: LineEdit, date: Dictionary) -> void:
	field.add_color_override(
			"font_color",
			Color(0.85, 0.85, 0.85) if date.valid else Color(1, 0.35, 0.3)
	)

# Returns `true` if `date1` is before `date2`; returns `false` otherwise.
func date_is_before(date1: Dictionary, date2: Dictionary) -> bool:
	return (
		date1.year < date2.year
		or date1.year == date2.year and date1.month < date2.month
		or date1.year == date2.year and date1.month == date2.month and date1.day < date2.day
	)

func set_start_date(p_start_date: Dictionary) -> void:
	validate_date(start_date_field, p_start_date)
	# Disable the "Book" button if the dates are invalid or incoherent
	book_button.disabled = !p_start_date.valid or date_is_before(end_date, p_start_date)
	start_date = p_start_date

func set_end_date(p_end_date: Dictionary) -> void:
	validate_date(end_date_field, p_end_date)
	# Disable the "Book" button if the dates are invalid or don't make sense
	book_button.disabled = !p_end_date.valid or date_is_before(p_end_date, start_date)
	end_date = p_end_date
