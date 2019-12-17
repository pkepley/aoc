from math import ceil

def get_input(file_path):
    f = open(file_path, 'r')
    rxn_str = f.read()
    f.close()
    return parse_rxn_description(rxn_str)
    
    
def parse_rxn_description(rxn_str):
    rxn_descr_list = [rxn_descr for rxn_descr in rxn_str.split('\n')
                      if len(rxn_descr) > 0]
    rxn_list = []
    
    for rxn_descr in rxn_descr_list:
        rxn = rxn_descr.replace('=>', ',')
        rxn = rxn.split(',')
        rxn = [r.split(' ') for r in rxn]
        rxn = [[x for x in r if len(x) > 0] for r in rxn]
        rxn = [(r[1], int(r[0])) for r in rxn]

        rxn_list.append(rxn)

    return rxn_list

class chemical_factory:    
    def __init__(self, rxn_list):
        reaction_list = rxn_list[:]

        self.chemicals = dict()
        self.chemicals['ORE'] = {
            'reaction_yield' :  1,
            'reactants'  : [],
            'production' :  0,
            'inventory'  :  0
        }
        
        for rxn in reaction_list:
            chem_reactants = rxn[:-1]            
            chem_name, reaction_yield = rxn[-1]
            
            self.chemicals[chem_name] = {                
                'reaction_yield' : reaction_yield,
                'reactants'  : chem_reactants,
                'production' : 0,
                'inventory'  : 0
            }
                     
    def produce(self, chem_name, quantity):
        chem = self.chemicals[chem_name]
        n_runs = ceil(quantity / chem['reaction_yield'])
        
        for reactant in chem['reactants']:
            react_chem, react_amt = reactant
            self.consume(react_chem, react_amt * n_runs)

        self.chemicals[chem_name]['inventory']  += n_runs * chem['reaction_yield']
        self.chemicals[chem_name]['production'] += n_runs * chem['reaction_yield']

    def consume(self, chem_name, quantity):
        chemical = self.chemicals[chem_name]
        
        if chemical['inventory'] < quantity:
            amt_needed = quantity - chemical['inventory']
            self.produce(chem_name, amt_needed)
            
        chemical['inventory'] -= quantity
                
            
if __name__ == '__main__':
    rxns = get_input('./input/input_day_14.txt')

    # Solution to part 1
    cf  = chemical_factory(rxns)
    cf.produce('FUEL', 1)
    s1 = cf.chemicals['ORE']['production']
    print("Solution part 1: {}".format(s1))
