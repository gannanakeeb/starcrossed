shader_type canvas_item;

// Chroma Key Settings
uniform vec4 key_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float similarity : hint_range(0.0, 1.0) = 0.4;
uniform float smoothness : hint_range(0.0, 1.0) = 0.08;

// Edge Removal Settings
uniform float edge_strength : hint_range(0.0, 1.0) = 0.5; // How much of the edges to target
uniform float edge_softness : hint_range(0.0, 1.0) = 0.2;

void fragment() {
    vec4 video_color = texture(TEXTURE, UV);

    // 1. Basic Chroma Key Math
    float diff = distance(video_color.rgb, key_color.rgb);
    float chroma_mask = smoothstep(similarity, similarity + smoothness, diff);

    // 2. Edge Detection Math (Vignette)
    // UV goes from 0.0 to 1.0. We calculate distance from the center (0.5, 0.5)
    vec2 center_dist = abs(UV - vec2(0.5));
    float edge_mask = 1.0 - smoothstep(edge_strength, edge_strength + edge_softness, max(center_dist.x, center_dist.y));

    // 3. Combine them
    // If it's white AND near the edge, it fades. If it's white in the middle, it stays.
    float final_alpha = mix(chroma_mask, 1.0, edge_mask);

    // Apply a black background behind the transparency
    vec3 black_bg = vec3(0.0, 0.0, 0.0);
    COLOR = vec4(mix(black_bg, video_color.rgb, final_alpha), video_color.a);
}