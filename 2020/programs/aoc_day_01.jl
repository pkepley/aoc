### A Pluto.jl notebook ###
# v0.12.16

using Markdown
using InteractiveUtils

# ╔═╡ 0fa7c36e-3810-11eb-2921-431b5d7af04a
#=
🎄 Solutions for Day 1! 🎄

🌟 Part 1: Find pair of expenses summing to 2020 and get their product.
🌟 Part 2: Find triple of expenses summing to 2020 and get their product.

=#

# ╔═╡ 43cc99f0-3813-11eb-3cc4-2f8cbc59cf24
function parse_input(s)
	inpt = split(s, "\n", keepempty=false)
	inpt = map(x -> parse(Int, x), inpt)
	return inpt
end

# ╔═╡ 6d856046-3814-11eb-0eb4-af1c757f0d01
begin 
	example_input = """
	1721
	979
	366
	299
	675
	1456
	"""
	example_expenses = parse_input(example_input)
end

# ╔═╡ bf77553e-3806-11eb-3c35-852c9485479b
begin
	input_path = "../input/input_day_01.txt"	
	
	s_input = open(input_path) do file
		read(file, String)
	end	
	problem_expenses = parse_input(s_input)
end

# ╔═╡ b8642d9c-3821-11eb-2ff6-3328e0095b7c
function find_expense_tuple(expenses, expense_sum, tuple_length)
	expenses = sort(expenses)
	tuples = [[x] for x in expenses]
	expense_idx = Dict([(x, i) for (i, x) ∈ enumerate(expenses)])
	
	for i = 2:tuple_length
		tuples = [push!(copy(t), y) for t ∈ tuples for 
					y ∈ [e for e ∈ expenses[(expense_idx[t[end]] + 1):end] if 
								sum(t) + e <= expense_sum]]
	end

	for t in tuples
		if sum(t) == expense_sum
			return t
		end
	end
	
	return nothing
end

# ╔═╡ 62f21c18-3810-11eb-31d3-b942814b7d4d
function find_expense_pair(expenses, expense_sum)
	expenses = sort(expenses)
	return find_expense_tuple(expenses, expense_sum, 2)
end

# ╔═╡ 2618a7a6-3812-11eb-1a7a-5f867dd8042f
function solve_part_1(expense_input)
	ep = find_expense_pair(expense_input, 2020)
		
	if ep != nothing
		e1, e2 = ep	
		return e1 * e2
	else
		return nothing
	end
end

# ╔═╡ a3039550-382b-11eb-024b-a1a2428752cd
function solve_part_2(expense_input)
	exp_tuple = find_expense_tuple(expense_input, 2020, 3)
	
	if exp_tuple != nothing
		return prod(exp_tuple)
	else
		return nothing
	end
end

# ╔═╡ d663e2d2-3813-11eb-0892-a9eb0f7d09d6
begin 
	@assert solve_part_1(example_expenses) == 514579
	@assert solve_part_2(example_expenses) == 241861950
end

# ╔═╡ 07ef837a-3815-11eb-0fc6-55a07f6e8a21
part_1_soln = solve_part_1(problem_expenses)

# ╔═╡ 6f48fb62-3815-11eb-3aab-45dadfee9d10
# print if running from interpreter instead of pluto
println("Day 1. Part 1: ", part_1_soln)

# ╔═╡ 8e0b9674-3822-11eb-3cc5-7d47c6fe833b
part_2_soln = solve_part_2(problem_expenses)

# ╔═╡ ce54aab8-3831-11eb-2ce8-b3ef49a3cf7c
# print: if running from interpreter instead of pluto
println("Day 2. Part 2: ", part_2_soln)

# ╔═╡ Cell order:
# ╠═0fa7c36e-3810-11eb-2921-431b5d7af04a
# ╠═6d856046-3814-11eb-0eb4-af1c757f0d01
# ╠═bf77553e-3806-11eb-3c35-852c9485479b
# ╠═43cc99f0-3813-11eb-3cc4-2f8cbc59cf24
# ╠═b8642d9c-3821-11eb-2ff6-3328e0095b7c
# ╠═62f21c18-3810-11eb-31d3-b942814b7d4d
# ╠═2618a7a6-3812-11eb-1a7a-5f867dd8042f
# ╠═a3039550-382b-11eb-024b-a1a2428752cd
# ╠═d663e2d2-3813-11eb-0892-a9eb0f7d09d6
# ╠═07ef837a-3815-11eb-0fc6-55a07f6e8a21
# ╠═6f48fb62-3815-11eb-3aab-45dadfee9d10
# ╠═8e0b9674-3822-11eb-3cc5-7d47c6fe833b
# ╠═ce54aab8-3831-11eb-2ce8-b3ef49a3cf7c
