from intcode_computer import intcode_computer
import numpy as np
import matplotlib.pyplot as plt
from matplotlib.colors import ListedColormap

def get_pgm_input(file_location):
    f = open(file_location)
    contents = [int(i) for i in ''.join(list(f)).split(',')]
    f.close()
    return contents

class arcade_machine:
    def __init__(self, pgm):
        self.pgm = pgm[:]
        self.ic  = intcode_computer(pgm)
        self.ic.run()
        self.pixels = dict()
        self.tile_instructions = []
        self.draw()
        
    def draw(self):
        instr  = self.ic.outputs
        n_instr = int(len(instr)/3)
        self.tile_instructions = [(instr[3*k], instr[3*k+1], instr[3*k+2])
                                  for k in range(n_instr)]

        for instr in self.tile_instructions:
            x, y, tile_id = instr
            self.pixels[(x,y)] = tile_id

    def matrix_repr(self):
        self.draw()

        xs  = [x for x,_ in self.pixels.keys()]
        ys  = [y for _,y in self.pixels.keys()]

        xs_min, xs_max = max(min(xs),0), max(xs)
        ys_min, ys_max = max(min(ys),0), max(ys)

        nx = (xs_max - xs_min) + 1
        ny = (ys_max - ys_min) + 1

        matr = np.zeros((ny, nx), dtype=np.int)

        for x, y in self.pixels.keys():
            j = x - xs_min
            i = y - ys_min
            if x >= 0 and y >=0:
                matr[i, j] = self.pixels[(x,y)]

        return matr
        
if __name__ == '__main__':
    pgm = get_pgm_input('./input/input_day_13.txt')
    am = arcade_machine(pgm)    

    s1 = len([k for k in am.pixels.keys() if am.pixels[k] == 2])
    print("Solution to part 1: {}".format(s1))
    
