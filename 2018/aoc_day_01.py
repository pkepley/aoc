def read_data(file_path):
    with open(file_path, "r") as f:
        data = f.readlines()
    f.close()
    data = [int(x.replace("\n", "")) for x in data]
    return data


def solve_1(data):
    return sum(data)


def solve_2(data):
    n = len(data)
    i, frequency = 0, 0
    frequencies_seen = set([])

    while True:
        frequency = frequency + data[i]
        i = (i + 1) % n

        if frequency in frequencies_seen:
            break
        else:
            frequencies_seen.add(frequency)

    return frequency


if __name__ == "__main__":
    data_1 = read_data("./input/aoc_01.txt")
    # for example
    # data_1 = [1, -2, 3,1,1,-2]
    print("Part 1: {}".format(solve_1(data_1)))
    print("Part 2: {}".format(solve_2(data_1)))
