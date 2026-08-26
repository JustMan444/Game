shader_type canvas_item;

// Ссылка на экран под шейдером
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

// Сила обесцвечивания (0.0 — оригинальные цвета игры, 1.0 — полный ч/б нуар)
uniform float desaturation_level : hint_range(0.0, 2.0) = 1.0;

// Сила безумия (0.0 — нуар, 1.0 — полный психодел и красный цвет)
uniform float insanity_level : hint_range(0.0, 2.0) = 0.0;

// Сила зернистости
uniform float grain_amount : hint_range(0.0, 2.0) = 0.3;

// Простейший генератор случайного шума
float noise(vec2 co) {
    return fract(sin(dot(co, vec2(12.9898, 78.233))) * 43758.5453);
}

void fragment() {
    // Получаем текущий цвет пикселя с экрана
    vec4 tex_color = texture(screen_texture, SCREEN_UV);
    
    // 1. ВЫЧИСЛЯЕМ ЧЕРНО-БЕЛЫЙ ВАРИАНТ (Формула светимости)
    float luma = dot(tex_color.rgb, vec3(0.299, 0.587, 0.114));
    vec3 bw_color = vec3(luma);
    
    // Смешиваем оригинальный цвет и ч/б в зависимости от ползунка серости
    vec3 base_gray_color = mix(tex_color.rgb, bw_color, desaturation_level);
    
    // 2. НАКЛАДЫВАЕМ КРАСНЫЙ ЭФФЕКТ БЕЗУМИЯ
    // Берем за основу нашу настроенную серость и уводим в кроваво-красный тон
    vec3 crazy_color = vec3(luma * 1.5, luma * 0.2, luma * 0.2);
    vec3 final_color = mix(base_gray_color, crazy_color, insanity_level);
    
    // 3. НАКЛАДЫВАЕМ ПЛЁНОЧНОЕ ЗЕРНО (зависит от времени TIME)
    float grain = (noise(UV + vec2(TIME, TIME)) - 0.5) * grain_amount;
    final_color += vec3(grain);
    
    COLOR = vec4(final_color, tex_color.a);
}
