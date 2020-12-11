### A Pluto.jl notebook ###
# v0.12.16

using Markdown
using InteractiveUtils

# ╔═╡ 0b6188b0-3a8b-11eb-112c-77145e1d99b5
#= 
🛷 Solutions for Day 9! 🛷

🌟 Part 1: 
=#

# ╔═╡ 81e88cb0-3a8b-11eb-3aba-a3509bff5912
function parse_input(s)
	numbers = split(s, "\n", keepempty=false)		
	numbers = map(s -> parse(Int, s), numbers)
	
	return numbers
end

# ╔═╡ ee44dd4e-3b69-11eb-2170-b79a0ced6be2


# ╔═╡ 1502caec-3b18-11eb-0570-23a8777fce24
function adapter_adjacency(adapter_joltages)
	adapter_joltages = sort(adapter_joltages)
	n_adapters = length(adapter_joltages)
	
	# set up graph as joltage keys and values are adjacent joltages
	# initially none are known
	k = vcat([0], adapter_joltages)
	v = [Dict("ancestor" => [], "descendants" => []) for i ∈ 1:(n_adapters+1)]	
	adapter_adj_graph = Dict(zip(k, v))
	
	# check compatible adapters 
	for i = 0:n_adapters
		if i == 0
			joltage = 0
		else
			joltage = adapter_joltages[i]
		end
		
		# find compatible adapaters from sorted joltage list
		j = i + 1		
		while j <= n_adapters && adapter_joltages[j] <= (joltage + 3)
			
			if ~(adapter_joltages[j] ∈ adapter_adj_graph[joltage]["descendants"])
				push!(adapter_adj_graph[joltage]["descendants"], adapter_joltages[j])
			end

			adapter_adj_graph[adapter_joltages[j]]["ancestor"] = [joltage]
			j += 1
		end
		
	end
	

	
	return adapter_adj_graph
	
end

# ╔═╡ 01d66e66-3b67-11eb-28f0-8fedcd31bd84
function solve_prob_1(adapter_joltages)
	adapter_joltages = reverse(sort(adapter_joltages))
	adapter_adj_graph = adapter_adjacency(adapter_joltages)	
	last_joltage = nothing
	
	#print(adapter_adj_graph)
	
	# find the max joltage adapter we can use from our collection 
	for joltage in adapter_joltages
		#println(joltage)
		if adapter_adj_graph[joltage]["ancestor"] != []			
			last_joltage = joltage
			break
		end
	end
	
	# the last joltage we can use is 3 more than the one above
	joltage_diff_3_cnt = 1
	joltage_diff_1_cnt = 0
	curr_joltage = last_joltage
 	
	# walk back up tree until we reach top of chain, ie wh
	while curr_joltage != 0
		lower_joltage = adapter_adj_graph[curr_joltage]["ancestor"][1]
		
		if curr_joltage - lower_joltage == 1
			joltage_diff_1_cnt += 1
		elseif curr_joltage - lower_joltage == 3
			joltage_diff_3_cnt += 1
		end		
		
		curr_joltage = lower_joltage
	end
	
	return joltage_diff_3_cnt * joltage_diff_1_cnt
	
end

# ╔═╡ 129f488c-3a93-11eb-260e-8921353e1039
function solve_prob_2(pgm)
	return nothing
end

# ╔═╡ 8e4e5560-3a8c-11eb-2612-577833ceee7e
############################ Examples+Tests ################################
begin 
	example_input_1="""
16
10
15
5
1
11
7
19
6
12
4"""
	
	example_joltages_1 = parse_input(example_input_1)
	
	example_input_2="""
28
33
18
42
31
14
46
20
48
47
24
23
49
45
19
38
39
11
1
32
25
35
8
17
7
9
4
2
34
10
3"""
	example_joltages_2 = parse_input(example_input_2)
end

# ╔═╡ 877b79a2-3b68-11eb-2939-95d30b0de45f
begin
	@assert solve_prob_1(example_joltages_1) == 7 * 5
	@assert solve_prob_1(example_joltages_2) == 10 * 22
end

# ╔═╡ ed7ca23c-3a8f-11eb-34fe-dd7cf712377b
############################ Today's Solution ############################
begin
	input_path = "../input/input_day_10.txt"	
	
	problem_input = open(input_path) do file
		read(file, String)
	end	
	
	problem_joltages = parse_input(problem_input)
end

# ╔═╡ 5b37cd42-3a90-11eb-25a3-6105e801b231
part_1_soln = solve_prob_1(problem_joltages)

# ╔═╡ 52110486-3a90-11eb-3a4f-11a08a8bd71f
println("Day 10: Part 1: ", part_1_soln)

# ╔═╡ 3180ae1c-3a93-11eb-01ab-13cc9be93b67
#part_2_soln = solve_prob_2(problem_pgm)

# ╔═╡ 2c64697a-3a96-11eb-34ea-ff7f4a67aa99
#println("Day 9: Part 2: ", part_2_soln)

# ╔═╡ Cell order:
# ╠═0b6188b0-3a8b-11eb-112c-77145e1d99b5
# ╠═81e88cb0-3a8b-11eb-3aba-a3509bff5912
# ╟─ee44dd4e-3b69-11eb-2170-b79a0ced6be2
# ╠═1502caec-3b18-11eb-0570-23a8777fce24
# ╠═01d66e66-3b67-11eb-28f0-8fedcd31bd84
# ╠═129f488c-3a93-11eb-260e-8921353e1039
# ╠═8e4e5560-3a8c-11eb-2612-577833ceee7e
# ╠═877b79a2-3b68-11eb-2939-95d30b0de45f
# ╠═ed7ca23c-3a8f-11eb-34fe-dd7cf712377b
# ╠═5b37cd42-3a90-11eb-25a3-6105e801b231
# ╠═52110486-3a90-11eb-3a4f-11a08a8bd71f
# ╠═3180ae1c-3a93-11eb-01ab-13cc9be93b67
# ╠═2c64697a-3a96-11eb-34ea-ff7f4a67aa99
