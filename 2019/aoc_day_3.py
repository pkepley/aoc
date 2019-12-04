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


def path_intersections(edges_A, edges_B):
    edges_A = sorted([sorted(e) for e in edges_A])
    edges_B = sorted([sorted(e) for e in edges_B])

    pass


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


    # Solve things...    
    print(get_input('./input/input_day_3.txt'))
    print(path_vertices(['R75','D30','R83','U83','L12','D49','R71','U7','L72']))
    print(path_edges(['R75','D30','R83','U83','L12','D49','R71','U7','L72']))
