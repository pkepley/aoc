def read_input(file_location):
    f = open(file_location, 'r')
    rows = [int(row) for row in list(f)]
    f.close()
    return rows

def fuel_requirement(m):
    return int(m / 3.0) - 2

def total_fuel_requirement(m):
    f = fuel_requirement(m)
    fuel_required = 0
    
    while f > 0:
        fuel_required += f        
        f = fuel_requirement(f)

    return fuel_required

def solve_part_1(masses):
    return sum([fuel_requirement(m) for m in masses])

def solve_part_2(masses):
    return sum([total_fuel_requirement(m) for m in masses])

if __name__ == '__main__':
    masses = read_input('./input/input_day_1.txt')
    s1 = solve_part_1(masses)
    s2 = solve_part_2(masses)    
    print('Solution to Part 1 {0}'.format(s1))
    print('Solution to Part 2 {0}'.format(s2))    
