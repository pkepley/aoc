### A Pluto.jl notebook ###
# v0.12.17

using Markdown
using InteractiveUtils

# ╔═╡ 0b6188b0-3a8b-11eb-112c-77145e1d99b5
#= 
🎄 Solutions for day 13! 🎄

🌟 Part 1: Find first bus arrival! 🚌
🌟 Part 2: Find next time all busses arrive at same time! 🚌 🚌 🚌

=#

# ╔═╡ b0bbb420-3d62-11eb-050a-99a665672dba
DAY_NUMBER = 13 

# ╔═╡ 81e88cb0-3a8b-11eb-3aba-a3509bff5912
function parse_input(s)
	rows = split(s, "\n", keepempty=false)	
	
	if length(rows) > 1
		timestamp = parse(Int, rows[1])
		busrows = rows[2]
	else
		timestamp = nothing
		busrows = rows[1]
	end
		
	buslines = [b == "x" ? nothing : parse(Int, b) for b ∈ 
			split(busrows, ",", keepempty=false)]
	
	return timestamp, buslines
end

# ╔═╡ 544a1e36-3d97-11eb-0e81-6920d87da9dc
function first_bus_after_timestamp(timestamp, buslines)
	# how long to wait?
	wait_times = [b - (timestamp % b) for b in buslines if b != nothing]
	
	# when is the next
	idx_next = argmin(wait_times)
	
	# which is next & how long
	next_bus = buslines[idx_next]
	wait_time = wait_times[idx_next]
	
	return (next_bus, wait_time)
end

# ╔═╡ 3015d96c-3dae-11eb-1adf-7999b687435d
function solve_bezout(a, b)
	# Find integers m, n such that 
	#   gcd(a, b) = m * a + n * a
	
	r_old, s_old, t_old = a, 1, 0
	r_cur, s_cur, t_cur = b, 0, 1	
	
	while r_cur != 0
		q = r_old ÷ r_cur		
		r_cur, r_old = r_old - q * r_cur, r_cur
		s_cur, s_old = s_old - q * s_cur, s_cur
		t_cur, t_old = t_old - q * t_cur, t_cur
	end
	
	return s_old, t_old
end

# ╔═╡ ea0bffec-3dac-11eb-3c5d-91194afe9051
function apply_chinese_remainder_thm(as, ns)
	# Solve system of equations
	#    x == ai mod ni  for i = 1, ..., k
	# Using the method outlined here:
	#    https://tinyurl.com/y4lfoh52 (Wikipedia, Direct Construction)	
	N = prod(ns)	
	Ns = [N ÷ ni for ni ∈ ns]
	Ms = []
		
	for i = 1:length(ns)
		Mi, mi = solve_bezout(Ns[i], ns[i])
		push!(Ms, Mi) 
	end
	
	return mod(sum(map(prod, zip(as, Ms, Ns))),  N)
end

# ╔═╡ d14f2232-3dab-11eb-1d15-8f3d5a711e3b
function joint_bus_arrival_time(bus_arrivals)
	buslines = [b for b in bus_arrivals if b != nothing]
	arrival_delays = [-(indexin(b, bus_arrivals)[1] - 1) for b in buslines]

	return apply_chinese_remainder_thm(arrival_delays, buslines)
end

# ╔═╡ f1109a84-3a8f-11eb-3ca8-2fdbdd1cc29a
function solve_prob_1(inpt)
	timestamp, buslines = parse_input(inpt)	
	buslines = [b for b in buslines if b != nothing]
	next_bus, wait_time = first_bus_after_timestamp(timestamp, buslines)

	return next_bus * wait_time
end

# ╔═╡ 129f488c-3a93-11eb-260e-8921353e1039
function solve_prob_2(inpt)
	timestamp, bus_arrivals = parse_input(inpt)
	
	return joint_bus_arrival_time(bus_arrivals)
end

# ╔═╡ 8e4e5560-3a8c-11eb-2612-577833ceee7e
############################ Examples+Tests ################################
begin 
	example_input="""
939
7,13,x,x,59,x,31,19
"""
end

# ╔═╡ f3f072bc-3a8d-11eb-3b54-719f2924e9d2
begin
	# part 1
	@assert solve_prob_1(example_input) == 295
	
	# part 2
	@assert solve_prob_2(example_input) == 1068781
	@assert solve_prob_2("17,x,13,19") == 3417
	@assert solve_prob_2("67,7,59,61") == 754018
	@assert solve_prob_2("67,x,7,59,61") == 779210
	@assert solve_prob_2("67,7,x,59,61") == 1261476
	@assert solve_prob_2("1789,37,47,1889") == 1202161486
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
# ╠═544a1e36-3d97-11eb-0e81-6920d87da9dc
# ╠═3015d96c-3dae-11eb-1adf-7999b687435d
# ╠═ea0bffec-3dac-11eb-3c5d-91194afe9051
# ╠═d14f2232-3dab-11eb-1d15-8f3d5a711e3b
# ╠═f1109a84-3a8f-11eb-3ca8-2fdbdd1cc29a
# ╠═129f488c-3a93-11eb-260e-8921353e1039
# ╠═8e4e5560-3a8c-11eb-2612-577833ceee7e
# ╠═f3f072bc-3a8d-11eb-3b54-719f2924e9d2
# ╠═ed7ca23c-3a8f-11eb-34fe-dd7cf712377b
# ╠═5b37cd42-3a90-11eb-25a3-6105e801b231
# ╠═52110486-3a90-11eb-3a4f-11a08a8bd71f
# ╠═3180ae1c-3a93-11eb-01ab-13cc9be93b67
# ╠═2c64697a-3a96-11eb-34ea-ff7f4a67aa99
