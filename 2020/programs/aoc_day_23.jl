### A Pluto.jl notebook ###
# v0.12.17

using Markdown
using InteractiveUtils

# ╔═╡ 0b6188b0-3a8b-11eb-112c-77145e1d99b5
#= 
☃️ Solutions for day 23! ☃️ 

🌟 Part 1: Watch a crab play a short cup game! 🦀 🥤🥤🥤 
🌟 Part 2: Watch a crab play a long cup game!  🦀 🥤🥤🥤🥤🥤🥤🥤🥤...
=#

# ╔═╡ b0bbb420-3d62-11eb-050a-99a665672dba
DAY_NUMBER = 23

# ╔═╡ 81e88cb0-3a8b-11eb-3aba-a3509bff5912
function parse_input(s)
	s = replace(s, "\n" => "")
    cups = map(e -> parse(Int, e), split(s, ""))
			
    return cups
end

# ╔═╡ 80af19c2-47e7-11eb-31de-f15c44119b41
function run_crab_game(cups, n_moves = 100, n_pickup = 3)
	n_cups = length(cups)
			
	# next_cup holds pointers to the cup to the right of each cup
	next_cup = zeros(Int, n_cups)
	for i = 1:n_cups
		if i < n_cups
			next_cup[cups[i]] = cups[i + 1]
		else
			next_cup[cups[i]] = cups[1]
		end
	end
		
	# current cup is the first cup
	cup_curr = cups[1]
	
	for i = 1:n_moves				
		# get the cups the crab picks up
		pickup_cups = [next_cup[cup_curr]]
		for k = 1:(n_pickup - 1)
			push!(pickup_cups, next_cup[pickup_cups[end]])
		end		
		
		# get the destination cup
		cup_dest = cup_curr > 1 ? cup_curr - 1 : n_cups
		while cup_dest ∈ pickup_cups
			cup_dest = cup_dest > 1 ? cup_dest - 1 : n_cups
		end
		
		# the new neighbors for the only cups who get new neighbors:
		nbr_curr = next_cup[pickup_cups[end]]
		nbr_dest = pickup_cups[1]
		nbr_last = next_cup[cup_dest]
		
		# update the next cup for the only cups who get new neighbors:
		next_cup[cup_curr] = nbr_curr
		next_cup[cup_dest] = nbr_dest
		next_cup[pickup_cups[end]] = nbr_last
		
		# for next round, the current cup is one to the right of the 
		# the current cup
		cup_curr = next_cup[cup_curr]
	end
	
	# return updated cups in canonical order, with 1 first 
	cups = zeros(Int, n_cups)
	cups[1] = 1
	for i = 2:n_cups
		cups[i] = next_cup[cups[i - 1]]
	end
	
	return cups
end

# ╔═╡ f1109a84-3a8f-11eb-3ca8-2fdbdd1cc29a
function solve_prob_1(inpt, n_moves = 100)
	# get the cups from the input
	cups = parse_input(inpt)
	
	# play the game
	cups = run_crab_game(cups, n_moves)
	
	return parse(Int, join(cups[2:end]))
end

# ╔═╡ 129f488c-3a93-11eb-260e-8921353e1039
function solve_prob_2(inpt, n_cups = 10^6, n_moves = 10^7)
	# get the cups from the input
	cups_tmp = parse_input(inpt)
	n_given = length(cups_tmp)
	
	# get the rest of the cups
	cups = zeros(Int, n_cups)	
	cups[1:n_given] = cups_tmp
	for k = (n_given + 1) : n_cups
		cups[k] = k
	end
	
	# play the game
	cups = run_crab_game(cups, n_moves)
	
    return cups[2] * cups[3]
end

# ╔═╡ 8e4e5560-3a8c-11eb-2612-577833ceee7e
############################ Examples+Tests ################################
begin 
    example_input = "389125467"
end

# ╔═╡ f3f072bc-3a8d-11eb-3b54-719f2924e9d2
begin
    @assert solve_prob_1(example_input, 10) == 92658374
    @assert solve_prob_1(example_input, 100) == 67384529
    @assert solve_prob_2(example_input) == 149245887792
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
# ╠═80af19c2-47e7-11eb-31de-f15c44119b41
# ╠═f1109a84-3a8f-11eb-3ca8-2fdbdd1cc29a
# ╠═129f488c-3a93-11eb-260e-8921353e1039
# ╠═8e4e5560-3a8c-11eb-2612-577833ceee7e
# ╠═f3f072bc-3a8d-11eb-3b54-719f2924e9d2
# ╠═ed7ca23c-3a8f-11eb-34fe-dd7cf712377b
# ╠═5b37cd42-3a90-11eb-25a3-6105e801b231
# ╠═52110486-3a90-11eb-3a4f-11a08a8bd71f
# ╠═3180ae1c-3a93-11eb-01ab-13cc9be93b67
# ╠═2c64697a-3a96-11eb-34ea-ff7f4a67aa99
