package ui

import rl "vendor:raylib"

import "../utils"
import "../config"
import "../state"

input :: proc(
    label: cstring,
    position: utils.Vector,
    size: utils.Vector,
    margin_bottom: i32,
    color: rl.Color,
    form_state: ^state.Form
) {
    using config
    text_len := len(form_state.name)
    padding: i32 = 1

    rect: rl.Rectangle = {
        x =         cast(f32)position.x,
        y =         cast(f32)position.y,
        width =     cast(f32)size.x,
        height =    cast(f32)size.y
    }

    if state.form_state.name_field_active {
        key := rl.GetCharPressed()
        for key > 0 {
            if text_len < state.MAX_INPUT_CHAR && key >= 32 && key <= 126 {
                append_elem(&form_state.name, key)
            }
            key = rl.GetCharPressed()

            if rl.GetKeyPressed() == rl.KeyboardKey.BACKSPACE {
                pop(&form_state.name)
            }
        }
    }

    
    mouse_position := rl.GetMousePosition()
    if rl.CheckCollisionPointRec(mouse_position, rect) {
        if rl.IsMouseButtonPressed(.LEFT) {
            state.form_state.name_field_active = true
        }
    } else if !rl.CheckCollisionPointRec(mouse_position, rect) && rl.IsMouseButtonPressed(.LEFT) {
        state.form_state.name_field_active = false
    }

    rl.DrawRectangleRec(rect, rl.WHITE)
    // need to transform the [dynamic]rune to string
    // r := utf8.runes_to_string(form_state.name)
    // t := strings.clone_to_cstring(r)
    // rl.DrawText(t, cast(i32)rect.x + padding, cast(i32)rect.y + padding, config.font_size, color)
}
