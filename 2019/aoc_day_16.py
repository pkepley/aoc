import numpy as np
import matplotlib.pyplot as plt


def get_input(file_path):
    f = open(file_path, "r")
    data = f.readline()
    data = [int(d) for d in data.replace("\n", "")]
    f.close()

    return data


def phase(data, pattern):
    pattern_len = len(pattern)
    data_len = len(data)
    data_out = [0 for i in range(data_len)]

    for i_out in range(data_len):
        k = 0
        s = 0

        for i in range(data_len):
            if (i + 1) % (i_out + 1) == 0:
                k += 1
                k = k % pattern_len

            s += data[i] * pattern[k]

        data[i_out] = abs(s) % 10

    return data


def fft(data, n_phases, pattern=[0, 1, 0, -1]):
    phase_result = data[:]

    for i in range(n_phases):
        phase_result = phase(phase_result, pattern)

    return phase_result


def fft_2(data, n_phases):
    data_len = len(data)
    phase_matrix = np.zeros((data_len, data_len), dtype=np.short)
    pattern = [0, 1, 0, -1]
    pattern_len = 4

    data_vec = np.array(data)

    for i in range(data_len):
        k = 0
        for j in range(data_len):
            if (j + 1) % (i + 1) == 0:
                k += 1
                k = k % pattern_len
            phase_matrix[i, j] = pattern[k]
        # tiler = np.repeat(pattern, i+1)
        # tiler_len = len(tiler)
        # phase_matrix[i, i:] = np.tile(tiler, int(np.ceil(data_len / tiler_len)))[0:(data_len - i)]

    np.set_printoptions(linewidth=254, threshold=np.inf)
    print(phase_matrix[0:32, 0:32])
    plt.imshow(phase_matrix)
    plt.show()
    # return phase_matrix

    for k in range(n_phases):
        data_vec = np.dot(phase_matrix, data_vec)
        data_vec = np.abs(data_vec) % 10
    return data_vec


# def fft_3(data, n_phases):
#     phase_result = data[:]

#     for i in range(n_phases):
#         print(i)
#         phase_result = phase_2(phase_result)

#     return phase_result


# def phase_2(data):
#     data_len = len(data)
#     data_out = np.array(data).astype(np.int)

#     for i in range(data_len):
#         s = 0
#         m = 1
#         for j in range(i, data_len, 2*(i+1)):
#             s += m * sum(data[j:(j + (i+1))])
#             data_out[i] = s
#             m *= -1

#     data_out = np.abs(data_out) % 10

#     return data_out


if __name__ == "__main__":
    # print(get_input('input/input_day_16.txt'))
    # print(phase(list(range(1, 9)), [0,1,0,-1]))
    # print(fft(list(range(1, 9)), 4))

    data = get_input("input/input_day_16.txt")
    # fft_result = fft(data, 100)
    # s1 = ''.join([str(d) for d in fft_result[0:8]])
    # print("Solution Part 1: {}".format(s1))

    fft_result = fft_2(data, 100)
    s1 = "".join([str(d) for d in fft_result[0:8]])
    print("Solution Part 1: {}".format(s1))

    # fft_result = fft_3(data, 100)
    # s1 = ''.join([str(d) for d in fft_result[0:8]])
    # print("Solution Part 1: {}".format(s1))

    # fft_result = fft_3(np.tile(data, 100), 100)
    # fft_result = fft_3(
