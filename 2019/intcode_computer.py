def parse_param_modes(param_opcode, n_params):
    param_mode_descr = int(param_opcode / 100)
    param_modes = [0 for i in range(n_params)]

    for i in range(n_params):
        param_modes[i] = int((param_mode_descr) % 10)
        param_mode_descr = int(param_mode_descr / 10)

    return param_modes


class zeroaccess_dict(dict):
    def __getitem__(self, key):
        try:
            val = dict.__getitem__(self, key)
        except:
            val = 0
            self.__setitem__(key, val)

        return val


class intcode_computer:
    def __init__(self, pgm):
        # pgm will be saved as a dict instead of a list
        # because memory needs to be huge, apparently.
        self.pgm = zeroaccess_dict(zip(list(range(0, len(pgm))), pgm))
        self.ptr = 0
        self.rel_base = 0
        self.outputs = []
        self.running = True

    def read_param(self, mode, param):
        if mode == 0:
            return self.pgm[param]

        elif mode == 1:
            return param

        elif mode == 2:
            return self.pgm[self.rel_base + param]

    def write_param(self, mode, param, val):
        if mode == 0:
            self.pgm[param] = val
        elif mode == 2:
            self.pgm[param + self.rel_base] = val

    def run(self, inputs=[]):
        halt_computation = False

        while not halt_computation:
            opcode = self.pgm[self.ptr] % 100

            # Termination opcode read?
            if opcode == 99:
                self.running = False
                break

            elif opcode == 1:
                pm1, pm2, pm3 = parse_param_modes(self.pgm[self.ptr], 3)

                r1 = self.read_param(pm1, self.pgm[self.ptr + 1])
                r2 = self.read_param(pm2, self.pgm[self.ptr + 2])
                r3 = self.write_param(pm3, self.pgm[self.ptr + 3], r1 + r2)

                self.ptr += 4

            elif opcode == 2:
                pm1, pm2, pm3 = parse_param_modes(self.pgm[self.ptr], 3)

                r1 = self.read_param(pm1, self.pgm[self.ptr + 1])
                r2 = self.read_param(pm2, self.pgm[self.ptr + 2])
                r3 = self.write_param(pm3, self.pgm[self.ptr + 3], r1 * r2)

                self.ptr += 4

            elif opcode == 3:
                if not inputs:
                    halt_computation = True
                else:
                    (pm1,) = parse_param_modes(self.pgm[self.ptr], 1)
                    self.write_param(pm1, self.pgm[self.ptr + 1], inputs[0])
                    inputs.pop(0)

                    self.ptr += 2

            elif opcode == 4:
                (pm1,) = parse_param_modes(self.pgm[self.ptr], 1)

                if pm1 == 0:
                    r1 = self.pgm[self.ptr + 1]
                elif pm1 == 1:
                    r1 = self.ptr + 1
                elif pm1 == 2:
                    r1 = self.rel_base + self.pgm[self.ptr + 1]

                self.outputs.append(self.pgm[r1])
                self.ptr += 2

            elif opcode == 5:
                pm1, pm2 = parse_param_modes(self.pgm[self.ptr], 2)

                r1 = self.read_param(pm1, self.pgm[self.ptr + 1])
                r2 = self.read_param(pm2, self.pgm[self.ptr + 2])

                if r1 != 0:
                    self.ptr = r2
                else:
                    self.ptr += 3

            elif opcode == 6:
                pm1, pm2 = parse_param_modes(self.pgm[self.ptr], 2)

                r1 = self.read_param(pm1, self.pgm[self.ptr + 1])
                r2 = self.read_param(pm2, self.pgm[self.ptr + 2])

                if r1 == 0:
                    self.ptr = r2
                else:
                    self.ptr += 3

            elif opcode == 7:
                pm1, pm2, pm3 = parse_param_modes(self.pgm[self.ptr], 3)

                r1 = self.read_param(pm1, self.pgm[self.ptr + 1])
                r2 = self.read_param(pm2, self.pgm[self.ptr + 2])

                if r1 < r2:
                    self.write_param(pm3, self.pgm[self.ptr + 3], 1)
                else:
                    self.write_param(pm3, self.pgm[self.ptr + 3], 0)

                self.ptr += 4

            elif opcode == 8:
                pm1, pm2, pm3 = parse_param_modes(self.pgm[self.ptr], 3)

                r1 = self.read_param(pm1, self.pgm[self.ptr + 1])
                r2 = self.read_param(pm2, self.pgm[self.ptr + 2])
                r3 = self.pgm[self.ptr + 3]

                if r1 == r2:
                    self.write_param(pm3, self.pgm[self.ptr + 3], 1)
                else:
                    self.write_param(pm3, self.pgm[self.ptr + 3], 0)

                self.ptr += 4

            elif opcode == 9:
                (pm1,) = parse_param_modes(self.pgm[self.ptr], 1)

                r1 = self.read_param(pm1, self.pgm[self.ptr + 1])

                self.rel_base += r1
                self.ptr += 2


