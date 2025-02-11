package ui

import "core:os"
import "core:fmt"
import rl "vendor:raylib"

import "../config"
import "../ui"
import "../utils"
import "../state"

Arena :: enum { initial, search, create }

active_screen: Arena = Arena.initial

Form :: struct {
    name: []rune
}

draw_screens :: proc() {
    switch ui.active_screen {
    case .initial:
        init_text()
    case .search:
        search_results()
    case .create:
        create_reg()
    case:
        fmt.assertf(true, "There is no screen with the option selected")
        os.exit(1)
    }
}

init_text :: proc() {
    using config
    intro: cstring = "What do you want to do?"
    options := []cstring{
        "1. Search a book",
        "2. Add a new book",
        "3. Exit"
    }

    pos: utils.Vector = {config.width / 4, config.heigth / 6}
    font_size: i32 = config.font_size * 2
    distance := font_size * 2
    color := rl.BLACK

    rl.DrawText(intro, pos.x, pos.y, font_size, color)
    option: i32 = 1
    for text in options {
        delta := distance * option + 1
        position: utils.Vector = {pos.x, pos.y + delta}
        ui.options_button(option, text, font_size, position, ui.onclick_options_button)
        option += 1
    }
}

search_results :: proc() {
    using config
    search_bar_width: f32 = 400
    search_bar_heigth: i32 = 40
    offset: f32 = 16
    position: utils.Vector = {
        x = config.width / 4,
        y = cast(i32)(config.heigth / 2 - search_bar_heigth / 2)
    }

    search_bar: rl.Rectangle = {
        x = cast(f32)position.x,
        y = cast(f32)position.y,
        width = search_bar_width,
        height = cast(f32)search_bar_heigth
    }

    rl.DrawRectangleRec(search_bar, rl.WHITE)
    rl.DrawRectangleLines(position.x - 1, position.y - 1, cast(i32)search_bar.width + 1, cast(i32)search_bar.height + 1, rl.BLACK)
}

create_reg :: proc() {
    using config
    margin_bottom: i32 = 10
    color: rl.Color = rl.BLACK

    input_size: utils.Vector = {
            x = 300,
            y = 40
    }

    name_label: cstring = "Name"
    name_field: utils.Vector = {
        x = config.width/2 - input_size.x/2,
        y = input_size.y/2
    }
    author_label: cstring = "Author"
    author_field: utils.Vector = {
        x = config.width/2 - input_size.x/2,
        y = input_size.y/2 * 2 + margin_bottom + input_size.y
    }

    input(
        name_label,
        name_field,
        input_size,
        margin_bottom,
        color,
        &state.form_state
    )

    input(
        author_label,
        author_field,
        input_size,
        margin_bottom,
        color,
        &state.form_state
    )
}
