@tool
extends Node3D
## Projects an explicitly selected DirectionalLight3D into the sky's sun disk.

@export var sky_material: ShaderMaterial
@export_node_path("DirectionalLight3D") var sun_light_path: NodePath


func _ready() -> void:
	_update_sun_disk()


func _process(_delta: float) -> void:
	_update_sun_disk()


func _update_sun_disk() -> void:
	# A headless editor has no rendered camera to project the sun through.
	if DisplayServer.get_name() == "headless":
		return
	if sky_material == null or sun_light_path.is_empty() or not is_inside_tree():
		return

	var sun_light := get_node_or_null(sun_light_path) as DirectionalLight3D
	var camera := get_viewport().get_camera_3d()
	if sun_light == null or camera == null:
		return
	if not sun_light.is_inside_tree() or not camera.is_inside_tree():
		return

	var viewport_size := get_viewport().get_visible_rect().size
	if viewport_size.x <= 0.0 or viewport_size.y <= 0.0:
		return

	# The direction toward the light is opposite to the direction of its rays.
	var direction := sun_light.global_transform.basis.z.normalized()
	var sun_point := camera.global_position + direction * 100.0
	var screen_position := Vector3(-10.0, -10.0, 0.0)

	if not camera.is_position_behind(sun_point):
		var pixel := camera.unproject_position(sun_point)
		screen_position = Vector3(
			pixel.x / viewport_size.x,
			pixel.y / viewport_size.y,
			0.0
		)

	# Supply the camera transform and projection so the sky can derive screen UVs
	# from EYEDIR. This also works with the Compatibility renderer's sky pass.
	var camera_basis := camera.global_transform.basis
	var projection := camera.get_camera_projection()
	var projection_scale := Vector3(projection.x.x, projection.y.y, 0.0)
	var screen_scale := Vector3(viewport_size.x / viewport_size.y, 1.0, 0.0)

	_set_parameter_if_changed(&"sun_screen_position", screen_position)
	_set_parameter_if_changed(&"sun_screen_scale", screen_scale)
	_set_parameter_if_changed(&"camera_right", camera_basis.x.normalized())
	_set_parameter_if_changed(&"camera_up", camera_basis.y.normalized())
	_set_parameter_if_changed(&"camera_back", camera_basis.z.normalized())
	_set_parameter_if_changed(&"camera_projection_scale", projection_scale)


func _set_parameter_if_changed(parameter: StringName, value: Variant) -> void:
	if sky_material.get_shader_parameter(parameter) != value:
		sky_material.set_shader_parameter(parameter, value)
