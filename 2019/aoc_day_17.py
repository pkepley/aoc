from intcode_computer import intcode_computer


def get_pgm_input(file_location):
    with open(file_location) as f:
        contents = [int(i) for i in "".join(list(f)).split(",")]

    return contents


def parse_pgm_output(pgm_output):
    parsed_out = []
    curr_row = []

    for e in pgm_output:
        if e == 10 and len(curr_row) > 0:
            parsed_out.append(curr_row[:])
            curr_row = []
        else:
            curr_row.append(chr(e))

    return parsed_out


def find_intersections(parsed_out):
    n_row = len(parsed_out)
    n_col = len(parsed_out[0])
    intersection_coords = []

    for i in range(0, n_row):
        for j in range(0, n_col):

            # North and south directions, handle edges
            if i == 0:
                ud = [parsed_out[i + 1][j]]
            elif i == n_row - 1:
                ud = [parsed_out[i - 1][j]]
            else:
                ud = [parsed_out[i - 1][j], parsed_out[i + 1][j]]

            # East and West directions, handle edges
            if j == 0:
                lr = [parsed_out[i][j + 1]]
            elif j == n_col - 1:
                lr = [parsed_out[i][j - 1]]
            else:
                lr = [parsed_out[i][j - 1], parsed_out[i][j + 1]]

            nbrs = ud + lr

            # Check neighbors
            if parsed_out[i][j] != "." and len(nbrs) > 2 and nbrs.count(".") == 0:
                intersection_coords.append((i, j))

    return intersection_coords


def alignment_params(intersection_coords):
    return [i * j for i, j in intersection_coords]


def solve_part_1(parsed_out):
    intersection_coords = find_intersections(parsed_out)
    alignments = alignment_params(intersection_coords)
    return sum(alignments)


if __name__ == "__main__":
    test_input = """
..#..........
..#..........
#######...###
#.#...#...#.#
#############
..#...#...#..
..#####...^..
"""

    parsed_out = [list(r) for r in test_input.split("\n")]
    parsed_out = [r for r in parsed_out if len(r) > 0]
    assert solve_part_1(parsed_out) == 76

    pgm = get_pgm_input("./input/input_day_17.txt")
    ic = intcode_computer(pgm)
    ic.run()

    # solve part 1
    parsed_out = parse_pgm_output(ic.outputs)
    print(solve_part_1(parsed_out))
