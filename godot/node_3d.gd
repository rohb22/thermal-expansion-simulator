extends Node3D

var cylinder_ORIG = Vector3(0.1,2,0.1)
var coefficient: float = 0.0
var temperature: float = 0.0
var length: float = 0.0
var result_length: float = 0.0

@onready var cylinder = $cylinder
@onready var dropdown = $CanvasLayer/coefficient_dropdown

func _ready() -> void:
	addMaterials()
	dropdown.item_selected.connect(dropdownSelect)
	$CanvasLayer/Panel/simulate.pressed.connect(startSimulation)
	$CanvasLayer/Panel/reset.pressed.connect(resetSimulation)

func dropdownSelect(index: int) -> void:
	var selected_metal = dropdown.get_item_text(index)
	var coefficients = {
		"Aluminum": 0.000023,
		"Copper": 0.000016,
		"Iron": 0.000012,
		"Silver": 0.000019,
		"Gold": 0.000014
	}
	$CanvasLayer/Panel/coefficient.text = str(coefficients[selected_metal])


func addMaterials() -> void:
	var metals = {
		"Aluminum": 0.000023,
		"Copper": 0.000016,
		"Iron": 0.000012,
		"Silver": 0.000019,
		"Gold": 0.000014
	}
	for metal in metals.keys():
		dropdown.add_item(metal)

	
func resetSimulation() -> void:
	$CanvasLayer/Panel/coefficient.text = ""
	$CanvasLayer/Panel/initial_temp.text = ""
	$CanvasLayer/Panel/final_temp.text = ""
	$CanvasLayer/Panel/initial_length.text = ""
	$CanvasLayer/Panel/output.text = "Final Length: "
	cylinder.scale = cylinder_ORIG

func startSimulation() -> void:
	$CanvasLayer/Panel/output.text = "Final Length: "
	coefficient = $CanvasLayer/Panel/coefficient.text.to_float()
	var initial_temp = $CanvasLayer/Panel/initial_temp.text.to_float()
	var final_temp = $CanvasLayer/Panel/final_temp.text.to_float()
	temperature = final_temp - initial_temp
	length = $CanvasLayer/Panel/initial_length.text.to_float()
	
	if coefficient <= 0:
		$CanvasLayer/Panel/output.text += "Material expansion must be greater than 0"
		
		return
	elif length <= 0:
		$CanvasLayer/Panel/output.text += "Material length must be greater than 0"
		return
	
	var expansion = coefficient * temperature * length
	result_length = length + expansion
	
	$CanvasLayer/Panel/output.text += str(result_length)
	cylinder.scale = cylinder_ORIG
	animate(expansion)
	
func animate(expansion:float) -> void:
	var tween  = create_tween()
	
	var orig_scale = cylinder.scale
	var updated = Vector3(orig_scale.x, orig_scale.y + expansion / length, orig_scale.z)
	
	tween.tween_property(cylinder, "scale", updated, 5.0)
	
	
