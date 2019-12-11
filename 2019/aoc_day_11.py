from intcode_computer import intcode_computer
from intcode_computer import zeroaccess_dict

def get_pgm_input(file_location):
    f = open(file_location)
    contents = [int(i) for i in ''.join(list(f)).split(',')]
    f.close()
    return contents

class robot:
    def __init__(self, pgm):
        self.pgm  = pgm[:]
        self.pos  = (0,0)
        self.vect = (0, 1)
        self.ic   = intcode_computer(pgm)
        self.painted_cells = zeroaccess_dict()
        
    def current_cell_color(self):
        return self.painted_cells[self.pos]
        
    def paint_current_cell(self, color):
        self.painted_cells[self.pos] = color

    def turn(self, turn_param):
        if turn_param == 0:
            self.turn_left()
            
        elif turn_param == 1:
            self.turn_right()
        
    def turn_left(self):
        self.vect = (-self.vect[1], self.vect[0])

    def turn_right(self):
        self.vect = (self.vect[1], -self.vect[0])

    def move_forward(self):
        self.pos = (self.pos[0] + self.vect[0], self.pos[1] + self.vect[1])

    def run(self):
        while self.ic.running:
            # Provied the current cell color as instruction to ic
            self.ic.run([self.current_cell_color()])

            # Computer outputs cell color and turn param
            paint_color = self.ic.outputs[-2]
            turn_param  = self.ic.outputs[-1]

            print(self.pos, self.vect, self.current_cell_color(), paint_color, turn_param)

            # Paint the current cell
            self.paint_current_cell(paint_color)

            # Turn the robot
            self.turn(turn_param)

            # Advance the robot
            self.move_forward()

    def count_painted_cells(self):
        return len(self.painted_cells)

if __name__ == '__main__':
    pgm = get_pgm_input('./input/input_day_11.txt')
    rb = robot(pgm)
    rb.run()
    s1 = rb.count_painted_cells()
    print("Solution to Part 1: {}".format(s1))

    rb = robot(pgm)
    rb.paint_current_cell(1)
    rb.run()
