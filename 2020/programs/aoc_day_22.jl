### A Pluto.jl notebook ###
# v0.12.17

using Markdown
using InteractiveUtils

# ╔═╡ 0b6188b0-3a8b-11eb-112c-77145e1d99b5
#= 
🦌 Solutions for Day 22! 🦌

🌟 Part 1: Play war against a crab! 🦀 🦀 🦀
=#

# ╔═╡ b0bbb420-3d62-11eb-050a-99a665672dba
DAY_NUMBER = 22 

# ╔═╡ 65f400da-4741-11eb-34c9-9fd0dcfa5bc8
function parse_input(s)
    rows = split(s, "\n\n", keepempty=false)
	rows = map(s -> split(s, "\n", keepempty=false), rows)
	
	deck_p1 = map(s -> parse(Int, s), rows[1][2:end])
	deck_p2 = map(s -> parse(Int, s), rows[2][2:end])	
	
    return deck_p1, deck_p2
end

# ╔═╡ 43bcf344-473e-11eb-39ca-655c570137e9
function play_combat(deck_p1, deck_p2)
	deck_p1 = deepcopy(deck_p1)
	deck_p2 = deepcopy(deck_p2)
	
	while !isempty(deck_p1) && !isempty(deck_p2)
		# draw from front of list
		c1 = deck_p1[1]
		c2 = deck_p2[1]
		deleteat!(deck_p1, 1)
		deleteat!(deck_p2, 1)
		
		# p1 won, place cards on bottom of p1's deck as c1, c2
		if c1 > c2
			push!(deck_p1, c1)			
			push!(deck_p1, c2)
			
		# p2 won, place cards on bottom of p2's deck as c2, c1
		else
			push!(deck_p2, c2)
			push!(deck_p2, c1)			
		end
	end
	
	if isempty(deck_p2)
		return "p1", deck_p1
	else
		return "p2", deck_p2
	end
end

# ╔═╡ f1109a84-3a8f-11eb-3ca8-2fdbdd1cc29a
function solve_prob_1(inpt)
    deck_p1, deck_p2 = parse_input(inpt)
	winner, winning_deck = play_combat(deck_p1, deck_p2)
	n_cards = length(winning_deck)
	score = sum([winning_deck[i] * (n_cards - i + 1) for i = 1:n_cards])
	
    return score
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
Player 1:
9
2
6
3
1

Player 2:
5
8
4
7
10
"""    
end

# ╔═╡ f3f072bc-3a8d-11eb-3b54-719f2924e9d2
begin
    @assert solve_prob_1(example_input) == 306
    #@assert solve_prob_2(example_input) == 291
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
# ╠═65f400da-4741-11eb-34c9-9fd0dcfa5bc8
# ╠═43bcf344-473e-11eb-39ca-655c570137e9
# ╠═f1109a84-3a8f-11eb-3ca8-2fdbdd1cc29a
# ╠═129f488c-3a93-11eb-260e-8921353e1039
# ╠═8e4e5560-3a8c-11eb-2612-577833ceee7e
# ╠═f3f072bc-3a8d-11eb-3b54-719f2924e9d2
# ╠═ed7ca23c-3a8f-11eb-34fe-dd7cf712377b
# ╠═5b37cd42-3a90-11eb-25a3-6105e801b231
# ╠═52110486-3a90-11eb-3a4f-11a08a8bd71f
# ╠═3180ae1c-3a93-11eb-01ab-13cc9be93b67
# ╠═2c64697a-3a96-11eb-34ea-ff7f4a67aa99
