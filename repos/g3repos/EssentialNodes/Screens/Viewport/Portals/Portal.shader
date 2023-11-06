shader_type spatial;
// Here, I don't want to cast shadows on the portal: I want a crisp view of the other side of the world. So I turn off any shading on this surface with the unshaded render mode.
render_mode unshaded;

// We assign a viewport texture targeting the portal viewport to this property.
uniform sampler2D portal_texture;


void fragment() {
	// Godot provides a property that directly maps the surface the mesh takes on the screen.
	// We use it to sample our texture, effectively cropping the rendered view to the portal's mesh.
	vec4 color = texture(portal_texture, SCREEN_UV);
	// And we output the pixels sampled from our portal viewport onto the screen.
	ALBEDO = color.rgb;
}
