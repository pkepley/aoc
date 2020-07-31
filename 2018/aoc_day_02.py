def read_data(file_path):
    with open(file_path, "r") as f:
        data = f.readlines()
    f.close()
    data = [x.replace("\n", "") for x in data]
    return data


def compute_checksum(data):
    cnt_exactly_2 = 0
    cnt_exactly_3 = 0

    for code in data:
        code = list(code)
        code.sort()
        i = 0
        n = len(code)
        has_exactly_2, has_exactly_3 = False, False
        while i < n:
            cnt = 1
            while (i + cnt < n) and (code[i + cnt] == code[i]):
                cnt = cnt + 1
            if cnt == 2:
                has_exactly_2 = True
            if cnt == 3:
                has_exactly_3 = True
            i = i + cnt
        if has_exactly_2:
            cnt_exactly_2 = cnt_exactly_2 + 1
        if has_exactly_3:
            cnt_exactly_3 = cnt_exactly_3 + 1
    return cnt_exactly_2 * cnt_exactly_3


def common_chars_for_prototype(data):
    n_codes = len(data)
    code_len = len(data[1])

    for i in range(n_codes):
        str1 = data[i]
        for j in range(i + 1, n_codes):
            str2 = data[j]
            cnt_diff = 0
            for k in range(code_len):
                if str1[k] != str2[k]:
                    cnt_diff = cnt_diff + 1
            if cnt_diff == 1:
                for k in range(code_len):
                    if str1[k] != str2[k]:
                        break
                code = list(str1)
                code.pop(k)
                return "".join(code)


if __name__ == "__main__":
    data = read_data("./input/aoc_02.txt")

    print("Part 1: {}".format(compute_checksum(data)))
    print("Part 2: {}".format(common_chars_for_prototype(data)))
