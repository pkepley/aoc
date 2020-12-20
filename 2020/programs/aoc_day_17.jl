### A Pluto.jl notebook ###
# v0.12.17

using Markdown
using InteractiveUtils

# ╔═╡ 0b6188b0-3a8b-11eb-112c-77145e1d99b5
#=
🎁 Solutions for Day 17! 🎁

🌟 Part 1: Determine how many energy cube things there are in 3D ⚡🧊⚡
🌟 Part 2: Determine how many energy cube things there are in 4D ⚡🧊⚡

=#

# ╔═╡ b0bbb420-3d62-11eb-050a-99a665672dba
DAY_NUMBER = 17

# ╔═╡ 81e88cb0-3a8b-11eb-3aba-a3509bff5912
function parse_input(s, dim = 3)
	rows = split(s, "\n", keepempty=false)
	ny = length(rows)
	
	# get the inital active positions in the starting plane
	active = [[x-1 ny - y] for y = 1:ny for x ∈ findall(e->(e=='#'), rows[y])]
	n_active = length(active)
	
	# embed the starting plane in the appropriate dimension
	active = vcat(active...)	
	active = hcat(active, zeros(Int, n_active, dim - 2))
	active = [active[i,:] for i = 1:n_active]
	
	# we will use a dictionary to flag active/inactive states
	active = Dict(map(e -> (e, true), active))
	
	return active
end

# ╔═╡ d370e1e4-422a-11eb-0da1-efe5893f62e0
function neighbors(p)
	dim = length(p)
	nbrs = []
	
	for offset ∈ Iterators.product(ntuple(i->[-1,0,1], dim)...)
		offset = collect(offset)
		if iszero(offset) == false
			push!(nbrs, p + offset)
		end
	end
	
	return nbrs
end

# ╔═╡ 67671592-4228-11eb-19d4-8d5e95e35e92
function active_candidates!(candidates, dim = 3)	
	actives = [k for k ∈ keys(candidates) if candidates[k] == true]
	
	for p ∈ actives
		for n in neighbors(p)
			if haskey(candidates, n) == false
				candidates[n] = false
			end
		end
	end
	
	return candidates
end

# ╔═╡ 3f7b51d6-4270-11eb-3352-a58dc893fee6
function update!(candidates, dim = 3)
	candidates = active_candidates!(candidates, dim)
	
	active_neighbor_count = Dict()
	for p ∈ keys(candidates)
		active_neighbor_count[p] = length([n for n ∈ neighbors(p) if 
						haskey(candidates, n) && candidates[n] == true])
	end
	
	for p ∈ keys(candidates)
		if candidates[p] == true 
			candidates[p] = (active_neighbor_count[p] ∈ [2,3])
		else
			candidates[p] = (active_neighbor_count[p] == 3)
		end
	end
	
	for p ∈ keys(candidates)
		if candidates[p] == false
			pop!(candidates, p)
		end
	end
	
	return candidates	
end

# ╔═╡ fea6cafe-427a-11eb-2aaf-750f66440b7d
function run_update_sequence!(candidates, n_cycles = 6)
	for i = 1:n_cycles
		candidates = update!(candidates)	
	end
	
	return candidates
end

# ╔═╡ f1109a84-3a8f-11eb-3ca8-2fdbdd1cc29a
function solve_prob_1(inpt)
	candidates = parse_input(inpt, 3)
	
	# updates 6 times
	candidates = run_update_sequence!(candidates)
	
	return length([p for p ∈ keys(candidates) if candidates[p] == true])
end

# ╔═╡ 129f488c-3a93-11eb-260e-8921353e1039
function solve_prob_2(inpt)
	candidates = parse_input(inpt, 4)
	
	# updates 6 times
	candidates = run_update_sequence!(candidates)
	
	return length([p for p ∈ keys(candidates) if candidates[p] == true])
end

# ╔═╡ 8e4e5560-3a8c-11eb-2612-577833ceee7e
############################ Examples+Tests ################################
begin 
	example_input="""
.#.
..#
###
"""
	
end

# ╔═╡ f3f072bc-3a8d-11eb-3b54-719f2924e9d2
begin
	@assert solve_prob_1(example_input) == 112
	@assert solve_prob_2(example_input) == 848
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
# ╠═d370e1e4-422a-11eb-0da1-efe5893f62e0
# ╠═67671592-4228-11eb-19d4-8d5e95e35e92
# ╠═3f7b51d6-4270-11eb-3352-a58dc893fee6
# ╠═fea6cafe-427a-11eb-2aaf-750f66440b7d
# ╠═f1109a84-3a8f-11eb-3ca8-2fdbdd1cc29a
# ╠═129f488c-3a93-11eb-260e-8921353e1039
# ╠═8e4e5560-3a8c-11eb-2612-577833ceee7e
# ╠═f3f072bc-3a8d-11eb-3b54-719f2924e9d2
# ╠═ed7ca23c-3a8f-11eb-34fe-dd7cf712377b
# ╠═5b37cd42-3a90-11eb-25a3-6105e801b231
# ╠═52110486-3a90-11eb-3a4f-11a08a8bd71f
# ╠═3180ae1c-3a93-11eb-01ab-13cc9be93b67
# ╠═2c64697a-3a96-11eb-34ea-ff7f4a67aa99
