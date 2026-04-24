shader_type canvas_item;

uniform float dissolve : hint_range(0.0, 1.0) = 0.0;
uniform float cells_per_unit = 20.0;
uniform float disp_strength = 0.15;
uniform vec2 global_offset = vec2(0.0, 0.0);

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453);
}

void fragment() {
    vec2 cell = floor(UV * cells_per_unit);
    float rand_val = hash(cell);

    // Удаляем ячейки, которые уже «растворились»
    if (rand_val < dissolve) {
        discard;
    }

    vec2 displ = global_offset;
    // Смещаем ячейки, которые на грани исчезновения
    if (rand_val < dissolve + 0.15) {
        vec2 rand_dir = vec2(hash(cell + vec2(73.3, 17.2)), hash(cell - vec2(53.7, 27.9)));
        rand_dir = rand_dir * 2.0 - 1.0;
        rand_dir = normalize(rand_dir);

        float factor = (dissolve - rand_val) / 0.15; // 0..1, чем ближе к границе, тем сильнее сдвиг
        displ += rand_dir * factor * disp_strength;
    }

    vec2 new_uv = UV + displ;
    COLOR = texture(TEXTURE, new_uv);

    // Плавное исчезновение только для приближающихся к границе ячеек,
    // и только когда dissolve > 0 (чтобы не трогать целый спрайт)
    if (dissolve > 0.0) {
        float fade = 1.0 - smoothstep(dissolve, dissolve + 0.15, rand_val);
        COLOR.a *= fade;
    }
}