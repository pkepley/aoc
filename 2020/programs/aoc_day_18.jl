### A Pluto.jl notebook ###
# v0.12.17

using Markdown
using InteractiveUtils

# ╔═╡ 0b6188b0-3a8b-11eb-112c-77145e1d99b5
#= 
🎄 Solutions for Day 18! 🎄

🌟 Part 1: Do some basic bad arithmetic! 🧮 🧮 🧮 
🌟 Part 2: Do some advanced bad arithmetic! 🧮 🧮 🧮 

=#

# ╔═╡ b0bbb420-3d62-11eb-050a-99a665672dba
DAY_NUMBER = 18 

# ╔═╡ 81e88cb0-3a8b-11eb-3aba-a3509bff5912
function parse_input(s)
    rows = split(s, "\n", keepempty=false)		
    return rows
end

# ╔═╡ 9bd5d360-43b1-11eb-3215-4d91f9165786
function basic_math_reduction(numbers_and_ops)
	"""
	Reduce string of numbers and +,*'s by applying +,* left-to right 
	with equal precedence. No parens allowed!
	"""
	numbers_and_ops = split(numbers_and_ops, " ", keepempty=false)
	n_entries = length(numbers_and_ops)

	val = parse(Int, numbers_and_ops[1])
	for i = 2:2:(n_entries-1)
		op = numbers_and_ops[i]
		r  = parse(Int, numbers_and_ops[i+1])
		
		if op == "+"
			val = val + r
		elseif op == "*"
			val = val * r
		end		
	end
	
	return val
end

# ╔═╡ c5a9a620-43c1-11eb-1a0e-1720f4d6526d
function advanced_math_reduction(number_and_ops)
	"""
	Reduce string of numbers and +,*'s by applying higher precedence to +
	than *. No parens allowed!
	"""
	
	number_and_ops = split(number_and_ops, " ", keepempty=false)
	
	# discharge all plus signs
	while "+" ∈ number_and_ops
		# replace triplet of left, "+", right with their sum
		i_plus = findfirst(number_and_ops .==  "+")
		left = parse(Int, number_and_ops[i_plus - 1])
		right = parse(Int, number_and_ops[i_plus + 1])
		replacement = left + right
		
		# do the replacement
		deleteat!(number_and_ops, [i_plus-1; i_plus; i_plus+1])
		insert!(number_and_ops, i_plus - 1, "$replacement")		
	end

	# only numbers and multiplication signs are left
	number_and_ops = filter(x -> (x != "*"), number_and_ops)
	number_and_ops = map(s -> parse(Int, s), number_and_ops)
	
	return prod(number_and_ops)
end

# ╔═╡ a1d9f372-43b1-11eb-0848-e3f5f0d1bd90
function reduce_equation(number_and_ops, reduction_rule = basic_math_reduction)	
	"""
	Reduce a string of numbers, +, * and parens by applying reduction_rule
	with parens having higher precedence than +/*.
	"""

	while occursin("(",  number_and_ops)
		
		number_and_ops_array = split(number_and_ops, "")
		left_parens  = findall(number_and_ops_array .== "(")
		right_parens = findall(number_and_ops_array .== ")")

		right_paren = right_parens[1]
		left_paren = nothing
		j = 1
		while j <= length(left_parens) && left_parens[j] < right_paren			
			left_paren = left_parens[j]
			j += 1
		end
		
		substitute = number_and_ops[left_paren:right_paren]
		reduced = reduction_rule(substitute[2:end-1])
		
		number_and_ops = replace(number_and_ops, substitute => "$reduced")			
	end
	
	return reduction_rule(number_and_ops)
end

# ╔═╡ f1109a84-3a8f-11eb-3ca8-2fdbdd1cc29a
function solve_prob_1(inpt)
    parsed_input = parse_input(inpt)
	
	bad_math_solutions = map(s -> reduce_equation(s, basic_math_reduction),
		parsed_input)
	
    return sum(bad_math_solutions)
end

# ╔═╡ 129f488c-3a93-11eb-260e-8921353e1039
function solve_prob_2(inpt)
    parsed_input = parse_input(inpt)
	
	bad_math_solutions = map(s -> reduce_equation(s, advanced_math_reduction),
		parsed_input)
	
    return sum(bad_math_solutions)
end

# ╔═╡ f3f072bc-3a8d-11eb-3b54-719f2924e9d2
############################ Examples+Tests ################################
begin
	# tests for part 1	
	basic_reduce = s -> reduce_equation(s, basic_math_reduction)
	@assert basic_reduce("1 + 2 * 3 + 4 * 5 + 6") == 71
	@assert basic_reduce("1 + (2 * 3) + (4 * (5 + 6))") == 51
	@assert basic_reduce("2 * 3 + (4 * 5)") == 26
	@assert basic_reduce("5 + (8 * 3 + 9 + 3 * 4 * 3)") == 437
	@assert basic_reduce("5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))") == 12240
	@assert basic_reduce("((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2") == 13632
	
	# tests for part 2	
	advanced_reduce = s -> reduce_equation(s, advanced_math_reduction)
	@assert advanced_reduce("1 + 2 * 3 + 4 * 5 + 6") == 231	
	@assert advanced_reduce("1 + (2 * 3) + (4 * (5 + 6))") == 51
	@assert advanced_reduce("2 * 3 + (4 * 5)") == 46
	@assert advanced_reduce("5 + (8 * 3 + 9 + 3 * 4 * 3)") == 1445
	@assert advanced_reduce("5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))") == 669060
	@assert advanced_reduce("((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2") == 23340
	
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
# ╠═9bd5d360-43b1-11eb-3215-4d91f9165786
# ╠═c5a9a620-43c1-11eb-1a0e-1720f4d6526d
# ╠═a1d9f372-43b1-11eb-0848-e3f5f0d1bd90
# ╠═f1109a84-3a8f-11eb-3ca8-2fdbdd1cc29a
# ╠═129f488c-3a93-11eb-260e-8921353e1039
# ╠═f3f072bc-3a8d-11eb-3b54-719f2924e9d2
# ╠═ed7ca23c-3a8f-11eb-34fe-dd7cf712377b
# ╠═5b37cd42-3a90-11eb-25a3-6105e801b231
# ╠═52110486-3a90-11eb-3a4f-11a08a8bd71f
# ╠═3180ae1c-3a93-11eb-01ab-13cc9be93b67
# ╠═2c64697a-3a96-11eb-34ea-ff7f4a67aa99
