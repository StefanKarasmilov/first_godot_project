shader_type canvas_item;

// Para pasar variables desde fuera
uniform float lerp_percent: hint_range(0.0, 1.0);


void fragment() {
	// Called for every pixel the material is visible on.
	// TEXTURE es la textura que está renderizando ahora mismo
	// UV es la representación del Vector2 del pixel (es como las coordenadas del pixel)
	vec4 texture_color = texture(TEXTURE, UV);
	vec4 final_color = mix(texture_color, vec4(1.0, 1.0, 1.0, texture_color.a), lerp_percent);
	COLOR = final_color;
	
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
