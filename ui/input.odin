package ui

import "base:builtin"
import "core:unicode/utf8"
import "core:strings"
import rl "vendor:raylib"

import "../utils"
import "../config"

max_input_char :: 20

input :: proc(
    label: cstring,
    position: utils.Vector,
    size: utils.Vector,
    margin_bottom: i32,
    color: rl.Color
) {
    using config
    text := make([]rune, max_input_char)
    text_len := len(text)
    is_active := true

    rect: rl.Rectangle = {
        x =         cast(f32)position.x,
        y =         cast(f32)position.y,
        width =     cast(f32)size.x,
        height =    cast(f32)size.y
    }

    if is_active {
        key := rl.GetCharPressed()
        for key > 0 {
            if text_len < max_input_char && key >= 32 && key <= 126 {
                text[text_len] = key
                text_len += 1
            }
            key = rl.GetCharPressed()

            if rl.GetKeyPressed() == rl.KeyboardKey.BACKSPACE {
                text_len -= 1
            }
        }

    }

    
    mouse_position := rl.GetMousePosition()
    if rl.CheckCollisionPointRec(mouse_position, rect) {
        if rl.IsMouseButtonPressed(.LEFT) {
            is_active = true
        }
    } else if !rl.CheckCollisionPointRec(mouse_position, rect) && rl.IsMouseButtonPressed(.LEFT) {
        is_active = false
    }

    rl.DrawRectangleRec(rect, rl.WHITE)
    t := strings.clone_to_cstring(utf8.runes_to_string(text))
    rl.DrawText(t, cast(i32)rect.x, cast(i32)rect.y, config.font_size, color)
}
