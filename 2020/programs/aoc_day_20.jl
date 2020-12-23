### A Pluto.jl notebook ###
# v0.12.17

using Markdown
using InteractiveUtils

# ╔═╡ 0b6188b0-3a8b-11eb-112c-77145e1d99b5
#= 
🦌 Solutions for Day 20! 🦌
 
🌟 Part 1: Piece together parts of an image 📷 📷 📷
🌟 Part 2: Find monsters in the image 🦕 🦕 🦕
=#

# ╔═╡ b0bbb420-3d62-11eb-050a-99a665672dba
DAY_NUMBER = 20 

# ╔═╡ 81e88cb0-3a8b-11eb-3aba-a3509bff5912
function parse_input(s)
    blocks = split(s, "\n\n", keepempty=false)	
	
	# extract the tile id from each text block
	tile_matcher = r"Tile (?<id>\d+):"
	tile_ids = map(s -> parse(Int, match(tile_matcher, s)["id"]), blocks)

	# extract each tile from each text block into a 2d Char array
	tiles = map(s -> split(s, "\n", keepempty=false)[2:end], blocks)
	tiles = map(t -> reduce(vcat, permutedims.(collect.(t))), tiles)
	
	# return a dict for tile_id -> tile
    return Dict(zip(tile_ids, tiles))
end

# ╔═╡ 66e58d30-4497-11eb-2002-6b82d602c248
function to_boundary_type(edge)
	edge = join(edge, "")
	return Set([edge, join(reverse(edge), "")])
end

# ╔═╡ 8f6c2238-446e-11eb-3f26-29ceff2231d3
function boundary_types(tile)
	edges = [tile[1, :],  # top edge
			tile[:, end], # left edge
			tile[end, :], # bottom edge
			tile[:, 1]]   # right edge
	edges = map(e -> join(collect(e), ""), edges)
		
	return map(to_boundary_type, edges)
end

# ╔═╡ 7445c19c-447a-11eb-0a25-9fc871869fd0
function match_boundaries(tiles_by_id)	
	tile_ids = keys(tiles_by_id)
	tiles = values(tiles_by_id)
	n_tiles = length(tiles)
	
	bndry_types = Dict(zip(tile_ids, map(boundary_types, tiles)))
	adjacencies = Dict(zip(tile_ids, map(s -> Dict(), 1:n_tiles)))
	
	# Let's do some O(n^2) junk to match tiles along their boundaries
	for t1 ∈ keys(bndry_types)
		for bt ∈ bndry_types[t1]
			for t2 ∈ keys(bndry_types) 
				# does t1 share a boundary with t2? if so,
				# add an adacency from t1 -> t2 through bt 
				if t1 != t2 && bt ∈ bndry_types[t2]
					adjacencies[t1][bt] = t2
				end
			end
		end
	end
	
	return adjacencies
end

# ╔═╡ b903ada6-4493-11eb-04e8-9324b3b3ff42
function rotate_2d_array(a, deg)	
	deg = mod(deg, 360)
	
	if deg == 90
		return collect(permutedims(reverse(a, dims = 1)))
	elseif deg == 180
		return reverse(reverse(a, dims=1), dims = 2)		
	elseif deg == 270
		return reverse(permutedims(a), dims = 1)		
	elseif deg == 0
		return a
	else
		return nothing
	end
end

# ╔═╡ e6659662-4496-11eb-129f-131346785883
function align_boundaries(t1, t2, align_along)
	if align_along == "right_to_left"
		bt1 = to_boundary_type(t1[:, end])			
		bts2 = boundary_types(t2)		
		idx_match = findfirst(e -> (e == bt1), bts2)
		idx_rot = 4 - idx_match
		
		# rotate until the edges are aligned
		t2 = rotate_2d_array(t2, 90 * idx_rot)		
		
		# ensure correct orientation, flipud if edges are misoriented
		if t1[:, end] != t2[:, 1]
			t2 = reverse(t2, dims = 1)
		end		
		
	elseif align_along == "bottom_to_top"
		bt1 = to_boundary_type(t1[end, :])
		bts2 = boundary_types(t2)		
		idx_match = findfirst(e -> (e == bt1), bts2)
		idx_rot = 1 - idx_match
		
		# rotate until the edges are aligned
		t2 = rotate_2d_array(t2, 90 * idx_rot)		
		
		# ensure correct orientation, fliplr if edges are misoriented
		if t1[end, :] != t2[1, :]
			t2 = reverse(t2, dims = 2)
		end
	end
	
	return t2
end

