extends CharacterBody3D

@export var speed := 8.0
@export var gravity := 9.8
@export var sensibilidad_mouse: float = 0.005




func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		var random_int = randi_range(0, 1)
		if event.pressed:
			if (random_int ==0):
				$AudioStreamPlayer3D.play()
			else:
				$AudioStreamPlayer3D2.play()
		else:
			$drop.play()
			$AudioStreamPlayer3D.stop()
			$AudioStreamPlayer3D2.stop()



func _process(delta: float) -> void:
	if Input.is_action_pressed("atras"):
		$AnimationTree.set("parameters/Blend3/blend_amount", -1.0)
	if Input.is_action_pressed("adelante"):
		$AnimationTree.set("parameters/Blend3/blend_amount", -1.0)
	if Input.is_action_pressed("derecha"):
		$AnimationTree.set("parameters/Blend3/blend_amount", -0.5)
	if Input.is_action_pressed("izquierda"):
		$AnimationTree.set("parameters/Blend3/blend_amount", -0.5)
	if Input.is_action_pressed("hechizo"):
		$AnimationTree.set("parameters/Blend3/blend_amount", 1.0)


func _physics_process(delta):
	var direction := Vector3.ZERO


	# Input clásico WASD
	if Input.is_action_pressed("atras"):
		direction -= transform.basis.z
	if Input.is_action_pressed("adelante"):
		direction += transform.basis.z
	if Input.is_action_pressed("derecha"):
		rotation.y -= 0.04
	if Input.is_action_pressed("izquierda"):
		rotation.y += 0.04

	direction = direction.normalized()

	# Movimiento horizontal
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed

	# Gravedad (sin salto)
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		velocity.y = 0
		$AnimationTree.set("parameters/Blend3/blend_amount", 0.0)

	move_and_slide()
	
	var was_colliding = false
	
	var colliding = $RayCast3D.is_colliding()
	
	if colliding and not was_colliding:
		if ($RayCast3D.get_collider().name == "cubo2vertical"):
			signals.emit_signal("raycast_hit", $RayCast3D.get_collider())
	
	elif not colliding and was_colliding:
		pass
	
	was_colliding = colliding
