shader_type spatial;

render_mode unshaded, depth_draw_always, cull_disabled;

uniform vec4 grid_color : source_color = vec4(0.0, 0.3, 0.8, 1.0);
uniform vec4 background_color : source_color = vec4(0.02, 0.0, 0.05, 1.0);
uniform float line_thickness = 0.02;
uniform float grid_spacing = 2.5;
uniform float glow_strength = 1.3;

varying vec3 world_pos;

void vertex() {
	world_pos = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
}

float filtered_grid(float coord, float spacing, float thickness) {
	float coord_mod = mod(coord, spacing);
	float dist = min(coord_mod, spacing - coord_mod);
	float scale = fwidth(coord);
	return smoothstep(thickness + scale, thickness - scale, dist);
}

void fragment() {
	float grid_x = filtered_grid(world_pos.x, grid_spacing, line_thickness);
	float grid_z = filtered_grid(world_pos.z, grid_spacing, line_thickness);

	float line_intensity = max(grid_x, grid_z);
	float glow = pow(line_intensity, glow_strength);

	ALBEDO = mix(background_color.rgb, grid_color.rgb, glow);
	ALPHA = 1.0;
}
