from intcode_computer import *
from itertools import permutations

def get_pgm_input(file_location):
    f = open(file_location)
    contents = [int(i) for i in ''.join(list(f)).split(',')]
    f.close()
    return contents

def run_phase_setting(pgm, phase_sequence, initial_signal = 0):
    signal = 0
    
    for setting in phase_sequence:
        output, = run_pgm(pgm, inpt=[setting, signal])
        signal = output

    return output

def find_highest_signal(pgm):
    best_signal = None
    
    for phase_sequence in permutations([0,1,2,3,4]):
        signal = run_phase_setting(pgm, phase_sequence, 0)

        if best_signal is None or signal > best_signal:
            best_signal = signal
            
    return best_signal

if __name__ == '__main__':
    # Test 1
    pgm = [3,15,3,16,1002,16,10,16,1,16,15,15,4,15,99,0,0]
    phase_sequence = [4,3,2,1,0]
    result = 43210
    assert(run_phase_setting(pgm, phase_sequence, 0) == result)
    assert(find_highest_signal(pgm) == result)
    
    # Test 2
    pgm = [3,23,3,24,1002,24,10,24,1002,23,-1,23,
           101,5,23,23,1,24,23,23,4,23,99,0,0]
    phase_sequence = [0,1,2,3,4]
    result = 54321
    assert(run_phase_setting(pgm, phase_sequence, 0) == result)    
    assert(find_highest_signal(pgm) == result)
    
    # Test 3
    pgm = [3,31,3,32,1002,32,10,32,1001,31,-2,31,1007,31,0,33,
           1002,33,7,33,1,33,31,31,1,32,31,31,4,31,99,0,0,0]
    phase_sequence = [1,0,4,3,2]
    result = 65210
    assert(run_phase_setting(pgm, phase_sequence, 0) == result)               
    assert(find_highest_signal(pgm) == result)

    # Solve Part 1
    pgm = get_pgm_input('./input/input_day_7.txt')
    s1 = find_highest_signal(pgm)
    print("Solution to Part 1: {}".format(s1))
