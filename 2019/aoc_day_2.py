def get_input(file_location):
    f = open(file_location)
    contents = [int(i) for i in ''.join(list(f)).split(',')]
    f.close()
    return contents
            

def parse_pgm(pgm):
    program_len = len(pgm)
    
    for i in range(0, program_len, 4):
        opcode = pgm[i]
        if opcode != 99:
            r1 = pgm[i+1]
            r2 = pgm[i+2]
            r3 = pgm[i+3]
        
        if opcode == 1:
            pgm[r3] = pgm[r1] + pgm[r2]
            
        elif opcode == 2:
            pgm[r3] = pgm[r1] * pgm[r2]
            
        elif opcode == 99:
            break
    return pgm

def solve_part_1():
    pgm = get_input('./input/input_day_2.txt')
    pgm[1] = 12
    pgm[2] = 2

    pgm_out = parse_pgm(pgm)

    return pgm_out[0]
    

if __name__ == '__main__':
    assert(parse_pgm([1,0,0,0,99]) == [2,0,0,0,99])
    assert(parse_pgm([2,3,0,3,99]) == [2,3,0,6,99])
    assert(parse_pgm([2,4,4,5,99,0]) == [2,4,4,5,99,9801])
    assert(parse_pgm([1,1,1,4,99,5,6,0,99]) == [30,1,1,4,2,5,6,0,99])

    s1 = solve_part_1()
    print('Solution to part 1 {0}'.format(s1))
