from time import sleep 

def get_pgm_input(file_location):
    f = open(file_location)
    contents = [int(i) for i in ''.join(list(f)).split(',')]
    f.close()
    return contents

def parse_param_modes(param_opcode, n_params):
    param_mode_descr = int(param_opcode / 100)
    param_modes = [0 for i in range(n_params)]

    for i in range(n_params):
        param_modes[i]   = int((param_mode_descr) % 10)
        param_mode_descr = int(param_mode_descr / 10)
    
    return param_modes

def get_param(pgm, mode, param):
    if mode == 0:
        return pgm[param]
    
    elif mode == 1:
        return param
    
def run_pgm(pgm, inpt=None):
    outpt = []
    ptr   = 0
    
    while True:
        opcode = pgm[ptr] % 100

        # Termination opcode read?
        if opcode == 99:
            break

        elif opcode == 1:
            pm1,pm2,pm3 = parse_param_modes(pgm[ptr], 3)
            r1 = get_param(pgm, pm1, pgm[ptr+1])
            r2 = get_param(pgm, pm2, pgm[ptr+2])
            r3 = pgm[ptr+3]            
            pgm[r3] = r1 + r2
            ptr += 4

        elif opcode == 2:            
            pm1,pm2,pm3 = parse_param_modes(pgm[ptr], 3)
            r1 = get_param(pgm, pm1, pgm[ptr+1])
            r2 = get_param(pgm, pm2, pgm[ptr+2])
            r3 = pgm[ptr+3]
            pgm[r3] = r1 * r2
            ptr += 4

        elif opcode == 3:
            r1 = pgm[ptr+1]
            pgm[r1] = inpt
            ptr += 2
            
        elif opcode == 4:
            pm1, = parse_param_modes(pgm[ptr], 1)
            if pm1 == 0:
                r1 = pgm[ptr+1]
            else:
                r1 = ptr + 1                
            outpt.append(pgm[r1])                            
            ptr += 2

        elif opcode == 5:
            pm1, pm2 = parse_param_modes(pgm[ptr], 2)
            r1 = get_param(pgm, pm1, pgm[ptr+1])
            r2 = get_param(pgm, pm2, pgm[ptr+2])
            if r1 != 0:
                ptr = r2
            else:
                ptr += 3

        elif opcode == 6:
            pm1, pm2 = parse_param_modes(pgm[ptr], 2)
            r1 = get_param(pgm, pm1, pgm[ptr+1])
            r2 = get_param(pgm, pm2, pgm[ptr+2])
            if r1 == 0:
                ptr = r2
            else:
                ptr += 3

        elif opcode == 7:
            pm1, pm2, pm3 = parse_param_modes(pgm[ptr], 3)
            r1 = get_param(pgm, pm1, pgm[ptr+1])
            r2 = get_param(pgm, pm2, pgm[ptr+2])
            r3 = pgm[ptr+3]
                        
            if r1 < r2:
                pgm[r3] = 1
            else:
                pgm[r3] = 0
            ptr += 4
            
        elif opcode == 8:
            pm1, pm2, pm3 = parse_param_modes(pgm[ptr], 3)
            r1 = get_param(pgm, pm1, pgm[ptr+1])
            r2 = get_param(pgm, pm2, pgm[ptr+2])
            r3 = pgm[ptr+3]
            if r1 == r2:
                pgm[r3] = 1
            else:
                pgm[r3] = 0
            ptr += 4
                    
    return outpt



if __name__ == '__main__':
    assert(parse_param_modes(1002,  3) == [0,1,0])        
    assert(parse_param_modes(11002, 3) == [0,1,1])
    
    #print('PGM 1')
    #run_pgm([3,0,4,0,99], inpt=1)
    #print('PGM 2')    
    #run_pgm([1002,4,3,4,33], inpt=1)
    #print('PGM 3')    
    #run_pgm([1101,100,-1,4,0], inpt=123)
    #print('PGM S1')

    # Test Equal to 8:
    assert(run_pgm([3,9,8,9,10,9,4,9,99,-1,8], inpt=8) == [1])
    assert(run_pgm([3,9,8,9,10,9,4,9,99,-1,8], inpt=100) == [0])
    
    # Test Less than 8:
    # 3,9,7,9,10,9,4,9,99,-1,8 - Using position mode, consider whether
    # the input is less than 8; output 1 (if it is) or 0 (if it is not).
    assert(run_pgm([3,9,7,9,10,9,4,9,99,-1,8], inpt=7) == [1])
    assert(run_pgm([3,9,7,9,10,9,4,9,99,-1,8], inpt=-10) == [1])    
    assert(run_pgm([3,9,7,9,10,9,4,9,99,-1,8], inpt=8) == [0])
    assert(run_pgm([3,9,7,9,10,9,4,9,99,-1,8], inpt=10) == [0])    
    
    # 3,3,1108,-1,8,3,4,3,99 - Using immediate mode, consider whether
    # the input is equal to 8; output 1 (if it is) or 0 (if it is not).
    assert(run_pgm([3,3,1108,-1,8,3,4,3,99], inpt=10) == [0])
    assert(run_pgm([3,3,1108,-1,8,3,4,3,99], inpt=8) == [1])     
    
    # 3,3,1107,-1,8,3,4,3,99 - Using immediate mode, consider whether
    # the input is less than 8; output 1 (if it is) or 0 (if it is not).
    assert(run_pgm([3,3,1107,-1,8,3,4,3,99], inpt=10) == [0])    
    assert(run_pgm([3,3,1107,-1,8,3,4,3,99], inpt=8) == [0])
    assert(run_pgm([3,3,1107,-1,8,3,4,3,99], inpt=6) == [1])     

    # Here are some jump tests that take an input, then output 0 if the
    # input was zero or 1 if the input was non-zero:
    # 3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9 (using position mode)
    # 3,3,1105,-1,9,1101,0,0,12,4,12,99,1 (using immediate mode)
    assert(run_pgm([3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9], inpt=0) ==[0])
    assert(run_pgm([3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9], inpt=2) ==[1])
    assert(run_pgm([3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9], inpt=-3) ==[1])
    assert(run_pgm([3,3,1105,-1,9,1101,0,0,12,4,12,99,1],inpt= 0) == [0])
    assert(run_pgm([3,3,1105,-1,9,1101,0,0,12,4,12,99,1],inpt= 2) == [1])
    assert(run_pgm([3,3,1105,-1,9,1101,0,0,12,4,12,99,1],inpt=-3) == [1])

    # Here's a larger example:
    #
    # 3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,
    # 1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,
    # 999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99
    #
    # The above example program uses an input instruction to ask for a
    # single number. The program will then output 999 if the input value is
    # below 8, output 1000 if the input value is equal to 8, or output 1001
    # if the input value is greater than 8.
    #
    pgm = [3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,
           1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,
           999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99]
    assert(run_pgm(pgm, inpt=0) == [999])
    assert(run_pgm(pgm, inpt=8) == [1000])
    assert(run_pgm(pgm, inpt=9) == [1001])        

    # Solutions:
    s1 = run_pgm(get_pgm_input('./input/input_day_05.txt'), inpt=1)
    print("Solution to part 1: {}".format(s1[-1]))

    s2 = run_pgm(get_pgm_input('./input/input_day_05.txt'), inpt=5)
    print("Solution to part 1: {}".format(s2[-1]))
    
