package database

import "core:fmt"
import "core:os"
import "core:path/filepath"
import "core:bytes"
import "core:strings"

import "../books"

// database for now will be just a txt file
create_database :: proc(path: string) {
    file, err := os.open(path)
    defer os.close(file)
    if err != nil {
        fmt.println("File does not exists: ", path)
        fmt.println("Starting the creation of one...")

        buff: bytes.Buffer
        defer bytes.buffer_destroy(&buff)
        bytes.buffer_init_string(&buff, "row,name,author\n")
        werr := os.write_entire_file_or_err(path, bytes.buffer_to_bytes(&buff))
        if werr != nil {
            fmt.println("An error has occured creating the file: ", path)
            os.exit(1)
        }
        fmt.println("file created succesfully")
        return
    }

    fmt.println("Database is already created")
    return
}

read_database :: proc(path: string) -> os.Handle {
    mode: int
    when ODIN_OS != .Windows {
        mode = os.S_IRUSR|os.S_IWUSR|os.S_IRGRP|os.S_IROTH
    }
    flag := os.O_APPEND|os.O_RDWR
    file, err := os.open(path, flag, mode)
    fmt.assertf(err == nil, "Was not possible to read the database: %v", err)
    return file
}

find_item_on_database :: proc(db: os.Handle, name: string) -> string {
    fmt.println(db)
    readable, err := os.read_entire_file_from_handle_or_err(db)
    fmt.assertf(err == nil, "Was not possible to open the database: %v", err)

    file := string(readable)
    lines: []string = strings.split(file, "\n")
    defer delete(file)
    defer delete(lines)

    for line in lines {
        has_sub := strings.contains(line, name)
        fmt.println("line: ", line, "has_sub: ", has_sub, "name: ", name)
        if has_sub {
            return line
        }
    }

    return ""
}

create_registry :: proc(db: os.Handle, book: []byte) -> bool {
    fmt.assertf(db > 0, "Invalid database handle passed to create_registry")
    _, err := os.write(db, book)
    fmt.assertf(err == nil, "Error writing data to database: %v", err)
    return true
}
