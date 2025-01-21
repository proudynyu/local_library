FILENAME="library_odin.out"

default: main.odin
	odin build . -out:$(FILENAME)
	./$(FILENAME)