# ╔═╡ 734c5492-4487-11eb-0913-35cd6768ec9d
function build_image(tiles_by_id)
	tile_ids = collect(keys(tiles_by_id))	
	adjacencies = match_boundaries(tiles_by_id)	
	
	# we will store tile_id positions in a 2d array
	n_tiles = length(tile_ids)
	n_rows  = Int(sqrt(n_tiles))
	filled_tile_ids = zeros(Int, n_rows, n_rows)
	
	# we will store the final results in a 2d array
	n_ppt = size(tiles_by_id[tile_ids[1]])[1] - 2
	final_img = Array{Char}(undef, n_ppt * n_rows, n_ppt * n_rows)
	
	# we will first fill in the left-most corner to start the process
	corner_tiles = filter(t -> length(adjacencies[t]) == 2, tile_ids)
	curr_tile_id = corner_tiles[1]
	curr_tile = tiles_by_id[curr_tile_id]
	bt = boundary_types(curr_tile)

	# re-orient tile so that top edge has no adjacency
	if haskey(adjacencies[curr_tile_id], bt[1])		
		curr_tile = reverse(curr_tile, dims = 1)
	end
	# re-orient tile so that left edge has no adjacency
	if haskey(adjacencies[curr_tile_id], bt[4])
		curr_tile = reverse(curr_tile, dims = 2)
	end	
	
	# place the current tile in the upper left corner of the image
	tiles_by_id[curr_tile_id] = curr_tile
	filled_tile_ids[1, 1] = curr_tile_id
	final_img[1:n_ppt,  1:n_ppt] = curr_tile[2:(end-1), 2:(end-1)]
	
	for i = 1:n_rows
		for j = 1:n_rows						
			# if (i == 1) fill from left			
			if i == 1 && j > 1			
				t_src_id = filled_tile_ids[i, j-1]				
				t_src = tiles_by_id[t_src_id]
				bt_src = to_boundary_type(t_src[:, end])
				align_along = "right_to_left"				
				
			# if (i > 1)  fill from top
			elseif i > 1
				t_src_id = filled_tile_ids[i-1, j]
				t_src = tiles_by_id[t_src_id]
				bt_src = to_boundary_type(t_src[end, :])
				align_along = "bottom_to_top"					
			end
			
			# update the id array and final image
			if (i,j) != (1,1)										
				# fill in the target id in the (i,j) position of the id array
				t_tgt_id = adjacencies[t_src_id][bt_src]
				filled_tile_ids[i, j] = t_tgt_id
				
				# add the a target tile to the final image in the (i,j) position
				t_tgt = tiles_by_id[t_tgt_id]				
				t_tgt = align_boundaries(t_src, t_tgt, align_along)
				tiles_by_id[t_tgt_id] = t_tgt		
				
				final_img[((i-1)*n_ppt+1):(i*n_ppt), 
						  ((j-1)*n_ppt+1):(j*n_ppt)] = t_tgt[2:(end-1), 2:(end-1)]
			end			
		end
	end	
	
	return filled_tile_ids, final_img

end

# ╔═╡ a29fcf72-44e0-11eb-2701-179f67f53ef4
function sea_monster_template()
	sea_monster = """
	XXXXXXXXXXXXXXXXXX#X
	#XXXX##XXXX##XXXX###
	X#XX#XX#XX#XX#XX#XXX
	"""	
	sea_monster = split(sea_monster, "\n", keepempty=false)
	sea_monster = reduce(vcat, permutedims.(collect.(sea_monster)))
	
	return sea_monster
end	

# ╔═╡ be1b989c-44bf-11eb-3808-53b1a36697d8
function count_sea_monsters(final_img)
	(nr, nc) = size(final_img)

	# get template for matching the seamonster
	sea_monster = sea_monster_template()
	n_hash_per_monster = count(==('#'), join(sea_monster))
	(kh, kw) = size(sea_monster)
	
	# reorient the image and count monster matches
	monster_match_cnt = 0	
	for k = 0:7
		# reorient the image
		search_img = rotate_2d_array(final_img, 90 * (k % 4))
		if k > 4
			search_img = reverse(search_img, dims = 1)
		end
		
		# pass the template over the image
		for i = 0:(nr - kh)
			for j = 0:(nc - kw)
				search_patch = search_img[(i+1):(kh+i), (j+1):(kw+j)]
				
				if sum(sea_monster .== search_patch) == n_hash_per_monster			
					monster_match_cnt += 1
				end
			end
		end		
		
		# stop if we found the monsters
		if monster_match_cnt > 0
			break
		end
	end

	return monster_match_cnt
