### A Pluto.jl notebook ###
# v0.12.17

using Markdown
using InteractiveUtils

# ╔═╡ 0b6188b0-3a8b-11eb-112c-77145e1d99b5
#= 
🦌 Solutions for Day 15! 🦌

🌟 Part 1: Play elf games, win elf prizes! 🧝
🌟 Part 2: Play the same elf games, win the same elf prizes! 🧝
=#

# ╔═╡ b0bbb420-3d62-11eb-050a-99a665672dba
DAY_NUMBER = 15 

# ╔═╡ 81e88cb0-3a8b-11eb-3aba-a3509bff5912
function parse_input(s)
	numbers = split(s, ",", keepempty=false)		
	numbers = map(n -> parse(Int, n), numbers) 
	return numbers
end

# ╔═╡ 2ae9a218-3edd-11eb-2302-0fa95ad7e14b
function play_elf_game(starting_numbers, stop_at = 2020)
	n_starting = length(starting_numbers)	
	max_start = maximum(starting_numbers)

	# use a lookup table for last_repetition. in the (i+1)^st entry will
	# store the last time the number i was spoken. the default value will
	# be -1, which indicates entry i has not been spoken yet.
	last_repeated = fill(-1, maximum([stop_at, max_start]) + 1)
	
	# starting values, make these accessible outside of loop
	last_spoken = nothing
	next_spoken = nothing 
	
	for i = 1 : stop_at		
		last_spoken = next_spoken

		if i <= n_starting # next_spoken is given when we're starting out
			next_spoken = starting_numbers[i]
		end
				
		if last_repeated[next_spoken + 1] == -1  # Number is new!
			last_repeated[next_spoken + 1] = i
			next_spoken = 0
		else # Number seen before. Next spoken is time since this was last spoken.
			last_seen = last_repeated[next_spoken + 1]
			last_repeated[next_spoken + 1] = i
			next_spoken = i - last_seen			
		end
		
	end
	
	return last_spoken
end

# ╔═╡ f1109a84-3a8f-11eb-3ca8-2fdbdd1cc29a
function solve_prob_1(inpt)
	starting_numbers = parse_input(inpt)
	
	return play_elf_game(starting_numbers, 2020)
end

# ╔═╡ 129f488c-3a93-11eb-260e-8921353e1039
function solve_prob_2(inpt)
	starting_numbers = parse_input(inpt)
	
	return play_elf_game(starting_numbers, 30*10^6)
end

# ╔═╡ baa870c2-3ee3-11eb-2887-cbc9f1a564b9
############################ Examples+Tests ################################
begin
	@assert solve_prob_1("0,3,6") == 436
	@assert solve_prob_1("1,3,2") == 1
	@assert solve_prob_1("2,1,3") == 10
	@assert solve_prob_1("1,2,3") == 27
	@assert solve_prob_1("2,3,1") == 78
	@assert solve_prob_1("3,2,1") == 438
	@assert solve_prob_1("3,1,2") == 1836	
end

# ╔═╡ f3f072bc-3a8d-11eb-3b54-719f2924e9d2
begin
	@assert solve_prob_2("0,3,6") == 175594
	@assert solve_prob_2("1,3,2") == 2578	
end

# ╔═╡ ed7ca23c-3a8f-11eb-34fe-dd7cf712377b
############################ Solution ############################
begin	
	problem_input = "2,0,1,9,5,19"
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
# ╠═2ae9a218-3edd-11eb-2302-0fa95ad7e14b
# ╠═f1109a84-3a8f-11eb-3ca8-2fdbdd1cc29a
# ╠═129f488c-3a93-11eb-260e-8921353e1039
# ╠═baa870c2-3ee3-11eb-2887-cbc9f1a564b9
# ╠═f3f072bc-3a8d-11eb-3b54-719f2924e9d2
# ╠═ed7ca23c-3a8f-11eb-34fe-dd7cf712377b
# ╠═5b37cd42-3a90-11eb-25a3-6105e801b231
# ╠═52110486-3a90-11eb-3a4f-11a08a8bd71f
# ╠═3180ae1c-3a93-11eb-01ab-13cc9be93b67
# ╠═2c64697a-3a96-11eb-34ea-ff7f4a67aa99
