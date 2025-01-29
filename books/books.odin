package books

import "core:strings"
import "core:bytes"

Book :: struct {
    row:    string,
    name:   string,
    author: string
}

create_new_book :: proc(name: string, row: string, author: string) -> ^Book {
    book := new(Book)
    book.row = row
    book.name = name
    book.author = author

    return book
}

book_registry :: proc(book: ^Book) -> []byte {
    row := book.row
    name: = book.name
    author: = book.author

    arr := []string{row, name, author}
    reg := strings.join(arr, ",")
    registry := strings.join([]string{reg, "\n"}, "")
    return transmute([]byte)reg
}
