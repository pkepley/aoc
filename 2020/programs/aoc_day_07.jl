### A Pluto.jl notebook ###
# v0.12.16

using Markdown
using InteractiveUtils

# ╔═╡ 3e7eb81e-3a31-11eb-3ba0-199c4bc52f24
#= 
🎄 Solutions for Day 7! 🎄

🌟 Part 1: Count all bags that can contain your bag 👜!
Part 2: Count all bags that your bag must contain 👜!
=#

# ╔═╡ 0f6875f6-39d2-11eb-20bc-adca71124e23
function parse_input(s)
	return split(s, "\n", keepempty=false)	
end

# ╔═╡ 306357f6-39d9-11eb-1c8a-8b5f4fcba903
function parse_rule(rule_descriptor)
	container, contents = split(rule_descriptor, " contain ")

	# parse the bag type (color) from the container string
	container = match(r"([A-z ]{1,})(?= bag)", container)[1]
	
	# handle contents
	if contents[1:2] == "no"
		contents = Dict()
	else
		bag_parser = r"((?<= )([A-z ]{1,})(?= bag))|([0-9]{1,})"
		contents = split(contents, ',', keepempty = false)		
		contents = map(s -> SubString.(s, findall(bag_parser, s)), contents)
		
		# always in number, bag type order. 
		# re-order and convert number to int:
		contents = map(vk -> (vk[2], parse(Int, vk[1])), contents) 
		contents = Dict(contents)
	end
	
	return container, contents
end

# ╔═╡ f9530ed6-39e3-11eb-096a-7142185d0bde
function add_node!(rule_graph, bag, contents=Dict(), predecessor=nothing)	
	if ~haskey(rule_graph, bag)
		if predecessor == nothing
			rule_graph[bag] = ([], contents)
		else
			rule_graph[bag] = ([predecessor], contents)
		end
	else
		ancestors, existing_contents = rule_graph[bag]
		if predecessor != nothing
			ancestors = append!(ancestors, [predecessor])
		end
		contents = merge!(contents, existing_contents)
		rule_graph[bag] = (ancestors, contents)
	end
	
	for child_bag in keys(contents)
		add_node!(rule_graph, child_bag, Dict(), bag)
	end
end

# ╔═╡ bc391a24-39e1-11eb-3609-1f26acb50fc4
function rule_graph(bag_rule_descriptions)
	bag_rules = map(parse_rule, bag_rule_descriptions)	
	rule_graph = Dict()
	
	for rule ∈ bag_rules
		bag, contents = rule
		add_node!(rule_graph, bag, contents)
	end
	
	return rule_graph
end

# ╔═╡ 97b117a8-3a2d-11eb-38cf-5f401d063f75
function get_ancestors(rule_graph, bag)
	exploration_stack = []
	bag_types = collect(keys(rule_graph))
	n_bags = length(bag_types)
	bag_discovered = Dict(zip(bag_types, zeros(Bool, n_bags)))
	
	# https://en.wikipedia.org/wiki/Depth-first_search non-recursive
	push!(exploration_stack, bag)	
	while exploration_stack != []
		v = pop!(exploration_stack)
				
		if ~bag_discovered[v] 
			bag_discovered[v] = true
			predecessors = rule_graph[v][1]				
			
			for pred ∈ predecessors
				if pred != nothing
					push!(exploration_stack, pred)
				end
			end
		end
	end
	
	return [b for b ∈ bag_types if bag_discovered[b] == true & cmp(b, bag) != 0] 
end

# ╔═╡ 8a832260-39ee-11eb-01cc-cb09d57fe8f6
function solve_prob_1(bag_rule_descriptions, my_bag_type="shiny gold")
	bag_rule_graph = rule_graph(bag_rule_descriptions)	
	return length(get_ancestors(bag_rule_graph, my_bag_type))	
end

# ╔═╡ 37216bf0-39d4-11eb-3397-9fb7369f0f1c
############################ Day 7 Examples+Tests ################################
begin 
	example_inpt_1 = """
light red bags contain 1 bright white bag, 2 muted yellow bags.
dark orange bags contain 3 bright white bags, 4 muted yellow bags.
bright white bags contain 1 shiny gold bag.
muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.
shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.
dark olive bags contain 3 faded blue bags, 4 dotted black bags.
vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.
faded blue bags contain no other bags.
dotted black bags contain no other bags.
"""
	example_bag_rules_1 = parse_input(example_inpt_1)
	
example_inpt_2 = """shiny gold bags contain 2 dark red bags.
dark red bags contain 2 dark orange bags.
dark orange bags contain 2 dark yellow bags.
dark yellow bags contain 2 dark green bags.
dark green bags contain 2 dark blue bags.
dark blue bags contain 2 dark violet bags.
dark violet bags contain no other bags."""
	
	example_bag_rules_2 = parse_input(example_inpt_2)	
end

# ╔═╡ 304fe856-39ea-11eb-20af-c53e3b6d9a2b
@assert solve_prob_1(example_bag_rules_1, "shiny gold") == 4

# ╔═╡ 41b86a98-39d2-11eb-2a5b-29a9f516215a
############################ Day 7 Solution #################################
begin
	input_path = "../input/input_day_07.txt"	
	
	s_input = open(input_path) do file
		read(file, String)
	end	

	problem_bag_rules = parse_input(s_input)
end

# ╔═╡ e2e290da-39ee-11eb-3f87-97ecb6777676
part_1_soln = solve_prob_1(problem_bag_rules, "shiny gold")

# ╔═╡ 2ba2dbbc-3a31-11eb-13bc-8542964983ec
println("Day 7: Part 1: ", part_1_soln)

# ╔═╡ Cell order:
# ╠═3e7eb81e-3a31-11eb-3ba0-199c4bc52f24
# ╠═0f6875f6-39d2-11eb-20bc-adca71124e23
# ╠═306357f6-39d9-11eb-1c8a-8b5f4fcba903
# ╠═bc391a24-39e1-11eb-3609-1f26acb50fc4
# ╠═f9530ed6-39e3-11eb-096a-7142185d0bde
# ╠═97b117a8-3a2d-11eb-38cf-5f401d063f75
# ╠═8a832260-39ee-11eb-01cc-cb09d57fe8f6
# ╠═37216bf0-39d4-11eb-3397-9fb7369f0f1c
# ╠═304fe856-39ea-11eb-20af-c53e3b6d9a2b
# ╠═41b86a98-39d2-11eb-2a5b-29a9f516215a
# ╠═e2e290da-39ee-11eb-3f87-97ecb6777676
# ╠═2ba2dbbc-3a31-11eb-13bc-8542964983ec
