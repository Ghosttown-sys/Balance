shader_type canvas_item;

uniform vec4 start_color : source_color = vec4(1.0);
uniform vec4 end_color : source_color = vec4(0.0);
uniform float speed = 1.0;
uniform float start_offset = 0.0;

	
void fragment() {
	float pulse_progress = (sin((TIME * speed) + start_offset) * 0.5) + 0.5;
	vec4 pulse_color = mix(start_color,end_color,pulse_progress);
	
	COLOR.rgb = pulse_color.rgb;
	COLOR.a *= pulse_color.a;
}