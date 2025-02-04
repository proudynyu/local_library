package config

@(private)
DEFAULT_WIDTH :: 800
@(private)
DEFAULT_HEIGHT :: 600
@(private)
DEFAULT_TITLE :: "Library"

Config :: struct {
    width: i32,
    heigth: i32,
    title: cstring,
    font_size: i32
}

config: Config = {
    width = DEFAULT_WIDTH,
    heigth = DEFAULT_HEIGHT,
    title = DEFAULT_TITLE,
    font_size = 16
}
