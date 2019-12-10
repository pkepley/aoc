from math import gcd

def get_input(file_path):
    f = open(file_path, 'r')    
    input_map = [l.replace('\n', '') for l in list(f)]
    f.close()
    return input_map

def get_asteroids(input_map):
    n_row = len(input_map)
    n_col = len(input_map[0])
    asteroids = []
    
    for i in range(n_row):
        for j in range(n_col):
            if input_map[i][j] == '#':
                asteroids.append((j,i))
                
    return asteroids
            
def visible_asteroids(asteroids, pos):
    # Get the raw directions from each asteroid to pos
    directions = [(a[0] - pos[0], a[1] - pos[1]) for a in asteroids if a != pos]

    # Convert the raw directions (d_raw) into re-scaled direction
    # (d_scl) and extract number of re-scaled steps from pos (d_gcd)
    # save result as d_gcd, d
    offset_data = []
    for d_raw, a in zip(directions, asteroids):        
        d_gcd = gcd(d_raw[0], d_raw[1])
        d_scl = (int(d_raw[0] / d_gcd), int(d_raw[1] / d_gcd))
        offset_data.append((d_scl, d_gcd, a))

    # Sort by scaled direction and number of re-scaled steps retain
    # all distinct directions which achieve smallest number of
    # re-scaled steps
    offset_data.sort()
    visible_asteroids = []
    curr_d = None
    for i in range(len(offset_data)):
        d_scl, d_gcd, a = offset_data[i]
        if d_scl != curr_d:
            curr_d = d_scl
            visible_asteroids.append(a)

    return visible_asteroids
    
def count_visible_asteroids(asteroids):
    n_visible = dict()
    
    for a in asteroids:
        n = len(visible_asteroids(asteroids, a))
        n_visible[a] = n

    return n_visible

def best_station_location(asteroids):
    n_visible = count_visible_asteroids(asteroids)

    asters = list(n_visible.keys())
    n_vis  = list(n_visible.values())

    best_n_visible = max(n_vis)
    idx_best = n_vis.index(best_n_visible)    
    
    return asters[idx_best], n_vis[idx_best]

if __name__ == '__main__':
    # Example 1
    input_map = ['.#..#',
                 '.....',
                 '#####',
                 '....#',
                 '...##']    
    best_pos = (3,4)
    best_vis = 8
    asteroids = get_asteroids(input_map)
    assert(best_station_location(asteroids) == (best_pos, best_vis))    
    

    # Example 2
    input_map = ['......#.#.',
                 '#..#.#....',
                 '..#######.',
                 '.#.#.###..',
                 '.#..#.....',
                 '..#....#.#',
                 '#..#....#.',
                 '.##.#..###',
                 '##...#..#.',
                 '.#....####']
    best_pos = (5,8)
    best_vis = 33
    asteroids = get_asteroids(input_map)
    assert(best_station_location(asteroids) == (best_pos, best_vis))
    
    # Example 3
    input_map = ['#.#...#.#.',
                 '.###....#.',
                 '.#....#...',
                 '##.#.#.#.#',
                 '....#.#.#.',
                 '.##..###.#',
                 '..#...##..',
                 '..##....##',
                 '......#...',
                 '.####.###.']
    best_pos = (1,2)
    best_vis = 35
    asteroids = get_asteroids(input_map)
    assert(best_station_location(asteroids) == (best_pos, best_vis))
    
    # Example 4
    input_map = ['.#..#..###',
                 '####.###.#',
                 '....###.#.',
                 '..###.##.#',
                 '##.##.#.#.',
                 '....###..#',
                 '..#.#..#.#',
                 '#..#.#.###',
                 '.##...##.#',
                 '.....#.#..']
    best_pos = (6,3)
    best_vis = 41
    asteroids = get_asteroids(input_map)
    assert(best_station_location(asteroids) == (best_pos, best_vis))
    
    # Example 5
    input_map = ['.#..##.###...#######',
                 '##.############..##.',
                 '.#.######.########.#',
                 '.###.#######.####.#.',
                 '#####.##.#.##.###.##',
                 '..#####..#.#########',
                 '####################',
                 '#.####....###.#.#.##',
                 '##.#################',
                 '#####.##.###..####..',
                 '..######..##.#######',
                 '####.##.####...##..#',
                 '.#####..#.######.###',
                 '##...#.##########...',
                 '#.##########.#######',
                 '.####.#.###.###.#.##',
                 '....##.##.###..#####',
                 '.#.#.###########.###',
                 '#.#.#.#####.####.###',
                 '###.##.####.##.#..##']
    best_pos = (11,13)
    best_vis = 210
    asteroids = get_asteroids(input_map)
    assert(best_station_location(asteroids) == (best_pos, best_vis))

    input_map = get_input('./input/input_day_10.txt')
    asteroids = get_asteroids(input_map)    
    best_pos, best_vis = best_station_location(asteroids)
    print('Solution to Part 1: {}'.format(best_vis))
    
