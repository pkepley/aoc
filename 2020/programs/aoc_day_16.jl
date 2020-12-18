### A Pluto.jl notebook ###
# v0.12.17

using Markdown
using InteractiveUtils

# ╔═╡ 0b6188b0-3a8b-11eb-112c-77145e1d99b5
#= 
☃️ Solutions for Day 16! ☃️


🌟 Part 1: Parse unknown ticket fields based on some range-based rules. 
           Find a weird "error rate" for tickets with no valid fields. 🎟️
🌟 Part 2: Work backward from observed fields on neighbor tickets to find
           out which fields correspond to which rule. 🎟️
=#

# ╔═╡ b0bbb420-3d62-11eb-050a-99a665672dba
DAY_NUMBER = 16

# ╔═╡ dd120752-3fad-11eb-11e1-4f3cc829814b
function rule_type_and_parser(rule_description)
	rule_type, rule_contents = split(rule_description, ":")

	rule_contents = split(rule_contents, "or")
	rule_contents = map(r -> split(r, "-"), rule_contents)
	rule_contents = map(r -> map(n -> parse(Int, n), r), rule_contents)

	rule_parser = function rule_parser(x)
		for rc ∈ rule_contents
			if rc[1] ≤ x & x ≤ rc[2]
				return true
			end
		end
		return false
	end

	return rule_type, rule_parser
end

# ╔═╡ 81e88cb0-3a8b-11eb-3aba-a3509bff5912
function parse_input(s)
	blocks = split(s, "\n\n", keepempty=false)		
	
	# first block contains the rules
	rules = split(blocks[1], "\n", keepempty=false)
	rules = map(rule_type_and_parser, rules)
	
	# next block is my ticket
	your_ticket = split(blocks[2], "\n",keepempty=false)[2]
	your_ticket = map(x -> parse(Int, x), split(your_ticket, ","))
	
	# finally, all the nearby tickets for comparisons
	nearby_tickets = split(blocks[3], "\n",keepempty=false)[2:end]
	nearby_tickets = map(t-> map(x -> parse(Int, x), split(t, ",")), nearby_tickets)
	
	return rules, your_ticket, nearby_tickets
end

# ╔═╡ a4f53950-40a4-11eb-25c9-05bc8278b919
function remove_invalid_tickets(rules, tickets)
	valid_tickets = []
	
	for ticket ∈ tickets
		field_has_match = zeros(Bool, length(ticket))
		
		for (rule_name, rule) ∈ rules
			field_has_match = map(rule, ticket) .| field_has_match
		end
		
		ticket_is_valid = foldl(&, field_has_match)
		
		if ticket_is_valid
			push!(valid_tickets, ticket)
		end
		
	end
	
	return valid_tickets
	
end

# ╔═╡ f1109a84-3a8f-11eb-3ca8-2fdbdd1cc29a
function solve_prob_1(inpt)
	(rules, your_ticket, nearby_tickets) = parse_input(inpt)
	
	error_rate = 0
	
	for ticket ∈ nearby_tickets
		field_has_match = zeros(Bool, length(ticket))
		
		for (rule_name, rule) ∈ rules
			field_has_match = map(rule, ticket) .| field_has_match
		end
		
		unmatched_fields = ticket[.!field_has_match]
		error_rate += sum(unmatched_fields)
	end
	
	return error_rate
end

# ╔═╡ 1387743a-4142-11eb-0a74-199809f044a2
function determine_rules(rules, valid_tickets)
	# how many fields on ticket?
	n_fields = length(valid_tickets[1])
	
	# determine possibilities for each rule
	possible_rule_idxs = Dict()		
	for (rule_name, rule) ∈ rules
		for idx = 1:n_fields
			assign_idx = foldl(&, map(rule, [t[idx] for t ∈ valid_tickets]))		
			if assign_idx == true
				if !haskey(possible_rule_idxs, rule_name)
					possible_rule_idxs[rule_name] = [idx]
				else					
					push!(possible_rule_idxs[rule_name], idx)
				end
			end
		end
	end
	
	
	# assign the rules 
	assigned_rule_idxs = Dict()	
	while length(assigned_rule_idxs) < n_fields
		for rule ∈ keys(possible_rule_idxs)
			
			# only one candidate idx for rule. assign it, and remove
			# it as a possibility for all others
			if length(possible_rule_idxs[rule]) == 1				
				# assign idx to rule
				idx_rule = possible_rule_idxs[rule][1]				
				assigned_rule_idxs[rule] = idx_rule
				
				# remove rule from the pool of unassigned rules
				pop!(possible_rule_idxs, rule)
				
				# remove idx as a possibility for all other rules
				for other_rules ∈ keys(possible_rule_idxs)
					possible_rule_idxs[other_rules] = filter!(i->(i != idx_rule), 
						possible_rule_idxs[other_rules])
				end
			end
		end
	end
	
	return assigned_rule_idxs
