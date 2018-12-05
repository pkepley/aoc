def read_data(file_path):
    with open(file_path, "r") as f:
        data = f.readlines()
    f.close()    
    return "".join(data)

def react_string(in_str):
    data = list(in_str.replace("\n", ""))
    n_units = len(data)
    stack = []
    for i in range(n_units):
        stack.append(data[i])
        while len(stack) >= 2 and stack[-2].upper() == stack[-1].upper():
            if (stack[-2].islower() and stack[-1].isupper()) or (stack[-2].isupper() and stack[-1].islower()):
                stack.pop()
                stack.pop()
            else:
                break
    out_str = "".join(stack)
    return out_str



    
if __name__ == "__main__":
    ex1_str = "dabAcCaCBAcCcaDA"
    print("Example Part 1 : {}".format(react_string(ex1_str)))
    
    data_str = read_data("./input/aoc_5.txt")
    reaction_part_1 = react_string(data_str)
    print("Part 1 : {}".format(len(reaction_part_1)))
