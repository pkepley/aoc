from intcode_computer import *
from itertools import combinations, permutations

def get_pgm_input(file_location):
    f = open(file_location)
    contents = [int(i) for i in ''.join(list(f)).split(',')]
    f.close()
    return contents

def run_phase_setting(pgm, phase_sequence, feedback_mode = 0, initial_signal = 0):
    n_thrusters = len(phase_sequence)
    signal = initial_signal
    ics = []
    
    for setting in phase_sequence:
        ics.append(intcode_computer(pgm))
        ics[-1].run([setting])

    phase_idx = 0
    while ics[-1].running == True:
        ic = ics[phase_idx]        
        ic.run([signal])
        output = ic.outputs[-1]
        signal = output
        phase_idx = (phase_idx + 1) % n_thrusters

        if feedback_mode == 0 and phase_idx == 0:
            break

    return output

def find_highest_signal(pgm, feedback_mode = 0, n_thrusters=5):    
    best_signal = None

    if feedback_mode == 0:
        phase_inputs = list(range(0, n_thrusters))
    else:
        phase_inputs = list(range(n_thrusters, 2 * n_thrusters))

    for phase_sequence in permutations(phase_inputs):
         signal = run_phase_setting(pgm, phase_sequence, feedback_mode)
         if best_signal is None or signal > best_signal:
             best_signal = signal
            
    return best_signal

if __name__ == '__main__':
    # Part 1 Test 1
    pgm = [3,15,3,16,1002,16,10,16,1,16,15,15,4,15,99,0,0]
    phase_sequence = [4,3,2,1,0]
    result = 43210
    assert(run_phase_setting(pgm, phase_sequence, 0) == result)
    assert(find_highest_signal(pgm, feedback_mode=0) == result)
    
    # Part 1 Test 2
    pgm = [3,23,3,24,1002,24,10,24,1002,23,-1,23,
           101,5,23,23,1,24,23,23,4,23,99,0,0]
    phase_sequence = [0,1,2,3,4]
    result = 54321
    assert(run_phase_setting(pgm, phase_sequence, 0) == result)    
    assert(find_highest_signal(pgm, feedback_mode=0) == result)
    
    # Part 1 Test 3
    pgm = [3,31,3,32,1002,32,10,32,1001,31,-2,31,1007,31,0,33,
           1002,33,7,33,1,33,31,31,1,32,31,31,4,31,99,0,0,0]
    phase_sequence = [1,0,4,3,2]
    result = 65210
    assert(run_phase_setting(pgm, phase_sequence, 0) == result)               
    assert(find_highest_signal(pgm, feedback_mode=0) == result)

    # Part 2 Test 1
    pgm = [3,26,1001,26,-4,26,3,27,1002,27,2,27,1,27,26,
           27,4,27,1001,28,-1,28,1005,28,6,99,0,0,5 ]
    phase_sequence = [9,8,7,6,5]
    result = 139629729
    assert(run_phase_setting(pgm, phase_sequence, feedback_mode = 1) == result)
    assert(find_highest_signal(pgm, feedback_mode = 1) == result)
    
    # Part 2 Test 2
    pgm = [3,52,1001,52,-5,52,3,53,1,52,56,54,1007,54,5,55,1005,55,26,1001,54,
           -5,54,1105,1,12,1,53,54,53,1008,54,0,55,1001,55,1,55,2,53,55,53,4,
           53,1001,56,-1,56,1005,56,6,99,0,0,0,0,10]
    phase_sequence = [9,7,8,5,6]
    result = 18216
    assert(run_phase_setting(pgm, phase_sequence, feedback_mode = 1) == result)        
    assert(find_highest_signal(pgm, feedback_mode = 1) == result)

    # Solve Part 1 and 2
    pgm = get_pgm_input('./input/input_day_7.txt')
    s1 = find_highest_signal(pgm, feedback_mode=0)
    s2 = find_highest_signal(pgm, feedback_mode=1)    
    print("Solution to Part 1: {}".format(s1))
    print("Solution to Part 2: {}".format(s2))    
     
