package cmd

import "core:os"
import "core:fmt"
import "core:bytes"
import "core:strings"

import "../database"
import "../books"

@(private)
database_path :: "db.txt"

search :: proc(file: ^os.Handle) -> string {
    fmt.println("What is the name or author that you are looking?")

    buffer: [16]byte
    n, err := os.read(os.stdin, buffer[:])
    fmt.assertf(err == nil, "Failed to read data")
    fmt.println(buffer[:n])

    b: bytes.Buffer
    bytes.buffer_init(&b, buffer[:n])
    value := strings.trim_space(bytes.buffer_to_string(&b))
    defer bytes.buffer_destroy(&b)
    defer delete(value)

    item := database.find_item_on_database(file^, value)
    return item
}

create :: proc(file: ^os.Handle) -> bool {
    fmt.println("What is the name of the book?")
    book_buffer: [256]byte
    book_n, book_err := os.read(os.stdin, book_buffer[:])
    fmt.assertf(book_err == nil, "was not possible to read the book name")

    fmt.println("What is the author?")
    author_buffer: [256]byte
    author_n, author_err := os.read(os.stdin, author_buffer[:])
    fmt.assertf(author_err == nil, "was not possible to read the book author")

    fmt.println("What is the row?")
    row_buffer: [256]byte
    row_n, row_err := os.read(os.stdin, row_buffer[:])
    fmt.assertf(row_err == nil, "was not possible to read the book row")

    name_v := strings.trim_space(transmute(string)book_buffer[:book_n])
    author_v := strings.trim_space(transmute(string)author_buffer[:author_n])
    row_v := strings.trim_space(transmute(string)row_buffer[:row_n])

    new_book := books.create_new_book(name_v, row_v, author_v)
    str_book := books.book_registry(new_book)

    success := database.create_registry(file^, str_book)

    return success
}

loop :: proc() {
    database.create_database(database_path)
    file := database.read_database(database_path)

    for {
        os.seek(file, 0, 0)
        fmt.println("What do you want to do?")
        fmt.println("1. Search a book")
        fmt.println("2. Add a new book")
        fmt.println("3. Exit")

        buffer: [16]byte
        n, err := os.read(os.stdin, buffer[:])
        fmt.assertf(err == nil, "Failed to read data")

        b: bytes.Buffer
        bytes.buffer_init(&b, buffer[:n])
        value := strings.trim_space(bytes.buffer_to_string(&b))

        options := []string{"1","2"}

        switch value {
        case "1":
            book := search(&file)
            fmt.println(book)
        case "2":
            success := create(&file)
            if !success {
                fmt.println("A problem occur when saving the book to the db")
                os.close(1)
                os.exit(1)
            }
        case "3":
            fmt.println("See you")
            defer os.close(file)
            return
        case:
            fmt.println("This answer is not valid!")
        }
    }

}
