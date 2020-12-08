### A Pluto.jl notebook ###
# v0.12.16

using Markdown
using InteractiveUtils

# ╔═╡ a4ce37e4-3986-11eb-162e-d13757f65b00
#=
🎁 Solutions for Day 6! 🎁

🌟 Part 1: Sum the counts of unique customs responses!
🌟 Part 2: Sum the counts of unanimous customs responses!
=#

# ╔═╡ e713e662-3986-11eb-3412-bff4314fd303
function parse_input(s)
	inpt = split(s, "\n\n", keepempty=false)	
	return [split(s, '\n', keepempty=false) for s ∈ inpt]
end

# ╔═╡ 66644330-3987-11eb-1509-f59a628b48bb
function unique_customs_responses(group_responses)	
	return Set(join(group_responses))
end

# ╔═╡ ee81dec0-399c-11eb-03a4-4fe0c62d0136
function all_yes_responses(group_responses)
	group_size = length(group_responses)
	joined_responses = join(group_responses)
	unique_responses = Set(joined_responses)	
	all_responded = [r for r in unique_responses if 
				count(x->x==r, joined_responses) == group_size]
	
	return all_responded
end

# ╔═╡ fea3f0c8-3987-11eb-1b31-310137b7b4a3
function solve_prob_1(customs_responses)
	unique_responses = map(unique_customs_responses, customs_responses)
	return sum([length(uniq_resp) for uniq_resp ∈ unique_responses])
end

# ╔═╡ cd6162d2-399d-11eb-29aa-478e087132eb
function solve_prob_2(customs_responses)
	unanimous_responses = map(all_yes_responses, customs_responses)
	return sum([length(unam_resp) for unam_resp ∈ unanimous_responses])
end

# ╔═╡ fabaaa70-3986-11eb-1218-d3290fac1f84
############################ Day 6 Tests ##############################
begin 	
example_input = """abc

a
b
c

ab
ac

a
a
a
a

b"""
	example_customs_answers = parse_input(example_input)
end

# ╔═╡ c33ab40e-3987-11eb-1972-2762ceb5b2bf
begin 
	@assert solve_prob_1(example_customs_answers) == 11
	@assert solve_prob_2(example_customs_answers) == 6
end

# ╔═╡ a1fbbdac-3989-11eb-2d19-eb80d2a99bfb
############################ Day 6 Solution #################################
begin
	input_path = "../input/input_day_06.txt"	
	
	s_input = open(input_path) do file
		read(file, String)
	end	

	problem_customs_answers = parse_input(s_input)
end

# ╔═╡ 058c499a-3987-11eb-3145-cdaa3cde6eff
part_1_soln = solve_prob_1(problem_customs_answers)

# ╔═╡ f5a9975a-399d-11eb-2b43-576e36c206eb
println("Day 6: Part 1: ", part_1_soln)

# ╔═╡ f1c0b164-399d-11eb-254f-43dd6124824b
part_2_soln = solve_prob_2(problem_customs_answers)

# ╔═╡ fd2a495c-399d-11eb-21d5-2d1230065b6d
println("Day 6: Part 2: ", part_2_soln)

# ╔═╡ Cell order:
# ╠═a4ce37e4-3986-11eb-162e-d13757f65b00
# ╠═e713e662-3986-11eb-3412-bff4314fd303
# ╠═66644330-3987-11eb-1509-f59a628b48bb
# ╠═ee81dec0-399c-11eb-03a4-4fe0c62d0136
# ╠═fea3f0c8-3987-11eb-1b31-310137b7b4a3
# ╠═cd6162d2-399d-11eb-29aa-478e087132eb
# ╠═fabaaa70-3986-11eb-1218-d3290fac1f84
# ╠═c33ab40e-3987-11eb-1972-2762ceb5b2bf
# ╠═a1fbbdac-3989-11eb-2d19-eb80d2a99bfb
# ╠═058c499a-3987-11eb-3145-cdaa3cde6eff
# ╠═f5a9975a-399d-11eb-2b43-576e36c206eb
# ╠═f1c0b164-399d-11eb-254f-43dd6124824b
# ╠═fd2a495c-399d-11eb-21d5-2d1230065b6d
