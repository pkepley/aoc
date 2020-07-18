from intcode_computer import intcode_computer

def get_pgm_input(file_location):
    f = open(file_location)
    contents = [int(i) for i in ''.join(list(f)).split(',')]
    f.close()
    return contents

if __name__ == '__main__':
    pgm = get_pgm_input('./input/input_day_09.txt')

    ic = intcode_computer(pgm)
    ic.run([1])
    s1 = ic.outputs[0]
    print("Solution to Part 1: {}".format(s1))

    ic = intcode_computer(pgm)
    ic.run([2])
    s2 = ic.outputs[0]
    print("Solution to Part 2: {}".format(s2))
    
