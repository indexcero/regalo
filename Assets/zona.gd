extends MeshInstance3D
#signals.emit_signal("objeto_zona", $RayCast3D.get_collider().get_instance_id())


func _on_area_3d_body_entered(body: Node3D) -> void:
	signals.emit_signal("objeto_zona", body)
	print(body)
