shader_type spatial;

render_mode world_vertex_coords, depth_draw_alpha_prepass, cull_disabled, vertex_lighting;

uniform float CURVATURE;
uniform bool CURVATURE_ACTIVE;
uniform float CURVATURE_DISTANCE;

uniform sampler2D BASE_TEX;
uniform vec4 color;

void vertex() {
	if (CURVATURE_ACTIVE == true) {
		NORMAL = (WORLD_MATRIX * vec4(VERTEX, 0.0)).xyz;
		float dist = length(CAMERA_MATRIX[3].xyz - VERTEX) / CURVATURE_DISTANCE;
		VERTEX.y -= pow(dist, CURVATURE);
	}
}

void fragment() {
	vec4 tex = texture(BASE_TEX, UV);
	
	if (tex.a < 0.3) {
		discard;
	}
	
	ALBEDO = tex.rgb * color.rgb;
	ALPHA  = tex.a;
}
