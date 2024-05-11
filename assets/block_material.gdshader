shader_type spatial;

render_mode unshaded;

uniform sampler2D tex : filter_nearest;
const mat3 color_transform = mat3(vec3(.1,.1,.05), vec3(0,0,0), vec3(0,0,0));

uniform bool round_earth = false;

void vertex() {
	if (round_earth) {
		vec3 offset = VERTEX - CAMERA_POSITION_WORLD;
		offset.x -= offset.x * 0.1;
		offset.z -= offset.z * 0.1;
		offset.y -= offset.x * offset.x * 0.01 + offset.z * offset.z * 0.01;
		VERTEX = CAMERA_POSITION_WORLD + offset;
	} else {}
}

void fragment() {
	vec4 color = texture(tex, UV);
	ALBEDO = color.xyz * color.xyz;
	vec4 wn = INV_VIEW_MATRIX * vec4(NORMAL, 0);
	ALBEDO += ((color_transform * 1.) * wn.xyz);
}