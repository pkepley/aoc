def get_input(input_path):
    with open(input_path) as f:
        depths = [int(l) for l in list(f)]

    return depths


def count_depth_increases(depths):
    n_inc = 0

    for i in range(1, len(depths)):
        if depths[i] > depths[i-1]:
            n_inc += 1

    return n_inc


def rolling_sum(depths, window_width=3):
    roll_sum = []

    curr_roll_sum = sum(depths[0:window_width])
    roll_sum.append(curr_roll_sum)

    for i in range(window_width, len(depths)):
        curr_roll_sum += (depths[i] - depths[i - window_width])
        roll_sum.append(curr_roll_sum)

    return roll_sum


def count_rolling_depth_increases(depths, window_width=3):
    return count_depth_increases(rolling_sum(depths, window_width))


if __name__ == '__main__':
    from aoc_config import input_path

    # check test cases for parts 1 & 2
    test_depths = [199, 200, 208, 210, 200, 207, 240, 269, 260, 263]
    assert(count_depth_increases(test_depths) == 7)
    assert(count_rolling_depth_increases(test_depths, 3) == 5)

    # solve part 1
    prob_depths = get_input(f"{input_path}/input_day_01.txt")
    soln_part_1 = count_depth_increases(prob_depths)
    print(f"Day 1 Part 1: {soln_part_1}.")

    # solve part 2
    soln_part_2 = count_rolling_depth_increases(prob_depths)
    print(f"Day 2 Part 2: {soln_part_2}.")
