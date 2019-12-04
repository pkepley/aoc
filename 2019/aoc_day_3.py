def get_input(file_location):
    f = open(file_location)
    lines = list(f)
    f.close()    
    path_descriptions = [l.replace('\n','').split(',') for l in lines]
    
    return path_descriptions

def path_vertices(path_description):
    curr_pos = (0,0)
    vertices = [curr_pos[:]]

    for move in path_description:
        curr_pos = vertices[-1]
        direction = move[0]
        steps = int(move[1:])
        
        if direction == "R":
            vertices.append((curr_pos[0] + steps, curr_pos[1]))
            
        elif direction == "L":
            vertices.append((curr_pos[0] - steps, curr_pos[1]))
            
        elif direction == "U":
            vertices.append((curr_pos[0], curr_pos[1] + steps))
            
        elif direction == "D":
            vertices.append((curr_pos[0], curr_pos[1] - steps))

    return vertices

def path_edges(path_description):
    vertices = path_vertices(path_description)    
    edges = [[vertices[i], vertices[i+1]] for i in range(len(vertices) - 1)]

    return edges    

def segment_intersection(seg_A, seg_B):
    # Order the segments in dictionary order to avoid lots of comparisons below
    seg_A = sorted(seg_A)
    seg_B = sorted(seg_B)

    # Case when Segment A and B are both vertical...
    if (seg_A[0][0] == seg_A[1][0]) and (seg_B[0][0] == seg_B[1][0]):
        # Vertical with different x-coords
        if seg_A[0][0] != seg_B[0][0]:
            return []        
        # Vertical with same x-coords
        else:
            return [(seg_A[0][0], y) for y in range(seg_A[0][1], seg_A[1][1] + 1)
                    if y >= seg_B[0][1] and y <= seg_B[1][1]]

    # Case when Segment A and B are both horizontal...
    if (seg_A[0][1] == seg_A[1][1]) and (seg_B[0][1] == seg_B[1][1]):
        # Horizontal with different y-coords
        if seg_A[0][1] != seg_B[0][1]:
            return []        
        # Horizontal with same y-coords
        else:
            return [(x, seg_A[0][1]) for x in range(seg_A[0][0], seg_A[1][0] + 1)
                    if x >= seg_B[0][0] and x <= seg_B[1][0]]
    
    # Segment A is vertical, Segment B is horizontal:
    elif (seg_A[0][0] == seg_A[1][0]) and (seg_B[0][1] == seg_B[1][1]):
        if ((seg_B[0][0] <= seg_A[0][0] and seg_A[0][0] <= seg_B[1][0]) and
            (seg_A[0][1] <= seg_B[0][1] and seg_B[0][1] <= seg_A[1][1])):
           return [(seg_A[0][0], seg_B[0][1])]
        else:
            return []
    else:
        return segment_intersection(seg_B, seg_A)

def path_intersections(edges_A, edges_B):
    intersection_list = []
    
    for seg_A in edges_A:
        for seg_B in edges_B:
            intersection = segment_intersection(seg_A, seg_B)
            if intersection:
                intersection_list.extend(intersection)
                
    return intersection_list

def edge_length(e):
    return abs(e[1][0] - e[0][0]) + abs(e[1][1] - e[0][1])

def path_nontrivial_intersection_steps(edges_A, edges_B, origin):
    intersection_list = []
    intersection_steps_list_A = []
    intersection_steps_list_B = []    

    steps_A = 0
    steps_B = 0
    
    for seg_A in edges_A:
        steps_B = 0
        for seg_B in edges_B:
            intersection = segment_intersection(seg_A, seg_B)
            if intersection and intersection != [origin]:
                intersection_list.extend(intersection)
                intersection_steps_list_A.extend([steps_A + edge_length([seg_A[0], i]) for i in intersection])
                intersection_steps_list_B.extend([steps_B + edge_length([seg_B[0], i]) for i in intersection])

            steps_B += edge_length(seg_B)
        steps_A += edge_length(seg_A)

    intersection_total_steps = [a+b for (a,b) in zip(intersection_steps_list_A, intersection_steps_list_B)]

    return intersection_total_steps

def distance_to_nontrivial_intersection(origin, points):    
    points = [p for p in points if p != origin]
    distances = [abs(p[0] - origin[0]) + abs(p[1] - origin[1]) for p in points]

    return min(distances)

def solve_part_1(seg_descr_A, seg_descr_B):
    intersections = path_intersections(path_edges(seg_descr_A), path_edges(seg_descr_B))
    
    return distance_to_nontrivial_intersection((0,0), intersections)

def solve_part_2(seg_descr_A, seg_descr_B):
    intersection_total_steps = path_nontrivial_intersection_steps(path_edges(seg_descr_A), path_edges(seg_descr_B), (0,0))

    return min(intersection_total_steps)


if __name__ == '__main__':
    # Test Vertically...
    assert(segment_intersection([(0,0), (0,10)], [(0,-3), (0,8)]) == [(0, y) for y in range(0,8+1)])
    assert(segment_intersection([(0,-3), (0,8)], [(0,0), (0,10)]) == [(0, y) for y in range(0,8+1)])
    assert(segment_intersection([(0,-3), (0,2)], [(0,3), (0,10)]) == [])
    assert(segment_intersection([(0,0), (0,10)], [(1,3), (1,10)]) == [])

    # Test Horizontally...
    assert(segment_intersection([(0,0), (10,0)], [(-4,0), (7,0)]) == [(x, 0) for x in range(0,7+1)])
    assert(segment_intersection([(7,0), (-4,0)], [(0,0), (10,0)]) == [(x, 0) for x in range(0,7+1)])
    assert(segment_intersection([(-3,0), (2,0)], [(3,0), (10,0)]) == [])
    assert(segment_intersection([(0,0), (10,0)], [(3,1), (10,1)]) == [])
    
    # Test Vertical & Horizontal
    assert(segment_intersection([(0,0), (0, 10)], [(-5, 4), (5, 4)]) == [(0, 4)])
    assert(segment_intersection([(-5, 4), (5, 4)], [(0,0), (0, 10)]) == [(0, 4)])    
    assert(segment_intersection([(-5, 4), (-2, 4)], [(0,0), (0, 10)]) == [])    

    # Test distance example 1:
    seg_descr_A = ['R75','D30','R83','U83','L12','D49','R71','U7','L72']
    seg_descr_B = ['U62','R66','U55','R34','D71','R55','D58','R83']
    assert(solve_part_1(seg_descr_A, seg_descr_B) == 159)
    assert(solve_part_2(seg_descr_A, seg_descr_B) == 610)
    
    # Test distance example 2:
    seg_descr_A = ['R98','U47','R26','D63','R33','U87','L62','D20','R33','U53','R51']
    seg_descr_B = ['U98','R91','D20','R16','D67','R40','U7','R15','U6','R7']
    assert(solve_part_1(seg_descr_A, seg_descr_B) == 135)
    assert(solve_part_2(seg_descr_A, seg_descr_B) == 410)    

    # Solve puzzle:    
    seg_descrs = get_input('./input/input_day_3.txt')
    seg_descr_A = seg_descrs[0]
    seg_descr_B = seg_descrs[1]
    s1 = solve_part_1(seg_descr_A, seg_descr_B)
    s2 = solve_part_2(seg_descr_A, seg_descr_B)    
    print("Solution to part 1: {0}".format(s1))
    print("Solution to part 2: {0}".format(s2))    
    
