def read_data(file_path):
    with open(file_path, "r") as f:
        data = f.readlines()
    f.close()    
    return data

def map_data(raw_data):
    data    = map(lambda x: x.split(" "), raw_data)
    clm_num = map(lambda x: int(x[0].replace("#", "")), data)
    clm_pos = map(lambda x: map(int, x[2].replace(":","").split(",")), data)
    clm_shp = map(lambda x: map(int, x[3].split("x")), data)
    return (clm_num, clm_pos, clm_shp)

def mark_claims (clm_num, clm_pos, clm_shp, fabric_size = 1000):
    claims_made = [[[] for j in range(fabric_size)] for i in range(fabric_size)]
    n_claims = len(clm_num)
    for k in range(n_claims):
        clm_id = clm_num[k]
        clm_x, clm_y = clm_pos[k]
        clm_w, clm_h = clm_shp[k]
        for i in range(clm_w):                        
            for j in range(clm_h):            
                claims_made[clm_y+j][clm_x+i].append(clm_id)        
    return claims_made

def count_overlap_claims(claims_made):
    n_overlap_claims = 0
    for row in claims_made:
        for tile in row:
            if len(tile) > 1:
                n_overlap_claims += 1
    return n_overlap_claims


def nonoverlap_claim(n_clm, claims_made):
    overlapping = [False for i in range(n_clm+1)]
    
    for row in claims_made:
        for tile in row:
            if len(tile) > 1:
                for clm in tile:
                    overlapping[clm] = True

    for i in range(1, n_clm+1):
        if overlapping[i] == False:
            return i
           
if __name__ == "__main__":     
    raw_data = read_data("./input/aoc_3.txt")
    clm_num, clm_pos, clm_shp = map_data(raw_data)
    claims_made = mark_claims(clm_num, clm_pos, clm_shp)
    print("Part 1: {}".format(count_overlap_claims(claims_made)))

    n_clm = len(clm_num)
    print("Part 2: {}".format(nonoverlap_claim(n_clm, claims_made)))
