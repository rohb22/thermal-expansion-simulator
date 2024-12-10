extends Node3D

var cylinder_ORIG = Vector3(0.1,2,0.1)
var coefficient: float = 0.0
var temperature: float = 0.0
var length: float = 0.0
var result_length: float = 0.0

@onready var cylinder = $cylinder

func _ready() -> void:
	$CanvasLayer/simulate.pressed.connect(startSimulation)

func startSimulation() -> void:
	
	coefficient = $CanvasLayer/coefficient.text.to_float()
	var initial_temp = $CanvasLayer/initial_temp.text.to_float()
	var final_temp = $CanvasLayer/final_temp.text.to_float()
	temperature = final_temp - initial_temp
	length = $CanvasLayer/initial_length.text.to_float()
	
	var expansion = coefficient * temperature * length
	result_length = length + expansion
	
	$CanvasLayer/output.text = "Final Length: %.2f" % result_length
	cylinder.scale = cylinder_ORIG
	animate(expansion)
	
func animate(expansion:float) -> void:
	var tween  = create_tween()
	
	var orig_scale = cylinder.scale
	var updated = Vector3(orig_scale.x, orig_scale.y + expansion / length, orig_scale.z)
	
	tween.tween_property(cylinder, "scale", updated, 5.0)
	
	
