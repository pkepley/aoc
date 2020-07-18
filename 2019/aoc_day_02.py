def get_input(file_location):
    f = open(file_location)
    contents = [int(i) for i in ''.join(list(f)).split(',')]
    f.close()
    return contents
            

def run_pgm(pgm):
    pgm = pgm[:]
    program_len = len(pgm)
    
    for i in range(0, program_len, 4):
        opcode = pgm[i]

        # Termination opcode read?
        if opcode == 99:
            break

        # Get parameters for opcode and handle
        else:
            r1 = pgm[i+1]
            r2 = pgm[i+2]
            r3 = pgm[i+3]

            # Handle opcode
            if opcode == 1:
                pgm[r3] = pgm[r1] + pgm[r2]
            
            elif opcode == 2:
                pgm[r3] = pgm[r1] * pgm[r2]
                    
    return pgm

def run_after_modifying(pgm, noun, verb):
    pgm = pgm[:]    
    pgm[1] = noun
    pgm[2] = verb
    pgm_out = run_pgm(pgm)

    return pgm_out
    

def solve_part_1():
    pgm = get_input('./input/input_day_02.txt')
    pgm_out = run_after_modifying(pgm, 12, 2)
    
    return pgm_out[0]

def solve_part_2():
    pgm = get_input('./input/input_day_02.txt')

    for noun in range(0,100):
        for verb in range(0, 100):
            pgm_out = run_after_modifying(pgm, noun, verb)
            if pgm_out[0] == 19690720:
                return 100 * noun + verb            
    
    return None


if __name__ == '__main__':
    assert(run_pgm([1,0,0,0,99]) == [2,0,0,0,99])
    assert(run_pgm([2,3,0,3,99]) == [2,3,0,6,99])
    assert(run_pgm([2,4,4,5,99,0]) == [2,4,4,5,99,9801])
    assert(run_pgm([1,1,1,4,99,5,6,0,99]) == [30,1,1,4,2,5,6,0,99])

    s1 = solve_part_1()
    print('Solution to part 1 {0}'.format(s1))
    s2 = solve_part_2()
    print('Solution to part 2 {0}'.format(s2))    
    
