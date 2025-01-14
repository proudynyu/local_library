package books

Book :: struct {
    name:   string,
    row:    int,
    author: string
}

create_new_book :: proc(name: string, row, int, author: string) -> ^Book {
    book := new(Book)
    book.name = name
    book.row = row
    book.author = author

    return book
}
