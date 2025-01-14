package database

import "core:os"

read_database :: proc(database_name: string) -> string {
    data, ok := os.read_entire_file(filepath, context.allocator)
    if !ok {
        // create file
    }
    defer delete(data, context.allocator)

    it := string(data)
    for line in string.split_lines_iterator(&it) {
    }
}

create_database :: proc(filepath: string) -> string {
}