def test_run_pgm(pgm, inputs):
    ic = intcode_computer(pgm)
    ic.run(inputs)
    return ic


if __name__ == "__main__":
    assert parse_param_modes(1002, 3) == [0, 1, 0]
    assert parse_param_modes(11002, 3) == [0, 1, 1]

    # # Test Equal to 8:
    pgm = [3, 9, 8, 9, 10, 9, 4, 9, 99, -1, 8]
    assert test_run_pgm(pgm, [8]).outputs == [1]
    assert test_run_pgm(pgm, [100]).outputs == [0]

    # Test Less than 8:
    # 3,9,7,9,10,9,4,9,99,-1,8 - Using position mode, consider whether
    # the input is less than 8; output 1 (if it is) or 0 (if it is not).
    pgm = [3, 9, 7, 9, 10, 9, 4, 9, 99, -1, 8]
    assert test_run_pgm(pgm, [7]).outputs == [1]
    assert test_run_pgm(pgm, [-10]).outputs == [1]
    assert test_run_pgm(pgm, [8]).outputs == [0]
    assert test_run_pgm(pgm, [10]).outputs == [0]

    # 3,3,1108,-1,8,3,4,3,99 - Using immediate mode, consider whether
    # the input is equal to 8; output 1 (if it is) or 0 (if it is not).
    pgm = [3, 3, 1108, -1, 8, 3, 4, 3, 99]
    assert test_run_pgm(pgm, [10]).outputs == [0]
    assert test_run_pgm(pgm, [8]).outputs == [1]

    # 3,3,1107,-1,8,3,4,3,99 - Using immediate mode, consider whether
    # the input is less than 8; output 1 (if it is) or 0 (if it is not).
    pgm = [3, 3, 1107, -1, 8, 3, 4, 3, 99]
    assert test_run_pgm(pgm, [10]).outputs == [0]
    assert test_run_pgm(pgm, [8]).outputs == [0]
    assert test_run_pgm(pgm, [6]).outputs == [1]

    # Here are some jump tests that take an input, then output 0 if the
    # input was zero or 1 if the input was non-zero:
    # 3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9 (using position mode)
    # 3,3,1105,-1,9,1101,0,0,12,4,12,99,1 (using immediate mode)
    pgm = [3, 12, 6, 12, 15, 1, 13, 14, 13, 4, 13, 99, -1, 0, 1, 9]
    assert test_run_pgm(pgm[:], [0]).outputs == [0]
    assert test_run_pgm(pgm[:], [2]).outputs == [1]
    assert test_run_pgm(pgm[:], [-3]).outputs == [1]
    pgm = [3, 3, 1105, -1, 9, 1101, 0, 0, 12, 4, 12, 99, 1]
    assert test_run_pgm(pgm, [0]).outputs == [0]
    assert test_run_pgm(pgm, [2]).outputs == [1]
    assert test_run_pgm(pgm, [-32]).outputs == [1]

    # Here's a larger example:
    #
    # 3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,
    # 1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,
    # 999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99
    #
    # The above example program uses an input instruction to ask for a
    # single number. The program will then output 999 if the input value is
    # below 8, output 1000 if the input value is equal to 8, or output 1001
    # if the input value is greater than 8.
    #
    pgm = [
        3,
        21,
        1008,
        21,
        8,
        20,
        1005,
        20,
        22,
        107,
        8,
        21,
        20,
        1006,
        20,
        31,
        1106,
        0,
        36,
        98,
        0,
        0,
        1002,
        21,
        125,
        20,
        4,
        20,
        1105,
        1,
        46,
        104,
        999,
        1105,
        1,
        46,
        1101,
        1000,
        1,
        20,
        4,
        20,
        1105,
        1,
        46,
        98,
        99,
    ]
    assert test_run_pgm(pgm, [0]).outputs == [999]
    assert test_run_pgm(pgm, [8]).outputs == [1000]
    assert test_run_pgm(pgm, [9]).outputs == [1001]

    # 109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99 takes
    # no input and produces a copy of itself as output.
    pgm = [109, 1, 204, -1, 1001, 100, 1, 100, 1008, 100, 16, 101, 1006, 101, 0, 99]
    assert test_run_pgm(pgm, []).outputs == pgm

    # 1102,34915192,34915192,7,4,7,99,0 should output a 16-digit
    # number
    pgm = [1102, 34915192, 34915192, 7, 4, 7, 99, 0]
    assert test_run_pgm(pgm, []).outputs == [1219070632396864]

    # 104,1125899906842624,99 should output the large number in the
    # middle
    pgm = [104, 1125899906842624, 99]
    assert test_run_pgm(pgm, []).outputs == [1125899906842624]
