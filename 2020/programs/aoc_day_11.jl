### A Pluto.jl notebook ###
# v0.12.17

using Markdown
using InteractiveUtils

# ╔═╡ 0b6188b0-3a8b-11eb-112c-77145e1d99b5
#= 
☃️ Solutions for Day 11! ☃️

🌟 Part 1: Count stable seating distribution.
=#

# ╔═╡ 5fd23dee-3cf5-11eb-0d23-ef4188aa1dd3
function parse_input(s)
	rows = split(s, "\n", keepempty=false)
	# https://discourse.julialang.org/t/converting-a-array-of-strings-to-an-array-of-char/35123
	rows = reduce(vcat, (permutedims(collect(s)) for s in rows))
	
	return rows
end

# ╔═╡ e717faf6-3cea-11eb-0633-6366b4fb40d1
function fill_seats_v1(seating)
	(nrow, ncol) = size(seating)
	new_seating = copy(seating)
	
	for i = 1:nrow
		for j = 1:ncol
			ilo, ihi = max(i-1, 1), min(i+1, nrow)
			jlo, jhi = max(j-1, 1), min(j+1, ncol)
			nbrs = [seating[ii, jj] for ii ∈ ilo:ihi for jj ∈ jlo:jhi 
						if (ii,jj) != (i,j)]
			
			n_occupied_nbrs = length([n for n in nbrs if n == '#'])
			
			# if seat is empty && no occupied neighbors
			if seating[i, j] == 'L' && n_occupied_nbrs == 0
				new_seating[i, j] = '#'
			end
			
			# if set is occupied and >= 4 neihgbors, seat becomes empty
			if seating[i, j] == '#' && n_occupied_nbrs >= 4
				new_seating[i, j] = 'L'			
			end
			
		end
	end
	
	return new_seating
end

# ╔═╡ 7b288b3c-3cfe-11eb-08d9-130222a937d1
function fill_until_stabilized(seating, fill_seats)
	old_seating = copy(seating)
	new_seating = fill_seats(seating)
	
	while new_seating != old_seating
		old_seating = copy(new_seating)
		new_seating = fill_seats(old_seating)
	end

	return new_seating
end

# ╔═╡ f1109a84-3a8f-11eb-3ca8-2fdbdd1cc29a
function solve_prob_1(seating)
	new_seating = fill_until_stabilized(seating, fill_seats_v1)
	
	return sum(new_seating .== '#')
end

# ╔═╡ 129f488c-3a93-11eb-260e-8921353e1039
function solve_prob_2(seating)
	return nothing
end

# ╔═╡ 8e4e5560-3a8c-11eb-2612-577833ceee7e
############################ Examples+Tests ################################
begin 
	example_input=
"""
L.LL.LL.LL
LLLLLLL.LL
L.L.L..L..
LLLL.LL.LL
L.LL.LL.LL
L.LLLLL.LL
..L.L.....
LLLLLLLLLL
L.LLLLLL.L
L.LLLLL.LL
"""	
	example_seating = parse_input(example_input)
end

# ╔═╡ f3f072bc-3a8d-11eb-3b54-719f2924e9d2
begin
 	@assert solve_prob_1(example_seating) == 37
 	#@assert solve_prob_2(example_pgm) == ???
end

# ╔═╡ ed7ca23c-3a8f-11eb-34fe-dd7cf712377b
############################ Today's Solution ############################
begin
	input_path = "../input/input_day_11.txt"	
	
	problem_input = open(input_path) do file
		read(file, String)
	end	
	
	problem_seating = parse_input(problem_input)
end

# ╔═╡ 5b37cd42-3a90-11eb-25a3-6105e801b231
part_1_soln = solve_prob_1(problem_seating)

# ╔═╡ 52110486-3a90-11eb-3a4f-11a08a8bd71f
println("Day 11: Part 1: ", part_1_soln)

# ╔═╡ 3180ae1c-3a93-11eb-01ab-13cc9be93b67
#part_2_soln = solve_prob_2(problem_pgm)

# ╔═╡ 2c64697a-3a96-11eb-34ea-ff7f4a67aa99
#println("Day 11: Part 2: ", part_2_soln)

# ╔═╡ Cell order:
# ╠═0b6188b0-3a8b-11eb-112c-77145e1d99b5
# ╠═5fd23dee-3cf5-11eb-0d23-ef4188aa1dd3
# ╠═e717faf6-3cea-11eb-0633-6366b4fb40d1
# ╠═7b288b3c-3cfe-11eb-08d9-130222a937d1
# ╠═f1109a84-3a8f-11eb-3ca8-2fdbdd1cc29a
# ╠═129f488c-3a93-11eb-260e-8921353e1039
# ╠═8e4e5560-3a8c-11eb-2612-577833ceee7e
# ╠═f3f072bc-3a8d-11eb-3b54-719f2924e9d2
# ╠═ed7ca23c-3a8f-11eb-34fe-dd7cf712377b
# ╠═5b37cd42-3a90-11eb-25a3-6105e801b231
# ╠═52110486-3a90-11eb-3a4f-11a08a8bd71f
# ╠═3180ae1c-3a93-11eb-01ab-13cc9be93b67
# ╠═2c64697a-3a96-11eb-34ea-ff7f4a67aa99