end

# ╔═╡ f1109a84-3a8f-11eb-3ca8-2fdbdd1cc29a
function solve_prob_1(inpt)
	tiles = parse_input(inpt)
	map(boundary_types, values(tiles))
	(filled_tile_ids, final_img) = build_image(tiles)
	
	return filled_tile_ids[1,1] * filled_tile_ids[end, 1] *
	       filled_tile_ids[1, end] * filled_tile_ids[end, end] 		 
end

# ╔═╡ 129f488c-3a93-11eb-260e-8921353e1039
function solve_prob_2(inpt)
	tiles = parse_input(inpt)
	map(boundary_types, values(tiles))
	(filled_tile_ids, final_img) = build_image(tiles)
	
	# water roughness is just the number of hashes which weren't part
	# of a monster
	n_monsters = count_sea_monsters(final_img)
	n_hash_signs = count(==('#'), join(final_img))
	n_hash_per_monster = count(==('#'), join(sea_monster_template()))
	water_roughness = n_hash_signs - n_monsters * n_hash_per_monster
	
    return water_roughness
end

# ╔═╡ 8e4e5560-3a8c-11eb-2612-577833ceee7e
############################ Examples+Tests ################################
begin 
    example_input="""
Tile 2311:
..##.#..#.
##..#.....
#...##..#.
####.#...#
##.##.###.
##...#.###
.#.#.#..##
..#....#..
###...#.#.
..###..###

Tile 1951:
#.##...##.
#.####...#
.....#..##
#...######
.##.#....#
.###.#####
###.##.##.
.###....#.
..#.#..#.#
#...##.#..

Tile 1171:
####...##.
#..##.#..#
##.#..#.#.
.###.####.
..###.####
.##....##.
.#...####.
#.##.####.
####..#...
.....##...

Tile 1427:
###.##.#..
.#..#.##..
.#.##.#..#
#.#.#.##.#
....#...##
...##..##.
...#.#####
.#.####.#.
..#..###.#
..##.#..#.

Tile 1489:
##.#.#....
..##...#..
.##..##...
..#...#...
#####...#.
#..#.#.#.#
...#.#.#..
##.#...##.
..##.##.##
###.##.#..

Tile 2473:
#....####.
#..#.##...
#.##..#...
######.#.#
.#...#.#.#
.#########
.###.#..#.
########.#
##...##.#.
..###.#.#.

Tile 2971:
..#.#....#
#...###...
#.#.###...
##.##..#..
.#####..##
.#..####.#
#..#.#..#.
..####.###
..#.#.###.
...#.#.#.#

Tile 2729:
...#.#.#.#
####.#....
..#.#.....
....#..#.#
.##..##.#.
.#.####...
####.#.#..
##.####...
##..#.##..
#.##...##.

Tile 3079:
#.#.#####.
.#..######
..#.......
######....
####.#..#.
.#...#.##.
#.#####.##
..#.###...
..#.......
..#.###...
"""    
end

# ╔═╡ f3f072bc-3a8d-11eb-3b54-719f2924e9d2
begin
    @assert solve_prob_1(example_input) == 20899048083289
    @assert solve_prob_2(example_input) == 273
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
# ╠═66e58d30-4497-11eb-2002-6b82d602c248
# ╠═8f6c2238-446e-11eb-3f26-29ceff2231d3
# ╠═7445c19c-447a-11eb-0a25-9fc871869fd0
# ╠═b903ada6-4493-11eb-04e8-9324b3b3ff42
# ╠═e6659662-4496-11eb-129f-131346785883
# ╠═734c5492-4487-11eb-0913-35cd6768ec9d
# ╠═a29fcf72-44e0-11eb-2701-179f67f53ef4
# ╠═be1b989c-44bf-11eb-3808-53b1a36697d8
# ╠═f1109a84-3a8f-11eb-3ca8-2fdbdd1cc29a
# ╠═129f488c-3a93-11eb-260e-8921353e1039
# ╠═8e4e5560-3a8c-11eb-2612-577833ceee7e
# ╠═f3f072bc-3a8d-11eb-3b54-719f2924e9d2
# ╠═ed7ca23c-3a8f-11eb-34fe-dd7cf712377b
# ╠═5b37cd42-3a90-11eb-25a3-6105e801b231
# ╠═52110486-3a90-11eb-3a4f-11a08a8bd71f
# ╠═3180ae1c-3a93-11eb-01ab-13cc9be93b67
# ╠═2c64697a-3a96-11eb-34ea-ff7f4a67aa99
