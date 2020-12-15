### A Pluto.jl notebook ###
# v0.12.17

using Markdown
using InteractiveUtils

# ╔═╡ 0b6188b0-3a8b-11eb-112c-77145e1d99b5
#= 
🎅 Solutions for Day 14! 🎅

🌟 Part 1: Apply a bit masks and compute some values in memory 😷
=#

# ╔═╡ b0bbb420-3d62-11eb-050a-99a665672dba
DAY_NUMBER = 14 

# ╔═╡ f730c4dc-3e38-11eb-18b0-cb8b0ea74f48
struct instruction
	kind   ::String
	mask   ::Union{Nothing, String}	
	addr   ::Union{Nothing, Int}
	val    ::Union{Nothing, Array{Bool,1}}
end

# ╔═╡ 47129742-3e38-11eb-15dc-abf9dadf773b
function apply_bitmask(mask, bit_rep)
	for i = 1:36
		if mask[i] == '1'
			bit_rep[i] = true | bit_rep[i]
		elseif mask[i] == '0'
			bit_rep[i] = false & bit_rep[i]
		end
	end	
	
	return bit_rep
end

# ╔═╡ ce828c82-3e17-11eb-38ce-17ed0345f8ae
function to_bits(n, n_bits = 36)
	word = zeros(Bool, n_bits)
	
	i = 0
	while n > 0
		word[end - i] = n % 2
		n = n ÷ 2
		i += 1
	end

	return word
end

# ╔═╡ 8ca9fd12-3e39-11eb-2073-e7b6d15ff50c
function parse_instruction_descr(instr)
	r = split(instr, " = ")
	
	if instr[1:3] == "mem"
		# information in instruction
		addr = replace(r[1], "mem["=>"")
		addr = replace(addr, "]"=>"")		
		addr = parse(Int, addr)		

		# place val in 36-bit binary
		val = r[2]
		val = to_bits(parse(Int, val))

		# update row
		return instruction("mem", nothing, addr, val)
	else
		return instruction("mask", r[2], nothing, nothing)
	end
end

# ╔═╡ 81e88cb0-3a8b-11eb-3aba-a3509bff5912
function parse_input(s)
	rows = split(s, "\n", keepempty=false)	
	rows = map(parse_instruction_descr, rows)	
			
	return rows
end

# ╔═╡ bcbe1518-3e18-11eb-0132-bf592fa8239d
function from_bits(bit_rep, n_bits=36)
	m = 1
	n = 0
	for i = n_bits:-1:1
		n += m * bit_rep[i]
		m *= 2
	end
	return n
end

# ╔═╡ f1109a84-3a8f-11eb-3ca8-2fdbdd1cc29a
function solve_prob_1(inpt)
	instructions = parse_input(inpt)
	n_input = length(instructions)
	memory = Dict()

	# temporary mask
	curr_mask = "X"^36
	
	for i = 1:length(instructions)
		if instructions[i].kind == "mask"
			curr_mask = instructions[i].mask
		else
			addr = instructions[i].addr
			val  = instructions[i].val
			memory[addr] = apply_bitmask(curr_mask, val) 
		end
	end
	
	s = 0
	for k in keys(memory)
		s += from_bits(memory[k])
	end
	
	return s
end

# ╔═╡ 129f488c-3a93-11eb-260e-8921353e1039
function solve_prob_2(inpt)
	return nothing
end

# ╔═╡ 8e4e5560-3a8c-11eb-2612-577833ceee7e
############################ Examples+Tests ################################
begin 
	example_input="""
mask = XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X
mem[8] = 11
mem[7] = 101
mem[8] = 0
"""
end

# ╔═╡ f3f072bc-3a8d-11eb-3b54-719f2924e9d2
begin
	@assert solve_prob_1(example_input) == 165
	@assert solve_prob_2(example_input) == nothing
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
#part_2_soln = solve_prob_2(problem_input)

# ╔═╡ 2c64697a-3a96-11eb-34ea-ff7f4a67aa99
#println("Day $DAY_NUMBER: Part 2: $part_2_soln")

# ╔═╡ Cell order:
# ╠═0b6188b0-3a8b-11eb-112c-77145e1d99b5
# ╠═b0bbb420-3d62-11eb-050a-99a665672dba
# ╠═f730c4dc-3e38-11eb-18b0-cb8b0ea74f48
# ╠═8ca9fd12-3e39-11eb-2073-e7b6d15ff50c
# ╠═81e88cb0-3a8b-11eb-3aba-a3509bff5912
# ╠═47129742-3e38-11eb-15dc-abf9dadf773b
# ╠═ce828c82-3e17-11eb-38ce-17ed0345f8ae
# ╠═bcbe1518-3e18-11eb-0132-bf592fa8239d
# ╠═f1109a84-3a8f-11eb-3ca8-2fdbdd1cc29a
# ╠═129f488c-3a93-11eb-260e-8921353e1039
# ╠═8e4e5560-3a8c-11eb-2612-577833ceee7e
# ╠═f3f072bc-3a8d-11eb-3b54-719f2924e9d2
# ╠═ed7ca23c-3a8f-11eb-34fe-dd7cf712377b
# ╠═5b37cd42-3a90-11eb-25a3-6105e801b231
# ╠═52110486-3a90-11eb-3a4f-11a08a8bd71f
# ╠═3180ae1c-3a93-11eb-01ab-13cc9be93b67
# ╠═2c64697a-3a96-11eb-34ea-ff7f4a67aa99
