### A Pluto.jl notebook ###
# v0.12.16

using Markdown
using InteractiveUtils

# ╔═╡ a4ce37e4-3986-11eb-162e-d13757f65b00
#=
🎁 Solutions for Day 6! 🎁

🌟 Part 1: Sum the counts of unique customs responses!
=#

# ╔═╡ e713e662-3986-11eb-3412-bff4314fd303
function parse_input(s)
	inpt = split(s, "\n\n", keepempty=false)	
	return [split(s, '\n') for s ∈ inpt]
end

# ╔═╡ fabaaa70-3986-11eb-1218-d3290fac1f84
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

# ╔═╡ 66644330-3987-11eb-1509-f59a628b48bb
function unique_customs_responses(group_responses)
	return Set(join(group_responses))
end

# ╔═╡ fea3f0c8-3987-11eb-1b31-310137b7b4a3
function solve_prob_1(customs_responses)
	unique_responses = map(unique_customs_responses, customs_responses)
	return sum([length(uniq_resp) for uniq_resp ∈ unique_responses])
end

# ╔═╡ a1fbbdac-3989-11eb-2d19-eb80d2a99bfb
begin
	input_path = "../input/input_day_06.txt"	
	
	s_input = open(input_path) do file
		read(file, String)
	end	

	problem_customs_answers = parse_input(s_input)
end

# ╔═╡ c33ab40e-3987-11eb-1972-2762ceb5b2bf
@assert solve_prob_1(example_customs_answers) == 11

# ╔═╡ 058c499a-3987-11eb-3145-cdaa3cde6eff
part_1_soln = solve_prob_1(problem_customs_answers)

# ╔═╡ Cell order:
# ╠═a4ce37e4-3986-11eb-162e-d13757f65b00
# ╠═e713e662-3986-11eb-3412-bff4314fd303
# ╠═fabaaa70-3986-11eb-1218-d3290fac1f84
# ╠═66644330-3987-11eb-1509-f59a628b48bb
# ╠═fea3f0c8-3987-11eb-1b31-310137b7b4a3
# ╠═a1fbbdac-3989-11eb-2d19-eb80d2a99bfb
# ╠═c33ab40e-3987-11eb-1972-2762ceb5b2bf
# ╠═058c499a-3987-11eb-3145-cdaa3cde6eff
