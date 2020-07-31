from intcode_computer import intcode_computer
import numpy as np


def get_pgm_input(file_location):
    f = open(file_location)
    contents = [int(i) for i in "".join(list(f)).split(",")]
    f.close()
    return contents


class arcade_machine:
    def __init__(self, pgm, play=False):
        # Set up computer to run with coins
        self.pgm = pgm[:]
        if play == True:
            self.pgm[0] = 2

        # Initial setup
        self.score = 0
        self.nframe = 0
        self.matr = None
        self.ball_pos = None
        self.paddle_pos = None
        self.pixels = dict()
        self.tile_instructions = []

        # Draw the screen
        self.ic = intcode_computer(self.pgm)
        self.ic.run()
        self.update()

    def joystick(self, joystick_signal):
        self.ic.run([joystick_signal])
        self.update()

    def cheat_run(self):
        while self.ic.running:
            self.joystick(self.cheat_update())
        return self.score

    def cheat_update(self):
        if self.ball_pos[0] > self.paddle_pos[0]:
            return 1
        elif self.ball_pos[0] < self.paddle_pos[0]:
            return -1
        else:
            return 0

    def flush_output(self):
        self.ic.outputs = []

    def update(self):
        # Get the outputs, flush the result
        instr = self.ic.outputs
        self.flush_output()

        # Update instructions
        n_instr = int(len(instr) / 3)
        self.tile_instructions = [
            (instr[3 * k], instr[3 * k + 1], instr[3 * k + 2]) for k in range(n_instr)
        ]

        for instr in self.tile_instructions:
            x, y, tile_id = instr

            if x < 0:
                self.score = tile_id
            else:
                self.pixels[(x, y)] = tile_id

            if tile_id == 4:
                self.ball_pos = (x, y)

            elif tile_id == 3:
                self.paddle_pos = (x, y)

        self.update_matr()
        self.nframe += 1

    def init_matr(self):
        xs = [x for x, _ in self.pixels.keys()]
        ys = [y for _, y in self.pixels.keys()]

        xs_min, xs_max = max(min(xs), 0), max(xs)
        ys_min, ys_max = max(min(ys), 0), max(ys)

        nx = (xs_max - xs_min) + 1
        ny = (ys_max - ys_min) + 1

        self.matr = np.zeros((ny, nx), dtype=np.int)

    def update_matr(self):
        if self.matr is None:
            self.init_matr()

        for x, y in self.pixels.keys():
            j = x
            i = y
            if x >= 0 and y >= 0:
                self.matr[i, j] = self.pixels[(x, y)]


if __name__ == "__main__":
    pgm = get_pgm_input("./input/input_day_13.txt")
    am = arcade_machine(pgm)

    s1 = len([k for k in am.pixels.keys() if am.pixels[k] == 2])
    print("Solution to part 1: {}".format(s1))

    am = arcade_machine(pgm, play=True)
    s2 = am.cheat_run()
    print("Solution to part 2: {}".format(s2))
