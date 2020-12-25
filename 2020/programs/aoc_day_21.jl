### A Pluto.jl notebook ###
# v0.12.17

using Markdown
using InteractiveUtils

# ╔═╡ 0b6188b0-3a8b-11eb-112c-77145e1d99b5
#= 
🎅 Solutions for Day 21! 🎅

🌟 Part 1: Count the non-allergenic ingredients with repetition! 🥛🐟🥜
🌟 Part 2: Get the list of allergenic ingredients! 🥛🐟🥜

=#

# ╔═╡ b0bbb420-3d62-11eb-050a-99a665672dba
DAY_NUMBER = 21 

# ╔═╡ 81e88cb0-3a8b-11eb-3aba-a3509bff5912
function parse_input(s)
    rows = split(s, "\n", keepempty=false)	
    
    # parse the ingredients
    ingredient_lists = map(r -> split(r, "(", keepempty=false)[1], rows)
    ingredient_lists = map(r -> Set(split(r, " ", keepempty=false)), ingredient_lists)
    
    # parse the allergens
    allergen_lists = map(r -> split(r, "(", keepempty=false)[2], rows)
    allergen_lists = map(r -> replace(r, "contains " => ""), allergen_lists)
    allergen_lists = map(r -> replace(r, ")" => ""), allergen_lists)
    allergen_lists = map(r -> Set(split(r, ", ", keepempty=false)), allergen_lists)	
    
    return ingredient_lists, allergen_lists
end

# ╔═╡ 15db1808-454e-11eb-1378-4d323d57f2e0
function determine_allergen_ingredients(ingredient_lists, allergen_lists)	
    """
	Determine which ingredients have allergens, and return the mapping 
	from ingredients to allergens.
	"""
    
    # union all of the sets of allergens
    unique_allergens = foldl(union, allergen_lists)
    
    # determine ingredient candidates
    ingredient_cands = Dict()	
    for allergen ∈ unique_allergens
	idx_allergen = findall(e -> (allergen ∈ e), allergen_lists)	
	
	ingredient_cands[allergen] = 
	    foldl(intersect, deepcopy(ingredient_lists[idx_allergen]))
    end
    
    # mapping from allergenic-ingredients to allergens
    ingredient_to_allergen = Dict()
    
    while length(ingredient_cands) > 0
	for allergen ∈ keys(ingredient_cands)
	    if length(ingredient_cands[allergen]) == 1				
		# allergen only has one candidate ingredient, so is uniquely
		# determined. add ingredient --> allergen pair to mapping.
		ingredient = pop!(ingredient_cands[allergen])
		ingredient_to_allergen[ingredient] = allergen
		
		# remove allergen from the list of undetermined allergens
		delete!(ingredient_cands, allergen)
		
		# delete ingredient from the candidates for all other allergens
		for allergen2 ∈ keys(ingredient_cands) 
		    delete!(ingredient_cands[allergen2], ingredient)
		end
	    end
	end		
    end
    
    return ingredient_to_allergen
end

# ╔═╡ f1109a84-3a8f-11eb-3ca8-2fdbdd1cc29a
function solve_prob_1(inpt)
    (ingredient_lists, allergen_lists) = parse_input(inpt)	
    ingredient_to_allergen = determine_allergen_ingredients(ingredient_lists, 
				                            allergen_lists)	
    
    # list the allergenic ingredients
    allergenic_ingredients = [k for k ∈ keys(ingredient_to_allergen)]
    
    # count the non-allergenic ingredients in the list
    cnt_nonallergenic = 0
    for ingredients ∈ ingredient_lists
	cnt_nonallergenic += length([i for i ∈ ingredients if i ∉ allergenic_ingredients])
    end
    
    return cnt_nonallergenic
end

# ╔═╡ 129f488c-3a93-11eb-260e-8921353e1039
function solve_prob_2(inpt)
    (ingredient_lists, allergen_lists) = parse_input(inpt)	
    ingredient_to_allergen = determine_allergen_ingredients(ingredient_lists, 
				                            allergen_lists)	
    
    # sort the allergenic ingredients by their corresponding allergen
    # ie sort the dict by the values, using this method:
    #     https://stackoverflow.com/a/29904797/3677367
    allergenic_ingredients = [k[1] for k ∈ sort(collect(ingredient_to_allergen),
				                by=x->x[2])]

    # return canonical dangerous ingredient list
    return join(allergenic_ingredients, ",")
end

# ╔═╡ 8e4e5560-3a8c-11eb-2612-577833ceee7e
############################ Examples+Tests ################################
begin 
    example_input="""
mxmxvkd kfcds sqjhc nhms (contains dairy, fish)
trh fvjkl sbzzf mxmxvkd (contains dairy)
sqjhc fvjkl (contains soy)
sqjhc mxmxvkd sbzzf (contains fish)
"""    
end

# ╔═╡ f3f072bc-3a8d-11eb-3b54-719f2924e9d2
begin
    @assert solve_prob_1(example_input) == 5
    @assert solve_prob_2(example_input) == "mxmxvkd,sqjhc,fvjkl"
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
# ╠═15db1808-454e-11eb-1378-4d323d57f2e0
# ╠═f1109a84-3a8f-11eb-3ca8-2fdbdd1cc29a
# ╠═129f488c-3a93-11eb-260e-8921353e1039
# ╠═8e4e5560-3a8c-11eb-2612-577833ceee7e
# ╠═f3f072bc-3a8d-11eb-3b54-719f2924e9d2
# ╠═ed7ca23c-3a8f-11eb-34fe-dd7cf712377b
# ╠═5b37cd42-3a90-11eb-25a3-6105e801b231
# ╠═52110486-3a90-11eb-3a4f-11a08a8bd71f
# ╠═3180ae1c-3a93-11eb-01ab-13cc9be93b67
# ╠═2c64697a-3a96-11eb-34ea-ff7f4a67aa99
