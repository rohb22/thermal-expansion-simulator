extends Node3D

const CYLINDER_ORIGINAL_SCALE = Vector3(0.1, 2, 0.1)
const METAL_COEFFICIENTS = {
	"Aluminum": 23,
	"Copper": 16,
	"Iron": 12,
	"Silver": 19,
	"Gold": 14
}

@onready var cylinder = $cylinder
@onready var dropdown = $CanvasLayer/coefficient_dropdown
@onready var coefficient_label = $CanvasLayer/Panel/coefficient
@onready var simulate_button = $CanvasLayer/Panel/simulate
@onready var reset_button = $CanvasLayer/Panel/reset
@onready var initial_temp_field = $CanvasLayer/Panel/initial_temp
@onready var final_temp_field = $CanvasLayer/Panel/final_temp
@onready var initial_length_field = $CanvasLayer/Panel/initial_length
@onready var output_label = $CanvasLayer/Panel/output

var coefficient: float = 0.0
var temperature: float = 0.0
var length: float = 0.0
var result_length: float = 0.0

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
	temperature = final_temp - initial_temp
	length = initial_length_field.text.to_float()

	if coefficient <= 0:
		output_label.text += "Material expansion must be greater than 0"
		return
	elif length <= 0:
		output_label.text += "Material length must be greater than 0"
		return

	var expansion = coefficient * temperature * length
	result_length = length + expansion
	output_label.text += str(result_length)
	cylinder.scale = CYLINDER_ORIGINAL_SCALE
	_animate(expansion * 10**3)

func _animate(expansion: float) -> void:
	var tween = create_tween()
	var orig_scale = cylinder.scale
	var updated = Vector3(orig_scale.x, orig_scale.y + expansion / length, orig_scale.z)
	tween.tween_property(cylinder, "scale", updated, 2.0)
