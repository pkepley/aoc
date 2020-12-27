### A Pluto.jl notebook ###
# v0.12.17

using Markdown
using InteractiveUtils

# ╔═╡ 0b6188b0-3a8b-11eb-112c-77145e1d99b5
#= 
☃️ Solutions for day 23! ☃️ 

🌟 Part 1: Watch a crab play a short cup game! 🦀 🥤🥤🥤 
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
	cups = deepcopy(cups)
	n_cups = length(cups)
	
	idx_curr = 1
	cup_curr = cups[idx_curr]
	
	for i = 1:n_moves		
		# cups the crab picks up
		idxs_pickup = map(
			k -> (k % n_cups) == 0 ? n_cups : (k % n_cups),
			(idx_curr+1):(idx_curr+n_pickup)
		)		 
		cups_pickup = [cups[k] for k ∈ idxs_pickup]
		
		# remove the picked up cups from the list
		cups = [cups[k] for k ∈ 1:n_cups if k ∉ idxs_pickup]				
		
		# get the destination cup / index
		destination_cup = cup_curr > 1 ? cup_curr - 1 : n_cups
		while destination_cup ∈ cups_pickup
			destination_cup = destination_cup > 1 ? destination_cup - 1 : n_cups
		end
		idx_destination = findfirst(cups .== destination_cup)
		
		# replace the cups
		for k = 1:n_pickup
			insert!(cups, idx_destination + k, cups_pickup[k])
		end
				
		# select the next current cup idx
		idx_curr = findfirst(cups .== cup_curr)
		idx_curr = (idx_curr == n_cups) ? 1 : idx_curr + 1 
		cup_curr = cups[idx_curr]		
	end
	
	return cups
end

# ╔═╡ dd854ef2-47ef-11eb-30b5-d57bdf044b31
join([1,2,3])

# ╔═╡ f1109a84-3a8f-11eb-3ca8-2fdbdd1cc29a
function solve_prob_1(inpt, n_moves = 100)
    cups = parse_input(inpt)
	
	# play the game
	cups = run_crab_game(cups, n_moves)
	
	# re-order so that 1 is first
	idx_1 = findfirst(cups .== 1)
	if idx_1 > 1
		cups = vcat(cups[idx_1:end], cups[1:(idx_1-1)])
	end
	
	return parse(Int, join(cups[2:end]))
end

# ╔═╡ d37b64d6-47eb-11eb-19e2-d5051503bf73
solve_prob_1(example_input_1)

# ╔═╡ 129f488c-3a93-11eb-260e-8921353e1039
function solve_prob_2(inpt)
    parsed_input = parse_input(inpt)    
    return nothing
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
# ╠═80af19c2-47e7-11eb-31de-f15c44119b41
# ╠═d37b64d6-47eb-11eb-19e2-d5051503bf73
# ╠═dd854ef2-47ef-11eb-30b5-d57bdf044b31
# ╠═f1109a84-3a8f-11eb-3ca8-2fdbdd1cc29a
# ╠═129f488c-3a93-11eb-260e-8921353e1039
# ╠═8e4e5560-3a8c-11eb-2612-577833ceee7e
# ╠═f3f072bc-3a8d-11eb-3b54-719f2924e9d2
# ╠═ed7ca23c-3a8f-11eb-34fe-dd7cf712377b
# ╠═5b37cd42-3a90-11eb-25a3-6105e801b231
# ╠═52110486-3a90-11eb-3a4f-11a08a8bd71f
# ╠═3180ae1c-3a93-11eb-01ab-13cc9be93b67
# ╠═2c64697a-3a96-11eb-34ea-ff7f4a67aa99
