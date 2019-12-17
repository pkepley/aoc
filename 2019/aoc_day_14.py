from math import ceil, inf

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

    def clear(self):
        for chem_name in self.chemicals.keys():
            self.chemicals[chem_name]['production'] = 0
            self.chemicals[chem_name]['inventory'] = 0            
                     
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
                

def find_max_production(rxns, available_ore):
    ore_required = -1
    
    fuel_production = 1
    lower_bound = 1
    upper_bound = inf
    cf = chemical_factory(rxns)
    
    while fuel_production < upper_bound:
        fuel_production_multiplier = 1
        
        while ore_required <= available_ore:
            fuel_production_multiplier *= 2
            fuel_production = lower_bound + fuel_production_multiplier

            # Clear factory prdouction and produce FUEL
            cf.clear()
            cf.produce('FUEL', fuel_production)        
            ore_required = cf.chemicals['ORE']['production']

        # Reset bounds
        lower_bound = lower_bound + int(fuel_production_multiplier / 2)
        upper_bound = lower_bound + fuel_production_multiplier
        fuel_production = lower_bound

        cf.clear()
        cf.produce('FUEL', lower_bound)       
        ore_required = cf.chemicals['ORE']['production']
        if ore_required > available_ore:
            break

    # Back-off because we went one too far in tests
    lower_bound -= 1

    return lower_bound
        
if __name__ == '__main__':
    rxns = get_input('./input/input_day_14.txt')

    # Solution to part 1
    cf  = chemical_factory(rxns)
    cf.produce('FUEL', 1)
    s1 = cf.chemicals['ORE']['production']
    print("Solution part 1: {}".format(s1))

    # Solution to part 1
    cf  = chemical_factory(rxns)
    cf.produce('FUEL', 1)
    s2 = find_max_production(rxns, 1000000000000)
    print("Solution part 2: {}".format(s2))
    
    # rxn_str = '''157 ORE => 5 NZVS
    # 165 ORE => 6 DCFZ
    # 44 XJWVT, 5 KHKGT, 1 QDVJ, 29 NZVS, 9 GPVTF, 48 HKGWZ => 1 FUEL
    # 12 HKGWZ, 1 GPVTF, 8 PSHF => 9 QDVJ
    # 179 ORE => 7 PSHF
    # 177 ORE => 5 HKGWZ
    # 7 DCFZ, 7 PSHF => 2 XJWVT
    # 165 ORE => 2 GPVTF
    # 3 DCFZ, 7 NZVS, 5 HKGWZ, 10 PSHF => 8 KHKGT'''
    # rxns = parse_rxn_description(rxn_str)    
    # print(find_max_production(rxns, 1000000000000))

    # rxn_str = '''171 ORE => 8 CNZTR
    # 7 ZLQW, 3 BMBT, 9 XCVML, 26 XMNCP, 1 WPTQ, 2 MZWV, 1 RJRHP => 4 PLWSL
    # 114 ORE => 4 BHXH
    # 14 VRPVC => 6 BMBT
    # 6 BHXH, 18 KTJDG, 12 WPTQ, 7 PLWSL, 31 FHTLT, 37 ZDVW => 1 FUEL
    # 6 WPTQ, 2 BMBT, 8 ZLQW, 18 KTJDG, 1 XMNCP, 6 MZWV, 1 RJRHP => 6 FHTLT
    # 15 XDBXC, 2 LTCX, 1 VRPVC => 6 ZLQW
    # 13 WPTQ, 10 LTCX, 3 RJRHP, 14 XMNCP, 2 MZWV, 1 ZLQW => 1 ZDVW
    # 5 BMBT => 4 WPTQ
    # 189 ORE => 9 KTJDG
    # 1 MZWV, 17 XDBXC, 3 XCVML => 2 XMNCP
    # 12 VRPVC, 27 CNZTR => 2 XDBXC
    # 15 KTJDG, 12 BHXH => 5 XCVML
    # 3 BHXH, 2 VRPVC => 7 MZWV
    # 121 ORE => 7 VRPVC
    # 7 XCVML => 6 RJRHP
    # 5 BHXH, 4 VRPVC => 5 LTCX'''
    # rxns = parse_rxn_description(rxn_str)    
    # print(find_max_production(rxns, 1000000000000))

    
