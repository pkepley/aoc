### A Pluto.jl notebook ###
# v0.12.16

using Markdown
using InteractiveUtils

# ╔═╡ 63d0cdae-3965-11eb-1f1c-9b0f21559552
#=
☃️ Solutions for Day 5! ☃️

🌟 Part 1: Compute seat ids!
🌟 Part 2: Find your seat id!
=#

# ╔═╡ 8243cbd0-3965-11eb-3aca-c559e1698bc3
function parse_input(s)
	inpt_list = split(s, "\n", keepempty=false)
	inpt_list = map(x -> replace(x, "\n" => " "), inpt_list)
	
	return inpt_list
end

# ╔═╡ 3d6ba02e-3967-11eb-1dc2-91ca8e8bb41a
begin
	input_path = "../input/input_day_05.txt"	
	
	s_input = open(input_path) do file
		read(file, String)
	end	

	problem_bsp_entries = parse_input(s_input)
end

# ╔═╡ 8ef17b1e-3965-11eb-1f9f-271fe529505c
function parse_bsp(bsp_string, row_bits = 7, seat_bits = 3)
	bsp_string = replace(bsp_string, 'F'=>'0')
	bsp_string = replace(bsp_string, 'B'=>'1')
	bsp_string = replace(bsp_string, 'L'=>'0')
	bsp_string = replace(bsp_string, 'R'=>'1')
	
	row = parse(Int, bsp_string[1:row_bits], base = 2)
	seat = parse(Int, bsp_string[(row_bits+1):end], base = 2)
	seatid = row * (row_bits + 1) + seat
	
	return row, seat, seatid
end

# ╔═╡ 1a398fd6-3966-11eb-26b1-0972009f310e
begin 
	@assert parse_bsp("BFFFBBFRRR") == (70, 7, 567)
	@assert parse_bsp("FFFBBBFRRR") == (14, 7, 119)
	@assert parse_bsp("BBFFBBFRLL") == (102, 4, 820)
end

# ╔═╡ 02081698-3967-11eb-0a75-0394b54dc27e
function solve_problem_1(bsp_list)
	seat_info_list = map(parse_bsp, bsp_list)
	return maximum([x[3] for x in seat_info_list])
	
end

# ╔═╡ e3805b74-396e-11eb-3eeb-4388c6c92d12
function solve_problem_2(bsp_list)
	seat_info_list = map(parse_bsp, bsp_list)
	seat_id_list = sort([x[3] for x in seat_info_list])
	
	for k in 1:length(seat_id_list)
		if seat_id_list[k+1] != seat_id_list[k] + 1
			return seat_id_list[k] + 1
		end
	end
	
	return nothing
end

# ╔═╡ 303b5f02-3967-11eb-29bd-7b4ec024f59e
part_1_soln = solve_problem_1(problem_bsp_entries)

# ╔═╡ e9992074-396e-11eb-2269-d9cb1c8926e9
println("Day 5: Part 1: ", part_1_soln)

# ╔═╡ f610bc2a-396e-11eb-097c-67c50d6f27d6
part_2_soln = solve_problem_2(problem_bsp_entries)

# ╔═╡ 5cd1a7fa-396f-11eb-0be2-c1a1f17e4e87
println("Day 5: Part 2: ", part_2_soln)

# ╔═╡ Cell order:
# ╠═63d0cdae-3965-11eb-1f1c-9b0f21559552
# ╠═8243cbd0-3965-11eb-3aca-c559e1698bc3
# ╠═3d6ba02e-3967-11eb-1dc2-91ca8e8bb41a
# ╠═8ef17b1e-3965-11eb-1f9f-271fe529505c
# ╠═1a398fd6-3966-11eb-26b1-0972009f310e
# ╠═02081698-3967-11eb-0a75-0394b54dc27e
# ╠═e3805b74-396e-11eb-3eeb-4388c6c92d12
# ╠═303b5f02-3967-11eb-29bd-7b4ec024f59e
# ╠═e9992074-396e-11eb-2269-d9cb1c8926e9
# ╠═f610bc2a-396e-11eb-097c-67c50d6f27d6
# ╠═5cd1a7fa-396f-11eb-0be2-c1a1f17e4e87
