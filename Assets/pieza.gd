extends RigidBody3D

@export var drag_force := 60.0
@export var drag_damp := 10.0
@export var angular_drag := 8.0

@export var max_distance := 2.5

var grabbed := false
var grab_point_local: Vector3
var grab_target: Node3D
var grab_distance := 0.0
var camera: Camera3D

var debug_sphere: MeshInstance3D


var agarrable = false
func _ready():
	signals.raycast_hit.connect(_on_raycast_hit)

	
func _on_timer_timeout() -> void:
	agarrable = false

func _on_raycast_hit(mensaje):
	if (mensaje.name=="cubo2vertical"): 
		agarrable = true
		print("Se agarro: ", mensaje.name)
		$Timer.start()


func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed and agarrable:
			try_grab()
		else:
			release()

func try_grab():
	camera = get_viewport().get_camera_3d()
	
	if camera == null:
		return

	var mouse_pos = get_viewport().get_mouse_position()
	var from = camera.project_ray_origin(mouse_pos)
	var to = from + camera.project_ray_normal(mouse_pos) * 100.0
	print(from)
	print(to)	
	
	
	var query = PhysicsRayQueryParameters3D.create(from, to)
	query.collide_with_areas = false
	query.collide_with_bodies = true

	var result = get_world_3d().direct_space_state.intersect_ray(query)
	if result.is_empty():
		return

#	if result.collider != self:
#		return

	grabbed = true
	grab_point_local = to_local(result.position)
	grab_distance = from.distance_to(result.position)

	create_grab_target(result.position)
	

func create_grab_target(world_pos: Vector3):
	grab_target = Node3D.new()
	grab_target.global_position = world_pos
	debug_sphere = MeshInstance3D.new()
	debug_sphere.global_position = world_pos
	
	get_tree().current_scene.add_child(grab_target)
	get_tree().current_scene.add_child(debug_sphere)

	# Damping alto mientras se arrastra
	linear_damp = drag_damp
	angular_damp = drag_damp

func _physics_process(delta):
	if not grabbed:
		return

	update_grab_target()

	var grab_point_world = global_transform * grab_point_local
	var dir = grab_target.global_position - grab_point_world

	if dir.length() > max_distance:
		dir = dir.normalized() * max_distance

	apply_force(dir * drag_force, grab_point_world - global_position)

func update_grab_target():
	var mouse_pos = get_viewport().get_mouse_position()

	var from = camera.project_ray_origin(mouse_pos)
	var dir = camera.project_ray_normal(mouse_pos)

	var plane_origin = camera.global_position + camera.global_transform.basis.z * -grab_distance
	var plane_normal = camera.global_transform.basis.z

	var plane = Plane(plane_normal, plane_origin)
	var hit = plane.intersects_ray(from, dir)

	if hit != null:
		grab_target.global_position = hit
		
func release():
	if not grabbed:
		return

	grabbed = false

	linear_damp = 0.0
	angular_damp = 0.0

	if grab_target:
		grab_target.queue_free()
		grab_target = null
