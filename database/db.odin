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
    file, err := os.open(path)
    if err != nil {
        fmt.println("Was not possible to read the database: ", path)
        os.exit(1)
    }
    return file
}

find_item_on_database :: proc(db: os.Handle, name: string) -> string {
    readable, err := os.read_entire_file_from_handle_or_err(db)
    if err != nil {
        fmt.println("Was not possible to open the database")
        os.exit(1)
    }

    file := string(readable)
    lines: []string = strings.split(file, "\n")

    for line in lines {
        splitted := strings.split(line, ",")[1]
        if strings.contains(splitted, name) {
            return line
        }
    }

    return ""
}

create_registry :: proc(db: os.Handle, book: []byte) -> bool {
    _, err := os.write(db, book)
    if err != nil {
        fmt.println("Could not write data to the database")
        os.exit(1)
    }
    return true
}
