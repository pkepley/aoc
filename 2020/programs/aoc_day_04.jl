### A Pluto.jl notebook ###
# v0.12.16

using Markdown
using InteractiveUtils

# ╔═╡ 8dc51bee-38be-11eb-072a-edc19696c934
#=
🦌 Solutions for Day 4! 🦌
🌟 Part 1: Check if some passports have required fields! 🛂
🌟 Part 2: Check if some passports have valid fields! 🛂
=#

# ╔═╡ 11ac881c-38be-11eb-2e0a-251f5938eacd
function parse_input(s)
	inpt_list = split(s, "\n\n", keepempty=false)
	inpt_list = map(x -> replace(x, "\n" => " "), inpt_list)
	
	return inpt_list
end

# ╔═╡ 97f3b1fc-390c-11eb-09c7-1d77b67955c3
# required keys for part 1
const req_keys = ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"]

# ╔═╡ 19da5d70-3902-11eb-3509-133b0e1f05b9
# naive validator for part 1
function has_required_keys(passport_str)	
	passport_fields = split(passport_str, ' ', keepempty=false)
	passport_fields = [split(s, ':') for s ∈ passport_fields]
	passport_fields = Dict(passport_fields)
	
	# early exit if key is missing
	for k in req_keys
		if !haskey(passport_fields, k)
			return nothing
		end
	end
	
	return passport_fields
end


# ╔═╡ 333866e6-38bd-11eb-0ee2-db1dd7b727bb
function passport_is_valid(passport_str)	
	# build a regex to parse the passport in a few steps
	passport_regex = r"(\bpid:[0-9]{9}\b)|(byr:(19[2-9][0-9]|200[0-2]))|(iyr:(201[0-9]|2020))|(eyr:(202[0-9]|2030))|(hgt:(((59|6[0-9]|7[0-6])in)|((1[5-8][0-9]|19[0-3])cm)))|(hcl:#[0-9a-f]{6})|(ecl:((amb)|(blu)|(brn)|(gry)|(grn)|(hzl)|(oth)))|(cid:[0-9]{3})"
	
	# perform multiple regex matches: https://stackoverflow.com/a/59141958/3677367
	passport_fields = SubString.(passport_str, findall(passport_regex, passport_str))
	passport_fields = [split(s, ':') for s ∈ passport_fields]
	passport_fields = sort(passport_fields)
	passport_fields = Dict(passport_fields)
		
	# check if required keys are present
	for k ∈ req_keys
		if ~haskey(passport_fields, k)
			return nothing
		end
	end
	
	return passport_fields
end

# ╔═╡ 1d0a14ac-38f7-11eb-22fe-d35b8868577f
function validate_passport_list(passport_list, validator)
	return map(validator, passport_list)
end

# ╔═╡ 5344fdb6-38f7-11eb-34f4-19e41763dd0e
function solve_prob_1(passport_list)
	valid_passports = validate_passport_list(passport_list, has_required_keys)
	
	return length([v for v ∈ valid_passports if v != nothing])
end

# ╔═╡ 0e47f8b4-390e-11eb-148a-9fa17ae03931
function solve_prob_2(passport_list)
	valid_passports = validate_passport_list(passport_list, passport_is_valid)
	
	return length([v for v ∈ valid_passports if v != nothing])
end

# ╔═╡ 8ef8551a-38be-11eb-0668-538747b31ad5
begin
	input_path = "../input/input_day_04.txt"	
	
	s_input = open(input_path) do file
		read(file, String)
	end	

	problem_passport_entries = parse_input(s_input)
end

# ╔═╡ e3eed336-38f8-11eb-1e45-954b40ef7b95
part_1_soln = solve_prob_1(problem_passport_entries)

# ╔═╡ eaaf213a-38f8-11eb-3cff-d7df6c8c7232
println("Day 4: Part 1: ", part_1_soln)

# ╔═╡ 4db69c12-390e-11eb-1c7f-27aa01697470
part_2_soln = solve_prob_2(problem_passport_entries)

