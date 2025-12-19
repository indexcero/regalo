extends CanvasLayer


func _on_ready():
	$Control/numero.text = "Holiwis"
	
func _process(delta: float) -> void:
	$Control/numero.text = str(signals.counter_objetos)
