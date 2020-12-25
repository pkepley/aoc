### A Pluto.jl notebook ###
# v0.12.17

using Markdown
using InteractiveUtils

# ╔═╡ 0b6188b0-3a8b-11eb-112c-77145e1d99b5
#= 
🎅🤶🦌❄️☃️🎄 Solutions for day 25! 🎄☃️❄️🦌🤶🎅

🌟 Part 1: Reverse engineer part of a card reader's cryptographic algorithm! 💳
=#

# ╔═╡ b0bbb420-3d62-11eb-050a-99a665672dba
DAY_NUMBER = 25 

# ╔═╡ 81e88cb0-3a8b-11eb-3aba-a3509bff5912
function parse_input(s)
    rows = split(s, "\n", keepempty=false)
	rows = map(s -> parse(Int, s), rows)	
	(card_public_key, door_public_key) = rows
	
    return card_public_key, door_public_key
end

# ╔═╡ 3c18bc74-46bf-11eb-0cd4-bde38a353e8f
function determine_loop_size(key, subject_number = 7, mod_size = 20201227)
	loop_size = 0
	val = 1
	
	while val != key
		val = mod(val * subject_number, mod_size)
		loop_size += 1
	end
	
	return loop_size
end

# ╔═╡ f64f2d7c-46be-11eb-069b-8d7f098b82f0
function transform_subject_number(subject_number, loop_size, mod_size = 20201227)
	val = 1
	
	for i = 1:loop_size
		val = mod(val * subject_number, mod_size)		
	end
	
	return val
end

# ╔═╡ f1109a84-3a8f-11eb-3ca8-2fdbdd1cc29a
function solve_prob_1(inpt)
    (card_public_key, door_public_key) = parse_input(inpt)
	
	# determine the card & door loop sizes
	card_loop_size = determine_loop_size(card_public_key, 7, 20201227)
	door_loop_size = determine_loop_size(door_public_key, 7, 20201227)
	
	# perform the cryptographic handshakes
	encryption_key = transform_subject_number(door_public_key, card_loop_size,
											  20201227)
	encryption_key2 = transform_subject_number(card_public_key, door_loop_size,
											  20201227)
	
	# these must match...
	@assert encryption_key == encryption_key2
	
    return encryption_key
end

# ╔═╡ 129f488c-3a93-11eb-260e-8921353e1039
function solve_prob_2(inpt)
    parsed_input = parse_input(inpt)    
    return nothing
end

# ╔═╡ 8e4e5560-3a8c-11eb-2612-577833ceee7e
############################ Examples+Tests ################################
begin 
    example_input="""
5764801
17807724
"""    
end

# ╔═╡ c5818e80-46c1-11eb-1878-4bf0d0a58f32
solve_prob_1(example_input)

# ╔═╡ f3f072bc-3a8d-11eb-3b54-719f2924e9d2
begin
    @assert solve_prob_1(example_input) == 14897079
    #@assert solve_prob_2(example_input) == 0
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
# ╠═81e88cb0-3a8b-11eb-3aba-a3509bff5912
# ╠═3c18bc74-46bf-11eb-0cd4-bde38a353e8f
# ╠═f64f2d7c-46be-11eb-069b-8d7f098b82f0
# ╠═f1109a84-3a8f-11eb-3ca8-2fdbdd1cc29a
# ╠═129f488c-3a93-11eb-260e-8921353e1039
# ╠═8e4e5560-3a8c-11eb-2612-577833ceee7e
# ╠═c5818e80-46c1-11eb-1878-4bf0d0a58f32
# ╠═f3f072bc-3a8d-11eb-3b54-719f2924e9d2
# ╠═ed7ca23c-3a8f-11eb-34fe-dd7cf712377b
# ╠═5b37cd42-3a90-11eb-25a3-6105e801b231
# ╠═52110486-3a90-11eb-3a4f-11a08a8bd71f
# ╠═3180ae1c-3a93-11eb-01ab-13cc9be93b67
# ╠═2c64697a-3a96-11eb-34ea-ff7f4a67aa99
