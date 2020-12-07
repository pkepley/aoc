### A Pluto.jl notebook ###
# v0.12.16

using Markdown
using InteractiveUtils

# ╔═╡ c8869644-3838-11eb-1d47-09e1165dab6c
#=
🎅 Solutions for Day 2! 🎅

🌟 Part 1: Count valid database entries matching policy1!
🌟 Part 2: Count valid database entries matching policy2!

=#

# ╔═╡ 9ad6e29c-383a-11eb-387d-1f30904f3cff
example_string = """
1-3 a: abcde
1-3 b: cdefg
2-9 c: ccccccccc
"""

# ╔═╡ 89a97bbc-383d-11eb-233d-e3d18ec258d4
function parse_line(s) 
	s = replace(s, "-" => " ")
	s = replace(s, ":" => "")
	s = convert(Array{Any, 1}, split(s))
	s[1] = parse(Int64, s[1])
	s[2] = parse(Int64, s[2])
	s[3] = s[3][1] # extract the char from the 1-char string
	return s
end

# ╔═╡ 1c382a7a-3846-11eb-3f22-670efaad3f38
function parse_input(s)
	s2 = split(s, "\n", keepempty=false)
	return map(parse_line, s2)
end

# ╔═╡ 6699addc-3846-11eb-1fa4-ad20819a0ac3
example_databse_entries = parse_input(example_string)

# ╔═╡ 4bd39274-383c-11eb-0e2d-ad35841735cd
begin
	input_path = "../input/input_day_02.txt"        
    prob2_input_str = open(input_path) do file
		read(file, String)
	end     
    prob2_database_entries = parse_input(prob2_input_str)
end

# ╔═╡ 489d13b2-3848-11eb-2af2-fd063d4c635a
function count_occurences(s)
	occurences = Dict()
	
	for e ∈ s
		if haskey(occurences, e)
			occurences[e] += 1
		else
			occurences[e] = 1
		end
	end
	
	return occurences
end

# ╔═╡ a3ba5e2c-3849-11eb-1eec-3b72cbbf0711
function entry_satisfies_policy1(db_entry)
	min_rep = db_entry[1]
	max_rep = db_entry[2]
	rep_char = db_entry[3]
	passwd = db_entry[4]
	
	# fails policy if repeated char is not present
	if rep_char ∉ passwd
		return false
		
	# policy requires rep_char repeated ≥ min_rep, and ≤ max_rep times
	else
		occurences = count_occurences(passwd)
		return (occurences[rep_char] >= min_rep) & (occurences[rep_char] <= max_rep)
	end
	
end

# ╔═╡ b00b3a76-384b-11eb-23fa-b302ad8f1884
function entry_satisfies_policy2(db_entry)
	pos1 = db_entry[1]
	pos2 = db_entry[2]
	incl_char = db_entry[3]
	passwd = db_entry[4]
	
	# fails policy if include char is not present, or if passwd too short
	if (incl_char ∉ passwd) | (max(pos1, pos2) > length(passwd))
		return false
		
	# policy requires incl_char present in exactly one of the two positions
	else
		return (((passwd[pos1] == incl_char) | (passwd[pos2] == incl_char)) & 
			    ~(passwd[pos1] == passwd[pos2]))
	end
	
end

# ╔═╡ c106f104-384a-11eb-3a9f-23be6fddc1e8
function check_passwords(db_entries, policy)
	return map(policy, db_entries)
end

# ╔═╡ fbe224b0-384a-11eb-1fb2-63124ed36ff9
function solve_part_1(db_entries)
	return sum(check_passwords(db_entries, entry_satisfies_policy1))
end

# ╔═╡ e300eec4-384b-11eb-2273-ab54453baeb3
function solve_part_2(db_entries)
	return sum(check_passwords(db_entries, entry_satisfies_policy2))
end

# ╔═╡ 1dc0f59a-3849-11eb-067a-b146244a737d
# check examples
begin 
	@assert solve_part_1(example_databse_entries) == 2
	@assert solve_part_2(example_databse_entries) == 1
end

# ╔═╡ 4cb2cda2-384b-11eb-2acb-0d5927983c1f
part_1_soln = solve_part_1(prob2_database_entries)

# ╔═╡ 68c59028-384b-11eb-3745-47fe0570ec04
println("Day 2. Part 1: ", part_1_soln)

# ╔═╡ ebfb6b7c-384c-11eb-336e-2f5ad93e91f4
part_2_soln = solve_part_2(prob2_database_entries)

# ╔═╡ ed0bcd66-384c-11eb-0bd8-07a331842108
println("Day 2. Part 2: ", part_2_soln)

# ╔═╡ Cell order:
# ╠═c8869644-3838-11eb-1d47-09e1165dab6c
# ╠═9ad6e29c-383a-11eb-387d-1f30904f3cff
# ╠═6699addc-3846-11eb-1fa4-ad20819a0ac3
# ╠═4bd39274-383c-11eb-0e2d-ad35841735cd
# ╠═89a97bbc-383d-11eb-233d-e3d18ec258d4
# ╠═1c382a7a-3846-11eb-3f22-670efaad3f38
# ╠═489d13b2-3848-11eb-2af2-fd063d4c635a
# ╠═a3ba5e2c-3849-11eb-1eec-3b72cbbf0711
# ╠═b00b3a76-384b-11eb-23fa-b302ad8f1884
# ╠═c106f104-384a-11eb-3a9f-23be6fddc1e8
# ╠═fbe224b0-384a-11eb-1fb2-63124ed36ff9
# ╠═e300eec4-384b-11eb-2273-ab54453baeb3
# ╠═1dc0f59a-3849-11eb-067a-b146244a737d
# ╠═4cb2cda2-384b-11eb-2acb-0d5927983c1f
# ╠═68c59028-384b-11eb-3745-47fe0570ec04
# ╠═ebfb6b7c-384c-11eb-336e-2f5ad93e91f4
# ╠═ed0bcd66-384c-11eb-0bd8-07a331842108
