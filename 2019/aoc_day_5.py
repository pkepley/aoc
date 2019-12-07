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
            r1 = pgm[ptr+1]
            outpt.append(pgm[r1])
            ptr += 2           
                    
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
    s1 = run_pgm(get_pgm_input('./input/input_day_5.txt'), inpt=1)
    print("Solution to part 1: {}".format(s1[-1]))


