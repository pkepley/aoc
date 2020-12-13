### A Pluto.jl notebook ###
# v0.12.17

using Markdown
using InteractiveUtils

# ╔═╡ 0b6188b0-3a8b-11eb-112c-77145e1d99b5
#= 
🎁 Solutions for Day 12! 🎁

🌟 Part 1: Where does our Ferry go using the initial instructions? ⛵⛵⛵
🌟 Part 2: Where does our Ferry go using the corrected instructions? ⛵⛵⛵
=#

# ╔═╡ b0bbb420-3d62-11eb-050a-99a665672dba
DAY_NUMBER = 12

# ╔═╡ 81e88cb0-3a8b-11eb-3aba-a3509bff5912
function parse_input(s)
	rows = split(s, "\n", keepempty=false)	
	directions = [(r[1], parse(Int, r[2:end])) for r ∈ rows]
	return directions
end

# ╔═╡ a7ac93fa-3d66-11eb-22e3-43f77f4c44e8
function follow_instruction_list_v1(instruction_list)
	p = [0, 0] # use origin as starting position
	v = [1, 0] # starts facing east 
	
	for (action, val) ∈ instruction_list
		if action == 'N'
			p += val * [ 0,  1]
		elseif action == 'S'
			p += val * [ 0, -1]
		elseif action == 'E'
			p += val * [ 1,  0]
		elseif action == 'W'
			p += val * [-1,  0]
		elseif action == 'F'
			p += val * v
		elseif action == 'L'
			θ = val * (π / 180)
			v = [cos(θ) * v[1] - sin(θ) * v[2], sin(θ) * v[1] + cos(θ) * v[2]]
		elseif action == 'R'
			θ = - val * (π / 180)
			v = [cos(θ) * v[1] - sin(θ) * v[2], sin(θ) * v[1] + cos(θ) * v[2]]
		end							
	end

	return p
end

# ╔═╡ be95ab92-3d75-11eb-110e-8d38008e0dac
function follow_instruction_list_v2(instruction_list)
	p = [0, 0] # use origin as starting position
	wp = [10, 1] # starting waypoint
	
	for (action, val) ∈ instruction_list
		if action == 'N'
			wp += val * [ 0,  1]
		elseif action == 'S'
			wp += val * [ 0, -1]
		elseif action == 'E'
			wp += val * [ 1,  0]
		elseif action == 'W'
			wp += val * [-1,  0]
		elseif action == 'F'
			p += val * wp
		elseif action == 'L'
			θ = val * (π / 180)
			wp = [cos(θ) * wp[1] - sin(θ) * wp[2], sin(θ) * wp[1] + cos(θ) * wp[2]]
		elseif action == 'R'
			θ = - val * (π / 180)
			wp = [cos(θ) * wp[1] - sin(θ) * wp[2], sin(θ) * wp[1] + cos(θ) * wp[2]]
		end							
	end

	return p
end

# ╔═╡ f1109a84-3a8f-11eb-3ca8-2fdbdd1cc29a
function solve_prob_1(inpt)
	p_final = follow_instruction_list_v1(inpt)
	d_final = abs(p_final[1]) + abs(p_final[2])
	d_final = convert(Int, round(d_final))
	
	return d_final
end

# ╔═╡ 129f488c-3a93-11eb-260e-8921353e1039
function solve_prob_2(inpt)
	p_final = follow_instruction_list_v2(inpt)
	d_final = abs(p_final[1]) + abs(p_final[2])
	d_final = convert(Int, round(d_final))
	
	return d_final
end

# ╔═╡ 8e4e5560-3a8c-11eb-2612-577833ceee7e
############################ Examples+Tests ################################
begin 
	example_input_str="""
F10
N3
F7
R90
F11
"""
	example_input = parse_input(example_input_str)
end

# ╔═╡ f3f072bc-3a8d-11eb-3b54-719f2924e9d2
begin
	@assert solve_prob_1(example_input) == 25
	@assert solve_prob_2(example_input) == 286
end

# ╔═╡ ed7ca23c-3a8f-11eb-34fe-dd7cf712377b
############################ Solution ############################
begin
	input_path = "../input/input_day_$DAY_NUMBER.txt"
	
	problem_input_str = open(input_path) do file

		read(file, String)
	end	
	
	problem_input = parse_input(problem_input_str)
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
# ╠═a7ac93fa-3d66-11eb-22e3-43f77f4c44e8
# ╠═be95ab92-3d75-11eb-110e-8d38008e0dac
# ╠═f1109a84-3a8f-11eb-3ca8-2fdbdd1cc29a
# ╠═129f488c-3a93-11eb-260e-8921353e1039
# ╠═8e4e5560-3a8c-11eb-2612-577833ceee7e
# ╠═f3f072bc-3a8d-11eb-3b54-719f2924e9d2
# ╠═ed7ca23c-3a8f-11eb-34fe-dd7cf712377b
# ╠═5b37cd42-3a90-11eb-25a3-6105e801b231
# ╠═52110486-3a90-11eb-3a4f-11a08a8bd71f
# ╠═3180ae1c-3a93-11eb-01ab-13cc9be93b67
# ╠═2c64697a-3a96-11eb-34ea-ff7f4a67aa99
