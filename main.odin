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

Arena :: enum {
    initial,
    search,
    create
}

create_button :: proc(
    text: cstring, 
    font_size: i32, 
    position: Vector
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
    count: i32 = 1
    for text in options {
        delta := distance * count
        position: Vector = {pos.x, pos.y + delta}
        create_button(text, font_size, position)
        count += 1
    }

    // buffer: [16]byte
    // n, err := os.read(os.stdin, buffer[:])
    // fmt.assertf(err == nil, "Failed to read data")
    //
    // b: bytes.Buffer
    // bytes.buffer_init(&b, buffer[:n])
    // value := strings.trim_space(bytes.buffer_to_string(&b))
    //
    // options := []string{"1","2"}
    //
    //     switch value {
    //     case "1":
    //         // book := search(&file)
    //         fmt.println(book)
    //     case "2":
    //         // success := create(&file)
    //         if !success {
    //             fmt.println("A problem occur when saving the book to the db")
    //             os.close(1)
    //             os.exit(1)
    //         }
    //     case "3":
    //         fmt.println("See you")
    //         // defer os.close(file)
    //         return
    //     case:
    //         fmt.println("This answer is not valid!")
    //     }
    //
}

search_results :: proc() {
}

create_reg :: proc() {
}

draw_screens :: proc(arena: Arena) {
    switch arena {
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

    arena: Arena 
    rl.SetTargetFPS(60)
    for !rl.WindowShouldClose() {
        rl.BeginDrawing()
        defer rl.EndDrawing()


        {
            draw_screens(arena)
        }

        rl.ClearBackground(rl.GRAY)
    }
}
