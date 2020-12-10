### A Pluto.jl notebook ###
# v0.12.16

using Markdown
using InteractiveUtils

# ╔═╡ 0b6188b0-3a8b-11eb-112c-77145e1d99b5
#= 
🎅 Solutions for Day 8! 🎅

🌟 Part 1: Find a value in a broken video game's boot loader! 🎮
🌟 Part 2: Fix a broken video game console and find a value in 
           the boot loader! 🎮

Intcode only comes once a year!
=#

# ╔═╡ 81e88cb0-3a8b-11eb-3aba-a3509bff5912
function parse_input(s)
	return split(s, "\n", keepempty=false)	
end

# ╔═╡ 2b544e8c-3a8d-11eb-3934-49cb1f5488a6
function parse_op(op_str)
	operation = split(op_str, ' ', keepempty = false)	

	return (operation[1], parse(Int, operation[2]))
end

# ╔═╡ b3dae776-3a8c-11eb-1d9d-af404055e57d
function parse_program(pgm)
	instructions = parse_input(pgm)
	instructions = [parse_op(op_str) for op_str ∈ instructions]
	
	return instructions
end

# ╔═╡ 1740ecec-3a8e-11eb-2b90-b99dc792e5a2
function execute_until_loop_or_halt(pgm)
	n_instructions = length(pgm)
	
	# execute until we see an index used twice
	operation_executed = zeros(Bool, n_instructions)
	idx, acc = 1, 0	
	
	while (idx <= n_instructions) && operation_executed[idx] == false 
		operation_executed[idx] = true
		operation, argument = pgm[idx]
		
		if operation == "acc"
			acc += argument
			idx += 1
			
		elseif operation == "jmp"
			idx += argument
			
		elseif operation == "nop"
			idx += 1
		end
		
	end	
		
	return acc, idx
end

# ╔═╡ d91d290a-3a92-11eb-158a-31a1a1d10969
function program_halts(pgm)
	n_instructions = length(pgm)
	acc, idx = execute_until_loop_or_halt(pgm)

	return idx == n_instructions + 1, acc
end

# ╔═╡ f1109a84-3a8f-11eb-3ca8-2fdbdd1cc29a
function solve_prob_1(pgm)
	acc, idx = execute_until_loop_or_halt(pgm)
	
	return acc
end

# ╔═╡ 129f488c-3a93-11eb-260e-8921353e1039
function solve_prob_2(pgm)
	idx_jmp = findall(x -> x[1] == "jmp", pgm)
	
	for i ∈ idx_jmp
		new_pgm = copy(pgm)
		
		# modify jmp -> nop
		operation, value = new_pgm[i]
		new_pgm[i] = ("nop", value)
		
		# does it halt?
		rslt = program_halts(new_pgm)
		halts, acc = rslt
		
		# return the accumulation value if it halts
		if halts == true
			return acc
		end
	end
	
	# if it didn't halt, none work!
	return nothing
end

# ╔═╡ 8e4e5560-3a8c-11eb-2612-577833ceee7e
############################ Day 8 Examples+Tests ################################
begin 
	example_input="""nop +0
acc +1
jmp +4
acc +3
jmp -3
acc -99
acc +1
jmp -4
acc +6
"""
	
	example_pgm = parse_program(example_input)
end

# ╔═╡ f3f072bc-3a8d-11eb-3b54-719f2924e9d2
begin
	@assert solve_prob_1(example_pgm) == 5
	@assert solve_prob_2(example_pgm) == 8
end

# ╔═╡ ed7ca23c-3a8f-11eb-34fe-dd7cf712377b
############################ Day 8 Solution ############################
begin
	input_path = "../input/input_day_08.txt"	
	
	problem_pgm_str = open(input_path) do file
		read(file, String)
	end	
	
	problem_pgm = parse_program(problem_pgm_str)
end

# ╔═╡ 5b37cd42-3a90-11eb-25a3-6105e801b231
part_1_soln = solve_prob_1(problem_pgm)

# ╔═╡ 52110486-3a90-11eb-3a4f-11a08a8bd71f
println("Day 8: Part 1: ", part_1_soln)

# ╔═╡ 3180ae1c-3a93-11eb-01ab-13cc9be93b67
part_2_soln = solve_prob_2(problem_pgm)

# ╔═╡ 2c64697a-3a96-11eb-34ea-ff7f4a67aa99
println("Day 8: Part 2: ", part_2_soln)

# ╔═╡ Cell order:
# ╠═0b6188b0-3a8b-11eb-112c-77145e1d99b5
# ╠═81e88cb0-3a8b-11eb-3aba-a3509bff5912
# ╠═2b544e8c-3a8d-11eb-3934-49cb1f5488a6
# ╠═b3dae776-3a8c-11eb-1d9d-af404055e57d
# ╠═1740ecec-3a8e-11eb-2b90-b99dc792e5a2
# ╠═d91d290a-3a92-11eb-158a-31a1a1d10969
# ╠═f1109a84-3a8f-11eb-3ca8-2fdbdd1cc29a
# ╠═129f488c-3a93-11eb-260e-8921353e1039
# ╠═8e4e5560-3a8c-11eb-2612-577833ceee7e
# ╠═f3f072bc-3a8d-11eb-3b54-719f2924e9d2
# ╠═ed7ca23c-3a8f-11eb-34fe-dd7cf712377b
# ╠═5b37cd42-3a90-11eb-25a3-6105e801b231
# ╠═52110486-3a90-11eb-3a4f-11a08a8bd71f
# ╠═3180ae1c-3a93-11eb-01ab-13cc9be93b67
# ╠═2c64697a-3a96-11eb-34ea-ff7f4a67aa99
