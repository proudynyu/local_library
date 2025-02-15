package state

import "core:os"

MAX_INPUT_CHAR :: 20

Form :: struct {
    name: [dynamic]rune,
    name_field_active: bool,
    author: [dynamic]rune,
    author_field_active: bool
}

form_state: Form = {
    name = {},
    name_field_active = false,
    author = {},
    author_field_active = false,
}

database: os.Handle = {}
