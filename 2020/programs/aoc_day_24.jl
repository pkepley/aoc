### A Pluto.jl notebook ###
# v0.12.17

using Markdown
using InteractiveUtils

# ╔═╡ 0b6188b0-3a8b-11eb-112c-77145e1d99b5
#= 
🎁 Solutions for day 24! 🎁

🌟 Part 1: Flippin' hexagonal tiles. ❄️
🌟 Part 2: Conway Redux. This time, it's hexagonal. ❄️

=#

# ╔═╡ b0bbb420-3d62-11eb-050a-99a665672dba
DAY_NUMBER = 24

# ╔═╡ 81e88cb0-3a8b-11eb-3aba-a3509bff5912
function parse_input(s)
	# replace the list values by unique values for each direction.
	# the order in which we perform the substitution matters here.
	subs = ["ne" => 1, "se" => 3, "e" => 2, "nw" => 6, "sw" => 4, "w" => 5]
	for sub ∈ subs
		s  = replace(s, sub)
	end	
	
	# split the rows
    rows = split(s, "\n", keepempty=false)		
	rows = map(r -> split(r, "", keepempty=false), rows)
	rows = map(r -> map(e -> parse(Int, e), r), rows)
	
	# convert the integer identifiers back to directions
	unsubs = ["ne", "e", "se", "sw", "w", "nw"]
	instructions  = map(r -> map(e -> unsubs[e], r), rows)	
	
    return instructions
end

# ╔═╡ 6eb87f9c-487d-11eb-3a78-059aba99f75e
function initial_flips(instructions)	
	dirs = Dict("ne" => [ 1, 2], "e" => [ 2, 0], "se" => [ 1, -2],
		        "sw" => [-1,-2], "w" => [-2, 0], "nw" => [-1,  2])	
		
	flipped_tiles = Dict()
	
	for instr ∈ instructions 
		pos = sum(map(d -> dirs[d], instr))
		
		if haskey(flipped_tiles, pos)
			flipped_tiles[pos] = !flipped_tiles[pos]
		else
			flipped_tiles[pos] = true
		end
	end
	
	for k ∈ keys(flipped_tiles)
		if !flipped_tiles[k]
			delete!(flipped_tiles, k)
		end
	end
	
	return flipped_tiles
end

# ╔═╡ 40e1d390-48aa-11eb-0694-a50484f5f901
function update_tiles(flipped_tiles)	
	dirs = [[ 1, 2], [ 2, 0], [ 1, -2], [-1,-2], [-2, 0], [-1,  2]]

	# candidate positions
	candidates = Set()	
	for pos ∈ keys(flipped_tiles)
		push!(candidates, pos)
		
		for d ∈ dirs
			push!(candidates, pos + d)
		end
	end
	
	# update the tiles based on some conway life game-ish rules
	updated_tiles = Dict()	
	for pos ∈ candidates		
		nbrs = [pos + d for d ∈ dirs]
		flipped_nbrs = [n for n ∈ nbrs if haskey(flipped_tiles, n)]
		n_nbrs_flipped = length(flipped_nbrs)
				
		# these tiles are white
		if !haskey(flipped_tiles, pos)
			# if it has exactly 2 flipped neighbors, flip to black
			updated_tiles[pos] = (n_nbrs_flipped == 2)			
			
		# these tiles are black
		else
			# if it has 0 or >2 flipped neighbors, flip it back to white
			if (n_nbrs_flipped == 0) || (n_nbrs_flipped > 2)
				updated_tiles[pos] = false
			else
				updated_tiles[pos] = true
			end
		end
	end
	
	# remove any non-black tiles
	for k ∈ keys(updated_tiles)
		if !updated_tiles[k]
			delete!(updated_tiles, k)
		end
	end

	return updated_tiles
end

# ╔═╡ f1109a84-3a8f-11eb-3ca8-2fdbdd1cc29a
function solve_prob_1(inpt)
    tile_instructions = parse_input(inpt)
	flipped_tiles = initial_flips(tile_instructions)
	
    return length(keys(flipped_tiles))
end

# ╔═╡ 129f488c-3a93-11eb-260e-8921353e1039
function solve_prob_2(inpt, n_days = 100)
    tile_instructions = parse_input(inpt)
	flipped_tiles = initial_flips(tile_instructions)
	
	for i = 1:n_days
		flipped_tiles = update_tiles(flipped_tiles)
	end
	
    return length(flipped_tiles)
end

# ╔═╡ 8e4e5560-3a8c-11eb-2612-577833ceee7e
############################ Examples+Tests ################################
begin 
    example_input="""
sesenwnenenewseeswwswswwnenewsewsw
neeenesenwnwwswnenewnwwsewnenwseswesw
seswneswswsenwwnwse
nwnwneseeswswnenewneswwnewseswneseene
swweswneswnenwsewnwneneseenw
eesenwseswswnenwswnwnwsewwnwsene
sewnenenenesenwsewnenwwwse
wenwwweseeeweswwwnwwe
wsweesenenewnwwnwsenewsenwwsesesenwne
neeswseenwwswnwswswnw
nenwswwsewswnenenewsenwsenwnesesenew
enewnwewneswsewnwswenweswnenwsenwsw
sweneswneswneneenwnewenewwneswswnese
swwesenesewenwneswnwwneseswwne
enesenwswwswneneswsenwnewswseenwsese
wnwnesenesenenwwnenwsewesewsesesew
nenewswnwewswnenesenwnesewesw
eneswnwswnwsenenwnwnwwseeswneewsenese
neswnwewnwnwseenwseesewsenwsweewe
wseweeenwnesenwwwswnew
"""    
end

# ╔═╡ f3f072bc-3a8d-11eb-3b54-719f2924e9d2
begin
    @assert solve_prob_1(example_input) == 10
    @assert solve_prob_2(example_input) == 2208
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
# ╠═6eb87f9c-487d-11eb-3a78-059aba99f75e
# ╠═40e1d390-48aa-11eb-0694-a50484f5f901
# ╠═f1109a84-3a8f-11eb-3ca8-2fdbdd1cc29a
# ╠═129f488c-3a93-11eb-260e-8921353e1039
# ╠═8e4e5560-3a8c-11eb-2612-577833ceee7e
# ╠═f3f072bc-3a8d-11eb-3b54-719f2924e9d2
# ╠═ed7ca23c-3a8f-11eb-34fe-dd7cf712377b
# ╠═5b37cd42-3a90-11eb-25a3-6105e801b231
# ╠═52110486-3a90-11eb-3a4f-11a08a8bd71f
# ╠═3180ae1c-3a93-11eb-01ab-13cc9be93b67
# ╠═2c64697a-3a96-11eb-34ea-ff7f4a67aa99
