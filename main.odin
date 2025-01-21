package main

import "core:fmt"
import "core:os"

import "database"
import "books"

database_path :: "db.txt"

main :: proc() {
    database.create_database(database_path)
    file := database.read_database(database_path)
    defer os.close(file)

    new_book := books.create_new_book("test", "1", "author")
    str_book := books.book_registry(new_book)

    database.create_registry(file, str_book)

    // show options
        // 1. add new book
        // 2. search book
        // 3. delete book
}
