### A Pluto.jl notebook ###
# v0.12.16

using Markdown
using InteractiveUtils

# ╔═╡ 0fa7c36e-3810-11eb-2921-431b5d7af04a
#=
Solutions for Day 1! 🎄

Part 1: Find expenses summing to 2020 and get their product.

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

# ╔═╡ 62f21c18-3810-11eb-31d3-b942814b7d4d
function find_expense_pair(expenses, expense_sum)
	expenses = sort(expenses)
	
	for (i, e1) ∈ enumerate(expenses)
		for (j, e2) ∈ enumerate(expenses[(i+1):(end)])
			if e1 + e2 == expense_sum
				return e1, e2
			end
		end
	end
	
	return nothing
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

# ╔═╡ d663e2d2-3813-11eb-0892-a9eb0f7d09d6
@assert solve_part_1(example_expenses) == 514579

# ╔═╡ 07ef837a-3815-11eb-0fc6-55a07f6e8a21
part_1_soln = solve_part_1(problem_expenses)

# ╔═╡ 6f48fb62-3815-11eb-3aab-45dadfee9d10
# if running 
println("Day 1. Part 1: ", part_1_soln)

# ╔═╡ Cell order:
# ╠═0fa7c36e-3810-11eb-2921-431b5d7af04a
# ╠═6d856046-3814-11eb-0eb4-af1c757f0d01
# ╠═bf77553e-3806-11eb-3c35-852c9485479b
# ╠═43cc99f0-3813-11eb-3cc4-2f8cbc59cf24
# ╠═62f21c18-3810-11eb-31d3-b942814b7d4d
# ╠═2618a7a6-3812-11eb-1a7a-5f867dd8042f
# ╠═d663e2d2-3813-11eb-0892-a9eb0f7d09d6
# ╠═07ef837a-3815-11eb-0fc6-55a07f6e8a21
# ╠═6f48fb62-3815-11eb-3aab-45dadfee9d10
