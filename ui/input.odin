package ui

import "core:unicode/utf8"
import "core:strings"
import "core:fmt"
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
    form_state_name: ^[dynamic]rune,
    form_state_activate: ^bool
) {
    using config
    using utils
    text_len := len(form_state_name)
    padding: i32 = 8

    container: rl.Rectangle = {
        x =         cast(f32)position.x,
        y =         cast(f32)position.y,
        width =     cast(f32)size.x,
        height =    cast(f32)size.y + cast(f32)(config.font_size + padding)
    }

    input_label: Vector = {
        x = cast(i32)container.x,
        y = cast(i32)container.y
    }

    input_field: rl.Rectangle = {
        x =         container.x,
        y =         container.y + cast(f32)(config.font_size + padding),
        width =     cast(f32)size.x,
        height =    cast(f32)size.y
    }

    if form_state_activate^ {
        key := rl.GetCharPressed()
        for key > 0 {
            if text_len < state.MAX_INPUT_CHAR && key >= 32 && key <= 126 {
                append_elem(form_state_name, key)
            }
            key = rl.GetCharPressed()

        }

        if rl.GetKeyPressed() == rl.KeyboardKey.BACKSPACE {
            pop_safe(form_state_name)
        }
    }

    
    mouse_position := rl.GetMousePosition()
    if rl.CheckCollisionPointRec(mouse_position, input_field) {
        if rl.IsMouseButtonPressed(.LEFT) {
            form_state_activate^ = true
        }
    } else if !rl.CheckCollisionPointRec(mouse_position, input_field) && rl.IsMouseButtonPressed(.LEFT) {
        form_state_activate^ = false
    }

    rl.DrawText(label, input_label.x, input_label.y, config.font_size, rl.BLACK)
    rl.DrawRectangleRec(input_field, rl.WHITE)

    r := utf8.runes_to_string(form_state_name[:])
    t := strings.clone_to_cstring(r)
    rl.DrawText(t, cast(i32)input_field.x + padding, cast(i32)input_field.y + padding, cast(i32)input_field.height - padding, color)
}
