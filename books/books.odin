package books

Book :: struct {
    row:    int,
    name:   string,
    author: string
}

create_new_book :: proc(name: string, row: int, author: string) -> ^Book {
    book := new(Book)
    book.row = row
    book.name = name
    book.author = author

    return book
}
