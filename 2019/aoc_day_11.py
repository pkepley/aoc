from intcode_computer import zeroaccess_dict
from intcode_computer import intcode_computer


def get_pgm_input(file_location):
    f = open(file_location)
    contents = [int(i) for i in "".join(list(f)).split(",")]
    f.close()
    return contents


class robot:
    def __init__(self, pgm):
        self.pgm = pgm[:]
        self.pos = (0, 0)
        self.vect = (0, 1)
        self.ic = intcode_computer(pgm)
        self.painted_cells = zeroaccess_dict()

        self.pos_history = []
        self.paint_history = []

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
            turn_param = self.ic.outputs[-1]

            # Paint the current cell
            self.paint_current_cell(paint_color)

            # Turn the robot
            self.turn(turn_param)

            # Record result
            self.pos_history.append(self.pos)
            self.paint_history.append(paint_color)

            # Advance the robot
            self.move_forward()

    def count_painted_cells(self):
        return len(self.painted_cells)

    def paint_job_array(self):
        # Get the position of white cells
        white_cells = [pos for pos in self.painted_cells.keys()
                       if self.painted_cells[pos] == 1]

        # Extract the range of positions
        xs = [pos[0] for pos in white_cells]
        ys = [pos[1] for pos in white_cells]
        xs_min, xs_max = min(xs), max(xs)
        ys_min, ys_max = min(ys), max(ys)

        # The number of
        n_col = xs_max - xs_min + 1
        n_row = ys_max - ys_min + 1

        # Store the result in a matrix
        ascii_cells = [[" " for j in range(n_col)] for i in range(n_row)]

        for pos in white_cells:
            j = pos[0] - xs_min
            i = ys_max - pos[1]
            ascii_cells[i][j] = "#"

        return ascii_cells

    def print_paint_job(self):
        ascii_cells = self.paint_job_array()

        for row in ascii_cells:
            print("".join(row))


if __name__ == "__main__":
    pgm = get_pgm_input("./input/input_day_11.txt")
    rb = robot(pgm)
    rb.run()
    s1 = rb.count_painted_cells()
    print("Solution to Part 1: {}".format(s1))

    rb = robot(pgm)
    rb.paint_current_cell(1)
    rb.run()
    print("Solution to Part 2:")
    rb.print_paint_job()
