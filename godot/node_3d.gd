extends Node3D

var CYLINDER_ORIGINAL_SCALE = Vector3(0.1, 2, 0.1)
var coefficient: float = 0.0
var temperature_change: float = 0.0
var initial_length: float = 0.0
var final_length: float = 0.0

@onready var cylinder = $cylinder
@onready var dropdown = $CanvasLayer/coefficient_dropdown
@onready var simulate_button = $CanvasLayer/Panel/simulate
@onready var reset_button = $CanvasLayer/Panel/reset
@onready var coefficient_label = $CanvasLayer/Panel/coefficient
@onready var initial_temp_field = $CanvasLayer/Panel/initial_temp
@onready var final_temp_field = $CanvasLayer/Panel/final_temp
@onready var initial_length_field = $CanvasLayer/Panel/initial_length
@onready var output_label = $CanvasLayer/Panel/output

const METAL_COEFFICIENTS = {
	"Aluminum": 23,
	"Copper": 16,
	"Iron": 12,
	"Silver": 19,
	"Gold": 14
}

func _ready() -> void:
	_populate_materials()
	dropdown.item_selected.connect(_on_dropdown_select)
	simulate_button.pressed.connect(_on_simulate_pressed)
	reset_button.pressed.connect(_on_reset_pressed)

func _populate_materials() -> void:
	for metal in METAL_COEFFICIENTS.keys():
		dropdown.add_item(metal)

func _on_dropdown_select(index: int) -> void:
	var selected_metal = dropdown.get_item_text(index)
	coefficient_label.text = str(METAL_COEFFICIENTS[selected_metal])

func _on_reset_pressed() -> void:
	coefficient_label.text = ""
	initial_temp_field.text = ""
	final_temp_field.text = ""
	initial_length_field.text = ""
	output_label.text = "Final Length: "
	cylinder.scale = CYLINDER_ORIGINAL_SCALE

func _on_simulate_pressed() -> void:
	output_label.text = "Final Length: "

	coefficient = float("0.0000" + coefficient_label.text)
	var initial_temp = initial_temp_field.text.to_float()
	var final_temp = final_temp_field.text.to_float()
	temperature_change = final_temp - initial_temp
	initial_length = initial_length_field.text.to_float()

	if coefficient <= 0:
		output_label.text += "Material expansion must be greater than 0"
		return

	if initial_length <= 0:
		output_label.text += "Material length must be greater than 0"
		return

	var expansion = coefficient * temperature_change * initial_length
	final_length = initial_length + expansion

	output_label.text += str(final_length)
	cylinder.scale = CYLINDER_ORIGINAL_SCALE
	_animate_expansion(expansion * 10**3)

func _animate_expansion(expansion: float) -> void:
	var tween = create_tween()
	var updated_scale = Vector3(
		CYLINDER_ORIGINAL_SCALE.x,
		CYLINDER_ORIGINAL_SCALE.y + expansion / initial_length,
		CYLINDER_ORIGINAL_SCALE.z
	)

	tween.tween_property(cylinder, "scale", updated_scale, 2.0)
