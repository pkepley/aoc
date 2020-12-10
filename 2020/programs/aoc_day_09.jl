### A Pluto.jl notebook ###
# v0.12.16

using Markdown
using InteractiveUtils

# ╔═╡ 0b6188b0-3a8b-11eb-112c-77145e1d99b5
#= 
🛷 Solutions for Day 9! 🛷

🌟 Part 1: Find first invalid entry in XMAS code!
🌟 Part 2: Find first XMAS code encryption weakness!
=#

# ╔═╡ 81e88cb0-3a8b-11eb-3aba-a3509bff5912
function parse_input(s)
	numbers = split(s, "\n", keepempty=false)		
	numbers = map(s -> parse(Int, s), numbers)
	
	return numbers
end

# ╔═╡ 74ea477a-3aa3-11eb-136e-f75df27c1c96
function find_first_invalid(xmas_code, preamble_length)
	code_length = length(xmas_code)
	
	for idx = (preamble_length+1):code_length
		curr_val = xmas_code[idx]
		prior_vals = xmas_code[(idx-preamble_length):(idx-1)]
		prior_val_sums = [x+y for x ∈ prior_vals for y ∈ prior_vals]
		
		if !(curr_val ∈ prior_val_sums)
			return curr_val, idx
		end
	end
	
	return nothing
end

# ╔═╡ 083fec4a-3aa8-11eb-1ced-e7b3805b2c0e
function encryption_weakness(xmas_code, preamble_length)
	invalid_rslt = find_first_invalid(xmas_code, preamble_length)	
	invalid_val, invalid_idx = invalid_rslt
		
	for window_len = 2:(invalid_idx-1)		
		roll_sum = sum(xmas_code[1:window_len])
		for idx_last = window_len:(invalid_idx-1)
			# compute rolling sum up to window_length
			if idx_last > window_len				
				roll_sum = roll_sum + 
				(xmas_code[idx_last] - xmas_code[idx_last - window_len])
			end
			
			if roll_sum == invalid_val
				lo = minimum(xmas_code[(idx_last-window_len+1):idx_last])
				hi = maximum(xmas_code[(idx_last-window_len+1):idx_last])
				
				return lo + hi
			end
		end
		
	end	
	
	
	return nothing
end

# ╔═╡ f1109a84-3a8f-11eb-3ca8-2fdbdd1cc29a
function solve_prob_1(xmas_code, preamble_length = 25)
	rslt = find_first_invalid(xmas_code, preamble_length)
	val, idx = rslt
	
	return val
end

# ╔═╡ 129f488c-3a93-11eb-260e-8921353e1039
function solve_prob_2(xmas_code, preamble_length)
	return encryption_weakness(xmas_code, preamble_length)
end

# ╔═╡ 8e4e5560-3a8c-11eb-2612-577833ceee7e
############################ Day 8 Examples+Tests ################################
begin 
	example_input="""
35
20
15
25
47
40
62
55
65
95
102
117
150
182
127
219
299
277
309
576"""
	
	example_pgm = parse_input(example_input)
end

# ╔═╡ f3f072bc-3a8d-11eb-3b54-719f2924e9d2
begin
	@assert solve_prob_1(example_pgm, 5) == 127
	@assert solve_prob_2(example_pgm, 5) == 62
end

# ╔═╡ ed7ca23c-3a8f-11eb-34fe-dd7cf712377b
############################ Day 9 Solution ############################
begin
	input_path = "../input/input_day_09.txt"	
	
	problem_input_str = open(input_path) do file
		read(file, String)
	end	
	
	problem_xmas_code = parse_input(problem_input_str)
end

# ╔═╡ 5b37cd42-3a90-11eb-25a3-6105e801b231
part_1_soln = solve_prob_1(problem_xmas_code)

# ╔═╡ 52110486-3a90-11eb-3a4f-11a08a8bd71f
println("Day 9: Part 1: ", part_1_soln)

# ╔═╡ 3180ae1c-3a93-11eb-01ab-13cc9be93b67
part_2_soln = solve_prob_2(problem_xmas_code, 25)

# ╔═╡ 2c64697a-3a96-11eb-34ea-ff7f4a67aa99
println("Day 9: Part 2: ", part_2_soln)

# ╔═╡ Cell order:
# ╠═0b6188b0-3a8b-11eb-112c-77145e1d99b5
# ╠═81e88cb0-3a8b-11eb-3aba-a3509bff5912
# ╠═74ea477a-3aa3-11eb-136e-f75df27c1c96
# ╠═083fec4a-3aa8-11eb-1ced-e7b3805b2c0e
# ╠═f1109a84-3a8f-11eb-3ca8-2fdbdd1cc29a
# ╠═129f488c-3a93-11eb-260e-8921353e1039
# ╠═8e4e5560-3a8c-11eb-2612-577833ceee7e
# ╠═f3f072bc-3a8d-11eb-3b54-719f2924e9d2
# ╠═ed7ca23c-3a8f-11eb-34fe-dd7cf712377b
# ╠═5b37cd42-3a90-11eb-25a3-6105e801b231
# ╠═52110486-3a90-11eb-3a4f-11a08a8bd71f
# ╠═3180ae1c-3a93-11eb-01ab-13cc9be93b67
# ╠═2c64697a-3a96-11eb-34ea-ff7f4a67aa99
