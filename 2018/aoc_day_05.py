from string import ascii_lowercase

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

def remove_and_react(in_str):
    in_str = in_str.replace("\n", "")
    letters = ascii_lowercase
    reduced_react_str_lens = []

    for letter in letters:    
        reduced_str = filter(lambda x: x.lower() != letter, in_str)
        reduced_reacted_str = react_string(reduced_str)
        reduced_react_str_lens.append(len(reduced_reacted_str))
    
    shortest_str_len = min(reduced_react_str_lens)
    idx_shortest = reduced_react_str_lens.index(shortest_str_len)
    
    return shortest_str_len
        
if __name__ == "__main__":
    ex1_str = "dabAcCaCBAcCcaDA"
    print("Example Part 1 : {}".format(react_string(ex1_str)))
    print("Example Part 2 : {}".format(remove_and_react(ex1_str)))    

    data_str = read_data("./input/aoc_5.txt")
    reaction_part_1 = react_string(data_str)
    print("Part 1 : {}".format(len(reaction_part_1)))
    print("Part 2 : {}".format(remove_and_react(data_str)))    



    
