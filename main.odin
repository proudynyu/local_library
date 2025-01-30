package main

import "core:fmt"
import "core:os"
import "core:bytes"

import rl "vendor:raylib"

WIDTH :: 800
HEIGHT :: 600
TITLE :: "Library"

Vector :: struct {
    x: i32,
    y: i32
}

Arena :: enum { initial, search, create }
Screen :: struct { active: Arena }

screen: Screen = {active = Arena.initial}

create_button :: proc(
    option: i32,
    text: cstring, 
    font_size: i32, 
    position: Vector,
    selected: ^i32
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
            selected^ = option
        }
    }

    rl.DrawRectangleRec(rect, button_color)
    rl.DrawRectangleLines(position.x - 1, position.y - 1, string_len + distance + 1, font_size + distance + 1, rl.LIGHTGRAY)
    rl.DrawText(text, position.x + distance/2, position.y + distance/2, font_size, rl.WHITE)
}

init_text :: proc() {
    intro: cstring = "What do you want to do?"
    options := []cstring{
        "1. Search a book",
        "2. Add a new book",
        "3. Exit"
    }

    pos: Vector = {WIDTH / 4, HEIGHT / 6}
    font_size: i32 = 32
    distance := font_size * 2
    color := rl.BLACK

    rl.DrawText(intro, pos.x, pos.y, font_size, color)
    option: i32 = 1
    selected: i32 = 1
    for text in options {
        delta := distance * option + 1
        position: Vector = {pos.x, pos.y + delta}
        create_button(option, text, font_size, position, &selected)
        option += 1
    }

    if selected == 1 {
        screen.active = Arena.search
    } 
    if selected == 2 {
        screen.active = Arena.create
    } 
    if selected == 3{
        screen.active = Arena.initial
    }
}

search_results :: proc() {
}

create_reg :: proc() {
}

draw_screens :: proc() {
    switch screen.active {
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

main :: proc() {
    rl.InitWindow(WIDTH, HEIGHT, TITLE)
    defer rl.CloseWindow()

    rl.SetTargetFPS(60)
    for !rl.WindowShouldClose() {
        rl.BeginDrawing()
        defer rl.EndDrawing()


        {
            draw_screens()
        }

        rl.ClearBackground(rl.GRAY)
    }
}