# ╔═╡ 4e646c98-390e-11eb-1644-ddee69a9abaa
println("Day 4: Part 2: ", part_2_soln)

# ╔═╡ 6df8f5a8-3920-11eb-32d4-d35a6434cc5b
######################## Examples & Tests Below Here! ###########################

# ╔═╡ 2bd25566-38bc-11eb-2175-2bc884b5d000
begin 
	example_str = """
ecl:gry pid:860033327 eyr:2020 hcl:#fffffd
byr:1937 iyr:2017 cid:147 hgt:183cm

iyr:2013 ecl:amb cid:350 eyr:2023 pid:028048884
hcl:#cfa07d byr:1929

hcl:#ae17e1 iyr:2013
eyr:2024
ecl:brn pid:760753108 byr:1931
hgt:179cm

hcl:#cfa07d eyr:2025 pid:166559648
iyr:2011 ecl:brn hgt:59in
"""
	example_passport_entries = parse_input(example_str)
end

# ╔═╡ 39ffd54e-3907-11eb-094a-97420147673f
begin
	## invalid examples
	example_invalid_str = """
eyr:1972 cid:100
hcl:#18171d ecl:amb hgt:170 pid:186cm iyr:2018 byr:1926

iyr:2019
hcl:#602927 eyr:1967 hgt:170cm
ecl:grn pid:012533040 byr:1946

hcl:dab227 iyr:2012
ecl:brn hgt:182cm pid:021572410 eyr:2020 byr:1992 cid:277

hgt:59cm ecl:zzz
eyr:2038 hcl:74454a iyr:2023
pid:3556412378 byr:2007"""
	example_invalid_entries = parse_input(example_invalid_str)
	
	## valid examples
	example_valid_str = """
pid:087499704 hgt:74in ecl:grn iyr:2012 eyr:2030 byr:1980
hcl:#623a2f

eyr:2029 ecl:blu cid:129 byr:1989
iyr:2014 pid:896056539 hcl:#a97842 hgt:165cm

hcl:#888785
hgt:164cm byr:2001 iyr:2015 cid:88
pid:545766238 ecl:hzl
eyr:2022

iyr:2010 hgt:158cm hcl:#b6652a ecl:blu byr:1944 eyr:2021 pid:093154719"""
	example_valid_entries = parse_input(example_valid_str)
end

# ╔═╡ fd9c0418-38e7-11eb-3403-bf7201c52562
begin 
	@assert solve_prob_1(example_passport_entries) == 2
	@assert solve_prob_2(example_valid_entries) == 4
	@assert solve_prob_2(example_invalid_entries) == 0	
end

# ╔═╡ Cell order:
# ╠═8dc51bee-38be-11eb-072a-edc19696c934
# ╠═11ac881c-38be-11eb-2e0a-251f5938eacd
# ╠═97f3b1fc-390c-11eb-09c7-1d77b67955c3
# ╠═19da5d70-3902-11eb-3509-133b0e1f05b9
# ╠═333866e6-38bd-11eb-0ee2-db1dd7b727bb
# ╠═1d0a14ac-38f7-11eb-22fe-d35b8868577f
# ╠═5344fdb6-38f7-11eb-34f4-19e41763dd0e
# ╠═0e47f8b4-390e-11eb-148a-9fa17ae03931
# ╠═8ef8551a-38be-11eb-0668-538747b31ad5
# ╠═e3eed336-38f8-11eb-1e45-954b40ef7b95
# ╠═eaaf213a-38f8-11eb-3cff-d7df6c8c7232
# ╠═4db69c12-390e-11eb-1c7f-27aa01697470
# ╠═4e646c98-390e-11eb-1644-ddee69a9abaa
# ╠═6df8f5a8-3920-11eb-32d4-d35a6434cc5b
# ╠═2bd25566-38bc-11eb-2175-2bc884b5d000
# ╠═39ffd54e-3907-11eb-094a-97420147673f
# ╠═fd9c0418-38e7-11eb-3403-bf7201c52562
