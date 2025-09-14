shader_type canvas_item;

uniform vec2 mask_center = vec2(0.5, 0.5);
uniform vec2 mask_size = vec2(0.2, 0.2);

void fragment() {
    vec2 uv = UV;

    // local UV relative to mask rectangle
    vec2 local_uv = (uv - mask_center + mask_size / 2.0) / mask_size;

    // check if inside the rectangle
    if (local_uv.x >= 0.0 && local_uv.x <= 1.0 && local_uv.y >= 0.0 && local_uv.y <= 1.0) {
        discard; // make transparent
    }

    COLOR = vec4(0.0, 0.0, 0.0, 0.7); // overlay color
}
