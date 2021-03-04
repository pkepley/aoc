CC= ghc
SRC := src
BIN := bin
 
SOURCES := $(wildcard $(SRC)/*.hs)
OBJECTS := $(wildcard $(SRC)/*.hi $(SRC)/*.o)
PROGS   := $(patsubst $(SRC)/%.hs, $(BIN)/%, $(SOURCES))

.PHONY: directory
.PHONY: clean

all: directory $(PROGS)

directory: 
	mkdir -p $(BIN) 

$(BIN)/%: $(SRC)/%.hs
	$(CC) $< -o $@ 

clean:
	rm $(OBJECTS)
