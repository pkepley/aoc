CC= ghc
SRC := src
BIN := bin
 
SOURCES := $(wildcard $(SRC)/*.hs)
PROGS   := $(patsubst $(SRC)/%.hs, $(BIN)/%, $(SOURCES))

.PHONY: directory
.PHONY: clean

all: directory $(PROGS)

directory: 
	mkdir -p $(BIN) 

$(BIN)/%: $(SRC)/%.hs
	$(CC) $< -o $@ 

clean:
	rm $(SRC)/*.hi $(SRC)/*.o
