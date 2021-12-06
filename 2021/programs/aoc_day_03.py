def parse_report(report_str):
    input_rows = [
        row.strip() for row in report_str.split("\n") if len(row) > 0
    ]
    return input_rows


def gamma_epsilon_rates(rpt):
    rpt_len = len(rpt)
    bit_len = len(rpt[0])
    column_bit_sum = [0 for i in range(bit_len)]

    for n in rpt:
        for i, bit in enumerate(n):
            column_bit_sum[i] += int(bit)

    gamma_rate_bits = [0 for i in range(bit_len)]
    for i, bit_sum in enumerate(column_bit_sum):
        if bit_sum >= rpt_len // 2:
            gamma_rate_bits[i] = 1
        else:
            gamma_rate_bits[i] = 0

    epsilon_rate_bits = [int(not b) for b in gamma_rate_bits]

    gamma_rate = 0
    epsilon_rate = 0
    mult = 1
    for i in range(bit_len-1, -1, -1):
        gamma_rate = gamma_rate + gamma_rate_bits[i] * mult
        epsilon_rate = epsilon_rate + epsilon_rate_bits[i] * mult
        mult *= 2

    return gamma_rate, epsilon_rate


def power_consumption(rpt):
    gamma_rate, epsilon_rate = gamma_epsilon_rates(rpt)

    return gamma_rate * epsilon_rate


if __name__ == '__main__':
    from aoc_config import input_path

    # test input
    test_diagnostic_report_str = """
00100
11110
10110
10111
10101
01111
00111
11100
10000
11001
00010
01010
    """
    test_diagnostic_report = parse_report(test_diagnostic_report_str)
    gr, er = gamma_epsilon_rates(test_diagnostic_report)
    pc = power_consumption(test_diagnostic_report)
    assert(gr == 22)
    assert(er == 9)
    assert(pc == 198)

    # problem input
    with open(f"{input_path}/input_day_03.txt", "r") as f:
        prob_diagnostic_report_str = "".join(list(f))
    prob_diagnostic_report = parse_report(prob_diagnostic_report_str)

    # solve part 1
    soln_part_1 = power_consumption(prob_diagnostic_report)
    print(f"Day 3 Part 1: {soln_part_1}.")
