extends Node3D

var regalo = preload("res://Escenas/regalo_animado_5.tscn")



func _ready():
	signals.objeto_zona.connect(_on_objeto_zona)
	
func _on_objeto_zona(objeto):
	var instancia = regalo.instantiate()
	instancia.global_transform.origin = $Player.global_transform.origin
	if objeto.name == "cubotetris" or objeto.name == "cubo2vertical" or objeto.name == "cubo3horizontal":
		print("Se añadio un objeto")
		signals.counter_objetos += 1
		print(signals.counter_objetos)
		
		if signals.counter_objetos > 9:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			get_tree().current_scene.add_child(instancia)
			$Timer_win.start()
			$AudioStreamPlayer.stop()
			$Audio_win.play()
			signals.counter_objetos = 0


func _on_limite_arriba_body_entered(body: Node3D) -> void:
	print(body.name)
	if body.name == "Player":
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_tree().change_scene_to_file("res://Assets/Moriste.tscn")


func _on_timer_win_timeout() -> void:
	get_tree().change_scene_to_file("res://Assets/Ganaste.tscn")