end

# ╔═╡ 129f488c-3a93-11eb-260e-8921353e1039
function solve_prob_2(inpt)
	(rules, your_ticket, nearby_tickets) = parse_input(inpt)
	valid_tickets = remove_invalid_tickets(rules, nearby_tickets)	
	rule_idxs = determine_rules(rules, valid_tickets)
	
	return prod([your_ticket[rule_idxs[k]] for k ∈ keys(rule_idxs)
				 if occursin("departure", k)])			
end

# ╔═╡ 8e4e5560-3a8c-11eb-2612-577833ceee7e
############################ Examples+Tests ################################
begin 
	example_input_1="""
class: 1-3 or 5-7
row: 6-11 or 33-44
seat: 13-40 or 45-50

your ticket:
7,1,14

nearby tickets:
7,3,47
40,4,50
55,2,20
38,6,12
"""
	
	example_input_2="""
class: 0-1 or 4-19
row: 0-5 or 8-19
seat: 0-13 or 16-19

your ticket:
11,12,13

nearby tickets:
3,9,18
15,1,5
5,14,9
"""
end

# ╔═╡ f3f072bc-3a8d-11eb-3b54-719f2924e9d2
begin
	@assert solve_prob_1(example_input_1) == 71
end

# ╔═╡ ed7ca23c-3a8f-11eb-34fe-dd7cf712377b
############################ Solution ############################
begin
	input_path = "../input/input_day_$DAY_NUMBER.txt"
	
	problem_input = open(input_path) do file

		read(file, String)
	end	
end

# ╔═╡ 5b37cd42-3a90-11eb-25a3-6105e801b231
part_1_soln = solve_prob_1(problem_input)

# ╔═╡ 52110486-3a90-11eb-3a4f-11a08a8bd71f
println("Day $DAY_NUMBER: Part 1: $part_1_soln")

# ╔═╡ 3180ae1c-3a93-11eb-01ab-13cc9be93b67
part_2_soln = solve_prob_2(problem_input)

# ╔═╡ 2c64697a-3a96-11eb-34ea-ff7f4a67aa99
println("Day $DAY_NUMBER: Part 2: $part_2_soln")

# ╔═╡ Cell order:
# ╠═0b6188b0-3a8b-11eb-112c-77145e1d99b5
# ╠═b0bbb420-3d62-11eb-050a-99a665672dba
# ╠═81e88cb0-3a8b-11eb-3aba-a3509bff5912
# ╠═dd120752-3fad-11eb-11e1-4f3cc829814b
# ╠═a4f53950-40a4-11eb-25c9-05bc8278b919
# ╠═f1109a84-3a8f-11eb-3ca8-2fdbdd1cc29a
# ╠═1387743a-4142-11eb-0a74-199809f044a2
# ╠═129f488c-3a93-11eb-260e-8921353e1039
# ╠═8e4e5560-3a8c-11eb-2612-577833ceee7e
# ╠═f3f072bc-3a8d-11eb-3b54-719f2924e9d2
# ╠═ed7ca23c-3a8f-11eb-34fe-dd7cf712377b
# ╠═5b37cd42-3a90-11eb-25a3-6105e801b231
# ╠═52110486-3a90-11eb-3a4f-11a08a8bd71f
# ╠═3180ae1c-3a93-11eb-01ab-13cc9be93b67
# ╠═2c64697a-3a96-11eb-34ea-ff7f4a67aa99
