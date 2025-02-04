package config

DEFAULT_WIDTH :: 800
DEFAULT_HEIGHT :: 600
DEFAULT_TITLE :: "Library"

Config :: struct {
    width: i32,
    heigth: i32,
    title: cstring
}

config: Config = {
    width = DEFAULT_WIDTH,
    heigth = DEFAULT_HEIGHT,
    title = DEFAULT_TITLE
}
