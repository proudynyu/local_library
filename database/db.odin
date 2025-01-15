package database

import "core:fmt"
import "core:os"
import "core:path/filepath"

create_database :: proc(path: string) {
    file, err := os.open(path)
    if err != nil {
        fmt.println("Failed to open file: ", path)
        return
    }
    defer os.close(file)
}
