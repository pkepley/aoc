class submarine:
    def __init__(self, operation_mode = 'simple'):
        self.operation_mode = operation_mode
        self.horizontal_pos = 0
        self.depth = 0
        self.aim = 0

        if operation_mode == 'simple':
            self.single_move = self.single_move_simple
        elif operation_mode == 'aim':
            self.single_move = self.single_move_aim
        else:
            raise ValueError("operation_mode must be either 'simple' or 'aim'")

    def parse_commands(self, command_str):
        cmds = command_str.split("\n")
        cmds = [c for c in cmds if len(c.split(" ")) == 2]
        directions = [c.split(" ")[0] for c in cmds]
        distances = [int(c.split(" ")[1]) for c in cmds]

        return directions, distances

    def single_move(self, direction, distance):
        if direction == 'forward':
            self.horizontal_pos += distance

        elif direction == 'down':
            self.depth += distance

        elif direction == 'up':
            self.depth -= distance

    def single_move_simple(self, direction, X):
        if direction == 'forward':
            self.horizontal_pos += X

        elif direction == 'down':
            self.depth += X

        elif direction == 'up':
            self.depth -= X

    def single_move_aim(self, direction, X):
        if direction == 'forward':
            self.horizontal_pos += X
            self.depth += (self.aim * X)

        elif direction == 'down':
            self.aim += X

        elif direction == 'up':
            self.aim -= X

    def execute_multiple_moves(self, directions, distances):
        for dxn, dst in zip(directions, distances):
            self.single_move(dxn, dst)

    def execute_command_str(self, command_str):
        directions, distances = self.parse_commands(command_str)
        self.execute_multiple_moves(directions, distances)


if __name__ == '__main__':
    from aoc_config import input_path

    test_commands = """forward 5
down 5
forward 8
up 3
down 8
forward 2"""

    # test part 1
    test_sub = submarine(operation_mode = 'simple')
    test_sub.execute_command_str(test_commands)
    assert(test_sub.horizontal_pos * test_sub.depth == 150)

    # test part 2
    test_sub = submarine(operation_mode = 'aim')
    test_sub.execute_command_str(test_commands)
    assert(test_sub.horizontal_pos * test_sub.depth == 900)

    # get problem input
    with open(f"{input_path}/input_day_02.txt", "r") as f:
        prob_commands = "".join(list(f))
    print(prob_commands)

    # solve part 1
    prob_sub = submarine(operation_mode = 'simple')
    prob_sub.execute_command_str(prob_commands)
    soln_part_1 = prob_sub.horizontal_pos * prob_sub.depth
    print(f"Day 2 Part 1: {soln_part_1}.")

    # solve part 2
    prob_sub = submarine(operation_mode = 'aim')
    prob_sub.execute_command_str(prob_commands)
    soln_part_2 = prob_sub.horizontal_pos * prob_sub.depth
    print(f"Day 2 Part 2: {soln_part_2}.")
