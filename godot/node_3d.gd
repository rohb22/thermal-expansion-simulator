extends Node3D

var cylinder_ORIG = Vector3(0.1,2,0.1)
var coefficient: float = 0.0
var temperature: float = 0.0
var length: float = 0.0
var result_length: float = 0.0

@onready var cylinder = $cylinder

func _ready() -> void:
	$CanvasLayer/Panel/simulate.pressed.connect(startSimulation)
	$CanvasLayer/Panel/reset.pressed.connect(resetSimulation)
	
func resetSimulation() -> void:
	$CanvasLayer/Panel/coefficient.text = ""
	$CanvasLayer/Panel/initial_temp.text = ""
	$CanvasLayer/Panel/final_temp.text = ""
	$CanvasLayer/Panel/initial_length.text = ""
	$CanvasLayer/Panel/output.text = "Final Length: "
	cylinder.scale = cylinder_ORIG

func startSimulation() -> void:
	
	coefficient = $CanvasLayer/Panel/coefficient.text.to_float()
	var initial_temp = $CanvasLayer/Panel/initial_temp.text.to_float()
	var final_temp = $CanvasLayer/Panel/final_temp.text.to_float()
	temperature = final_temp - initial_temp
	length = $CanvasLayer/Panel/initial_length.text.to_float()
	
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
	
	
