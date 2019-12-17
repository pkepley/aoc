def get_input(file_path):
    f = open(file_path, 'r')
    data = f.readline()
    data = [int(d) for d in data.replace('\n', '')]
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

def fft(data, n_phases,  pattern = [0,1,0,-1]):
    phase_result = data[:]

    for i in range(n_phases):
        phase_result = phase(phase_result, pattern)

    return phase_result

if __name__ == '__main__':
    #print(get_input('input/input_day_16.txt'))

    print(phase(list(range(1, 9)), [0,1,0,-1])) 
    print(fft(list(range(1, 9)), 4))

    data = get_input('input/input_day_16.txt')
    fft_result = fft(data, 100)
    print(fft_result)
