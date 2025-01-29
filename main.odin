package main

import rl "vendor:raylib"

WIDTH :: 800
HEIGHT :: 600
TITLE :: "Library"

Arena :: struct {
    initial_screen: bool,
    search_screen: bool,
    create_screen: bool,
}

init_text :: proc() {
}

search_bar :: proc() {
}

draw_screens :: proc(arena: ^Arena) {
}

main :: proc() {
    rl.InitWindow(WIDTH, HEIGHT, TITLE)
    defer rl.CloseWindow()

    arena: Arena = {
        initial_screen = true,
        search_screen = false,
        create_screen = false
    }

    rl.SetTargetFPS(60)
    for !rl.WindowShouldClose() {
        rl.BeginDrawing()
        defer rl.EndDrawing()

        {
            draw_screens(&arena)
        }

        rl.ClearBackground(rl.WHITE)
    }
}
