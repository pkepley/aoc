def get_input(input_file):
    # Get data
    f = open(input_file)
    orbits = [orbit.replace('\n','') for orbit in list(f)]
    f.close()
       
    return orbits

class orbit_node:
    def __init__(self, name, parent=None):
        self.name = name
        self.parent = parent
        self.children = []

        if self.parent is not None:
            self.parent.append(self)

    def append(self, child_node):
        if child_node not in self.children:        
            self.children.append(child_node)

        if child_node.parent != self:
            child_node.parent.children.remove(child_node)
            child_node.parent = self

    def direct_orbits(self):
        return len(self.children)
    
    def indirect_orbits(self):
        return sum([c.direct_orbits() + c.indirect_orbits() for c in self.children])

    def checksum(self):
        return self.direct_orbits() + self.indirect_orbits() + sum([c.checksum() for c in self.children])
        
    def __str__(self):
        if self.parent is None:
            parent_name = "None"
        else:
            parent_name = self.parent.name            

        str_repr = "orbit_node: name {0} parent {1}\n".format(self.name, parent_name)
        str_repr += "direct {2} indirect {3} checksum {4}\n".format(self.direct_orbits(),
                                                                    self.indirect_orbits(),
                                                                    self.checksum())
        str_repr += "children {5}".format([c.name for c in self.children])

        return str_repr
        
def orbit_tree(orbit_map):
    orbit_tree = {'COM' : orbit_node('COM')}
    
    for orbit in orbit_map:
        parent_name = orbit.split(')')[0]
        child_name  = orbit.split(')')[1]

        # If parent isn't in list already, create one and set its parent to orbit COM
        if parent_name not in orbit_tree:
            orbit_tree[parent_name] = orbit_node(parent_name, parent=orbit_tree['COM'])
        parent_node = orbit_tree[parent_name]                    

        # Create a child node if it doesn't already exist
        if child_name not in orbit_tree:
            child_node = orbit_node(child_name, parent=parent_node)
            orbit_tree[child_name] = child_node            
        child_node  = orbit_tree[child_name]

        # Append the child to the parent node        
        parent_node.append(child_node)
        
    return orbit_tree

        
if __name__ == '__main__':
    # Test for part 1
    orbit_map = ['COM)B', 'B)C', 'C)D', 'D)E', 'E)F', 'B)G',
                 'G)H', 'D)I', 'E)J', 'J)K','K)L']    
    ot = orbit_tree(orbit_map)
    assert(ot['COM'].checksum() == 42)

    # Solve part 1
    orbit_map = get_input('./input/input_day_6.txt')
    ot = orbit_tree(orbit_map)
    print("Solution to Part 1: {}".format(ot['COM'].checksum()))
    
    
