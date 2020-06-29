def split_digits(n):
    return [int(d) for d in list(str(n))]
  
def combine_digits(ds):
    return int(''.join([str(d) for d in ds]))

def is_valid_pw_p1(n):
    ds = split_digits(n)

    # Check for increasing ordering
    for i in range(len(ds) - 1):
        if ds[i+1] < ds[i]:
            return False

    # Password must have doubles (so set len < list len)
    return len(list(set(ds))) < len(list(ds))

def is_valid_pw_p2(n):
    if is_valid_pw_p1(n):
        ds = split_digits(n)
        d_counts = [ds.count(d) for d in set(ds)]
        return 2 in d_counts
        
    else:
        return False
  
def solve_part_1(low_pw, high_pw):
    valid_pws = [n for n in range(low_pw, high_pw+1) if is_valid_pw_p1(n)]
    return len(valid_pws)

def solve_part_2(low_pw, high_pw):
    valid_pws = [n for n in range(low_pw, high_pw+1) if is_valid_pw_p2(n)]
    return len(valid_pws)
  
if __name__ == '__main__':
    assert([1,2,3] == split_digits(123))
    assert(456 == combine_digits([4,5,6]))

    # Check valid pw function works for part 1
    assert(is_valid_pw_p1(111111) == True)
    assert(is_valid_pw_p1(223450) == False)
    assert(is_valid_pw_p1(123789) == False)        

    # Check valid pw function works for part 2
    assert(is_valid_pw_p2(112233) == True)
    assert(is_valid_pw_p2(123444) == False)
    assert(is_valid_pw_p2(111122) == True)        
    
    # Solve parts 1 and 2
    low_pw = 145852
    high_pw = 616942
    s1 = solve_part_1(low_pw, high_pw)
    s2 = solve_part_2(low_pw, high_pw)   
    print("Solution to part 1: {}".format(s1))
    print("Solution to part 2: {}".format(s2))    
