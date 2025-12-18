extends SpringArm3D

@export var sensibilidad_mouse: float = 0.005

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotation.y -= event.relative.x * sensibilidad_mouse
		rotation.y = wrapf(rotation.y, 0.0, TAU)
		
		rotation.x -= event.relative.y * sensibilidad_mouse
		rotation.x = clamp(rotation.x, -PI/2, PI/5)
