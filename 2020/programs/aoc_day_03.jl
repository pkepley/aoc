### A Pluto.jl notebook ###
# v0.12.16

using Markdown
using InteractiveUtils

# ╔═╡ 4628228a-3892-11eb-3d97-cb27f2320650
#=
🛷 Solutions for Day 3! 🛷

🌟 Part 1: Count trees 🎄 that we hit while sleighing 🛷 along a single path.
🌟 Part 2: Count trees 🎄 that we hit while sleighing 🛷 along multiple paths.
=#

# ╔═╡ b1308e1c-3892-11eb-35ae-5113f275ca03
function parse_input(s)
	inpt = split(s, "\n", keepempty=false)
	return inpt
end

# ╔═╡ c28873ca-3892-11eb-140a-efc2632d1fc1
begin 
example_str ="""
..##.......
#...#...#..
.#....#..#.
..#.#...#.#
.#...##..#.
..#.##.....
.#.#.#....#
.#........#
#.##...#...
#...##....#
.#..#...#.#
"""

example_forest_patch = parse_input(example_str)
end

# ╔═╡ cde70380-3892-11eb-0067-c1807d2d140c
begin
	input_path = "../input/input_day_03.txt"	
	
	s_input = open(input_path) do file
		read(file, String)
	end	

	problem_forest_patch = parse_input(s_input)
end

# ╔═╡ 658a6ef2-3893-11eb-06d7-7d711af28588
function count_collisions(right::Integer, down::Integer, forest_patch)
	if down <= 0 | right < 0
		throw(DomainError())
	end
	
	patch_height = length(forest_patch)
	patch_width = length(forest_patch[1])
	trees_hit = 0
	
	j = 1
	for i = (1 + down) : down : patch_height
		j = j + right
		j = (j > patch_width) ? (j % patch_width) : j
		
		if forest_patch[i][j] == '#'
			trees_hit += 1
		end
	end
	
	return trees_hit	
end

# ╔═╡ af05de0e-3896-11eb-0045-4d799be5bf95
function solve_prob_1(forest_patch)
	return count_collisions(3, 1, forest_patch)
end

# ╔═╡ 4ffd2986-3897-11eb-2d35-0d2dd9468942
# Note: weird syntax for tuples!
# https://discourse.julialang.org/t/anonymous-functions-with-tuple-arguments/3306/3

function solve_prob_2(forest_patch)	
	slope_list = [(1,1), (3,1), (5,1), (7,1), (1,2)]
	trees_hit = map(((r, d),) -> count_collisions(r, d, forest_patch), slope_list)
	return prod(trees_hit)
end

# ╔═╡ ed0c8a1c-3894-11eb-31eb-098a6854fcb7
begin 
	@assert solve_prob_1(example_forest_patch) == 7
	@assert solve_prob_2(example_forest_patch) == 336
end

# ╔═╡ e1640ff8-3896-11eb-2226-3787b1aa85bb
part_1_soln = solve_prob_1(problem_forest_patch)

# ╔═╡ 1a1e77e8-3897-11eb-3dd7-8b7e7ccedb2a
println("Day 3. Part 1: ", part_1_soln)

# ╔═╡ 9f16f3e4-3897-11eb-0a9f-af2f1e969455
part_2_soln = solve_prob_2(problem_forest_patch)

# ╔═╡ 57894e36-3898-11eb-304c-b152c7720e4c
println("Day 3. Part 2: ", part_2_soln)

# ╔═╡ Cell order:
# ╠═4628228a-3892-11eb-3d97-cb27f2320650
# ╠═b1308e1c-3892-11eb-35ae-5113f275ca03
# ╠═c28873ca-3892-11eb-140a-efc2632d1fc1
# ╠═cde70380-3892-11eb-0067-c1807d2d140c
# ╠═658a6ef2-3893-11eb-06d7-7d711af28588
# ╠═af05de0e-3896-11eb-0045-4d799be5bf95
# ╠═4ffd2986-3897-11eb-2d35-0d2dd9468942
# ╠═ed0c8a1c-3894-11eb-31eb-098a6854fcb7
# ╠═e1640ff8-3896-11eb-2226-3787b1aa85bb
# ╠═1a1e77e8-3897-11eb-3dd7-8b7e7ccedb2a
# ╠═9f16f3e4-3897-11eb-0a9f-af2f1e969455
# ╠═57894e36-3898-11eb-304c-b152c7720e4c
