package main

import "core:fmt"
import "core:os"
import "core:bytes"

import rl "vendor:raylib"

import config "config"
import "ui"
import "utils"

main :: proc() {
    using config
    rl.InitWindow(config.width, config.heigth, config.title)
    defer rl.CloseWindow()

    rl.SetTargetFPS(60)
    for !rl.WindowShouldClose() {
        rl.BeginDrawing()
        defer rl.EndDrawing()

        {
            ui.draw_screens()
            if ui.active_screen != ui.Arena.initial {
                ui.back_button()
            }
        }

        rl.ClearBackground(rl.GRAY)
    }
}
