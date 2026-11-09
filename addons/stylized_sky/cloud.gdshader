shader_type spatial;

render_mode blend_mix, depth_draw_opaque, depth_test_default, cull_back, diffuse_lambert, specular_schlick_ggx;

void vertex() {
	// Fixed-Y billboard, matching the VisualShader billboard node.
	mat4 billboard = VIEW_MATRIX * mat4(
		INV_VIEW_MATRIX[0],
		MODEL_MATRIX[1],
		vec4(normalize(cross(INV_VIEW_MATRIX[0].xyz, MODEL_MATRIX[1].xyz)), 0.0),
		MODEL_MATRIX[3]
	);

	// The visual graph does not preserve the mesh's scale.
	MODELVIEW_MATRIX = billboard * mat4(
		vec4(1.0, 0.0, 0.0, 0.0),
		vec4(0.0, 1.0 / length(MODEL_MATRIX[1].xyz), 0.0, 0.0),
		vec4(0.0, 0.0, 1.0, 0.0),
		vec4(0.0, 0.0, 0.0, 1.0)
	);
}

void fragment() {
	vec2 cloud_uv = (UV - vec2(0.5, 0.5)) * vec2(2.0, 1.0);

	// Signed distances from the surfaces of the three original circles.
	float left = distance(cloud_uv, vec2(-0.35, 0.0)) - 0.28;
	float middle = distance(cloud_uv, vec2(0.0, 0.12)) - 0.38;
	float right = distance(cloud_uv, vec2(0.35, 0.0)) - 0.27;

	float cloud_distance = min(min(left, middle), right);
	float cloud_mask = 1.0 - smoothstep(-0.01, 0.01, cloud_distance);

	ALBEDO = vec3(1.0);
	EMISSION = vec3(1.0);
	ALPHA = cloud_mask;
}
