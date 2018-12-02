def read_data(file_path):
    with open(file_path, "r") as f:
        data = f.readlines()
    f.close()
    data = map(lambda x: x.replace("\n",""), data)
    return data

def compute_checksum(data):
    cnt_exactly_2 = 0
    cnt_exactly_3 = 0

    for code in data:
        code = list(code)
        code.sort()  
        i = 0
        n = len(code)
        has_exactly_2 , has_exactly_3 = False, False
        while i < n:
            cnt = 1
            while (i + cnt < n) and (code[i+cnt] == code[i]):
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

if __name__ == "__main__":
    data = read_data("./input/aoc_2.txt")
    print(compute_checksum(data))
