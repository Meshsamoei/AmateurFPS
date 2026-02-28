shader_type spatial;
render_mode unshaded;

uniform sampler2D flag_texture;
uniform float wave_speed = 3.0;
uniform float wave_strength = 0.1;
uniform float wave_frequency = 5.0;

void vertex() {
    // Create a sine wave based on UV position and time
    // UV.x = horizontal position (0 at flagpole, 1 at free end)
    // UV.y = vertical position (0 at top, 1 at bottom)
    
    // Wave moves from left to right
    float wave = sin(UV.x * wave_frequency - TIME * wave_speed);
    
    // Amplify wave at the free end (UV.x close to 1) and reduce at flagpole (UV.x close to 0)
    float amplitude = wave_strength * UV.x;
    
    // Apply wave to vertex position (X axis for horizontal wave, Z for depth)
    VERTEX.x += wave * amplitude;
    
    // Add a subtle vertical wave for more realism
    float vertical_wave = sin(UV.y * 3.0 - TIME * 2.0) * 0.02 * UV.x;
    VERTEX.y += vertical_wave;
}

void fragment() {
    // Sample the flag texture (your Kenyan flag image)
    ALBEDO = texture(flag_texture, UV).rgb;
}