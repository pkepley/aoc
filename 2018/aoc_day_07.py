from functools import reduce

def read_data(file_path):
    with open(file_path, "r") as f:
        data = f.readlines()    
    f.close()    
    return data

def parse_data(data):
    split_str = " must be finished before step "
    tmp_data = [x.split(split_str) for x in [d for d in data if split_str in d]]
    parents  = [x[0][-1] for x in tmp_data]
    children = [x[1][0]  for x in tmp_data]
    tree_data =  zip(parents, children)
    return tree_data


def build_tree(tree_data):
    tree = []

    for d in tree_data:
        p, c = d
        
        if len(tree) == 0 or p not in [e[0] for e in tree]:
            tree.append([p, [], [c]])
        else:
            idx = [e[0] for e in tree].index(p)
            tree[idx][2].append(c)

        if c not in [e[0] for e in tree]:
            tree.append([c, [p], []])
        else:
            idx = [e[0] for e in tree].index(c)
            tree[idx][1].append(p)
            
    return tree
    
def parse_tree(tree):    
    active_processes   = sorted(tree[:], key = lambda x: x[0])
    complete_processes = []
    
    while len(active_processes) > 0:
        for i, ap in enumerate(active_processes):
            if (len(ap[1]) == 0 or 
                reduce(lambda x,y : x and y, [z in complete_processes for z in ap[1]])):
                complete_processes.append(ap[0])
                active_processes.pop(i)
                break

    return complete_processes

if __name__ == "__main__":
    test_str = (
        """Step C must be finished before step A can begin.
Step C must be finished before step F can begin.
Step A must be finished before step B can begin.
Step A must be finished before step D can begin.
Step B must be finished before step E can begin.
Step D must be finished before step E can begin.
Step F must be finished before step E can begin.
"""
    )
    tree_data = parse_data(test_str.split("\n"))
    tree = build_tree(tree_data)
    process_order = "".join(parse_tree(tree))
    print("Test Part 1: {}".format(process_order))

    tree_data = parse_data(read_data("./input/aoc_07.txt"))
    tree = build_tree(tree_data)
    process_order = "".join(parse_tree(tree))
    print("Part 1: {}".format(process_order))
