shader_type canvas_item;
render_mode unshaded, skip_vertex_transform;

uniform vec3 params = vec3(5.0, 1.8, 0.3);
uniform vec2 position = vec2(0.5, 0.5);
uniform float elapsed_time = 0;

void fragment() {
	float ratio = SCREEN_PIXEL_SIZE.x / SCREEN_PIXEL_SIZE.y;
	float current_time = elapsed_time - params.z;
	vec2 texCoord = FRAGCOORD.xy / (1.0 / SCREEN_PIXEL_SIZE.xy);
	float dist = distance(texCoord / vec2(ratio, 1), position / vec2(ratio, 1));
	
	vec4 color = textureLod(SCREEN_TEXTURE, texCoord, 0.0);
    
	//Only distort the pixels within the parameter distance from the centre
	if ((dist < ((current_time) + (params.z))) && 
		(dist >= ((current_time) - (params.z)))) 
	{
        //The pixel offset distance based on the input parameters
		float diff = (dist - current_time); 
		float scaled_diff = (1.0 - pow(abs(diff * params.x), params.y)); 
		float diff_time = (diff  * scaled_diff);
        
        //The direction of the distortion
		vec2 diffTexCoord = normalize(texCoord - position);         
        
        //Perform the distortion and reduce the effect over time
		texCoord += ((diffTexCoord * diff_time) / (current_time * dist * 40.0));
		color = textureLod(SCREEN_TEXTURE, texCoord, 0.0);
        
        //Blow out the color and reduce the effect over time
		color += (color * scaled_diff) / (current_time * dist * 40.0);
	}
    
	COLOR = color; 
}