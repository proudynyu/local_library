package ui

import "core:os"
import "core:strings"
import "core:fmt"
import "core:unicode/utf8"
import rl "vendor:raylib"

import "../books"
import "../utils"
import "../state"
import "../config"
import db "../database"

onclick_options_button :: proc(option: i32) {
    if option == 1 {
        active_screen = Arena.search
        return
    }

    if option == 2 {
        active_screen = Arena.create
        return
    }

    os.exit(0)
}

options_button :: proc(
    option: i32,
    text: cstring, 
    font_size: i32, 
    position: utils.Vector,
    onclick: proc(option: i32)
) {
    string_len := rl.MeasureText(text, font_size)
    distance := font_size / 2

    rect: rl.Rectangle = {
        x =         cast(f32)position.x,
        y =         cast(f32)position.y,
        width =     cast(f32)(string_len + distance),
        height =    cast(f32)(font_size + distance)
    }


    button_color := rl.BLACK
    mouse_position := rl.GetMousePosition()
    if rl.CheckCollisionPointRec(mouse_position, rect) {
        button_color = rl.RED

        if rl.IsMouseButtonPressed(.LEFT) {
            onclick(option)
        }
    }

    rl.DrawRectangleRec(rect, button_color)
    rl.DrawRectangleLines(position.x - 1, position.y - 1, string_len + distance + 1, font_size + distance + 1, rl.LIGHTGRAY)
    rl.DrawText(text, position.x + distance/2, position.y + distance/2, font_size, rl.WHITE)
}

back_button :: proc() {
    color := rl.BLACK
    thickeness: f32 = 2
    offset: i32 = 5
    font_size: i32 = 16
    text: cstring = "Voltar"
    string_len := rl.MeasureText(text, font_size)
    distance := font_size / 2

    rect: rl.Rectangle = {
        x = 10,
        y = 10,
        width =     cast(f32)(string_len + distance),
        height =    cast(f32)(font_size + distance)
    }

    rl.DrawRectangleRec(rect, rl.WHITE)
    rl.DrawRectangleLinesEx(rect, thickeness, color)
    rl.DrawText(text,  (cast(i32)rect.x) + offset, (cast(i32)rect.y) + offset, font_size, color)

    mouse_position := rl.GetMousePosition()
    if rl.CheckCollisionPointRec(mouse_position, rect) {
        if rl.IsMouseButtonPressed(.LEFT) {
            active_screen = Arena.initial
            state.form_state = {}
        }
    }
}

create_reg_button :: proc() {
    using config
    color := rl.BLACK
    thickeness: f32 = 2
    offset: i32 = 5
    font_size: i32 = 16
    text: cstring = "Registrar"
    string_len := rl.MeasureText(text, font_size)
    distance := font_size / 2

    rect: rl.Rectangle = {
        x = cast(f32)(config.width - (string_len + distance) - 10),
        y = cast(f32)(config.heigth - 40),
        width =     cast(f32)(string_len + distance),
        height =    cast(f32)(font_size + distance)
    }

    rl.DrawRectangleRec(rect, rl.WHITE)
    rl.DrawRectangleLinesEx(rect, thickeness, color)
    rl.DrawText(text,  (cast(i32)rect.x) + offset, (cast(i32)rect.y) + offset, font_size, color)

    mouse_position := rl.GetMousePosition()
    if rl.CheckCollisionPointRec(mouse_position, rect) {
        if rl.IsMouseButtonPressed(.LEFT) {
            if len(state.form_state.name) <= 0 || len(state.form_state.author) <= 0 {
                return
            }
            register()
            active_screen = Arena.initial
            state.form_state = {}
        }
    }
}

register :: proc() {
    name_v := utf8.runes_to_string(state.form_state.name[:])
    author_v := utf8.runes_to_string(state.form_state.author[:])
    new_book := books.create_new_book(name_v, "1", author_v)
    book_registry := books.book_registry(new_book)

    response := db.create_registry(state.database, book_registry)
    if !response {
        fmt.println("An problem has occured trying to save the new book registry")
    }

    fmt.println("book was saved with success!")
}
