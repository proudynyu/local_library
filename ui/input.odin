package ui

import rl "vendor:raylib"

import "../utils"

registry_field :: proc(
    label: cstring,
    position: utils.Vector,
    size: utils.Vector,
    margin_bottom: i32
) {
    rect: rl.Rectangle = {
        x =         cast(f32)position.x,
        y =         cast(f32)position.y,
        width =     cast(f32)size.x,
        height =    cast(f32)size.y
    }
}
