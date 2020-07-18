def read_data(file_path):
    with open(file_path, "r") as f:
        data = f.readlines()    
    f.close()    
    return data[0].rstrip("\n")

class node:
    def __init__(self, parent, n_children, n_metadata):
        self.n_children = n_children
        self.n_metadata = n_metadata
        self.parent = parent
        self.children = []
        self.metadata = []

    def get_parent(self):
        return parent

    def get_child(self, i):
        return self.children[i]
    
    def has_unparsed_children(self):
        return len(self.children) < self.n_children

    def has_unparsed_metadata(self):
        return len(self.metadata) < self.n_metadata

    def printer(self):
        print(self.n_children, self.n_metadata, len(self.children),
              len(self.metadata), self.metadata)
        
    def sum_meta_below(self):        
        if self.n_children == 0:
            return sum(self.metadata)
        else:                
            return sum(self.metadata) + sum([child.sum_meta_below() for child in self.children])

    def value(self):
        if self.n_children == 0:
            return sum(self.metadata)
        else:
            val = 0
            for m in self.metadata:
                # m is the index of a child, valid values of m run from 1 to n_children
                # m = 1 refers to children[0], and so on
                if m > 0 and m <= self.n_children:                    
                    val += self.children[m-1].value()
            return val

def parse_data(data_str):
    split_str = " "
    data = [int(x) for x in data_str.split(split_str)]

    n_children = 1
    n_metadata = 0
    current_node = node(None, n_children, n_metadata)    
    cursor = 0

    while cursor < len(data):              
        if current_node.has_unparsed_children():                
            n_children = data[cursor]
            n_metadata = data[cursor + 1]
            child_node = node(current_node, n_children, n_metadata)
            current_node.children.append(child_node)
            current_node = child_node
            if cursor == 0:
                # If this is the first node read in, it's the root node
                root_node = current_node
            cursor += 2

        elif current_node.has_unparsed_metadata():
            # Parse the metadata for the current node
            for i in range(current_node.n_metadata):
                current_node.metadata.append(data[cursor+i])
            cursor = cursor + current_node.n_metadata
            
        else:
            # Set current node to parent node
            current_node = current_node.parent

    return root_node


if __name__ == "__main__":
    ex_license_file = "2 3 0 3 10 11 12 1 1 0 1 99 2 1 1 2"
    ex_root_node = parse_data(ex_license_file) 
    print("Example Part 1: {}".format(ex_root_node.sum_meta_below()))
    print("Example Part 2: {}".format(ex_root_node.value()))

    license_file = read_data("./input/aoc_08.txt")
    root_node = parse_data(license_file)
    print("Part 1: {}".format(root_node.sum_meta_below()))
    print("Part 2: {}".format(root_node.value()))
