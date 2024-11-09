-- data-final-fixes.lua

for _, recipe in pairs(data.raw.recipe) do
  -- Check if recipe is a smelting recipe with exactly one ingredient
  if	recipe.category == "smelting" 
	and #recipe.ingredients == 1
	and recipe.ingredients[1].amount
	and recipe.ingredients[1].amount > 1
	then
      local factor = recipe.ingredients[1].amount

      recipe.ingredients[1].amount = 1

      if recipe.energy_required then
        recipe.energy_required = recipe.energy_required / factor
      end

      -- Modify result to maintain ratio by adjusting probability
      for _, result in ipairs(recipe.results or {}) do
        -- Check if result has amount and reduce it by the factor while setting probability
        if result.amount and result.amount >= 1 then
          result.probability = (result.amount / factor)
          result.amount = 1
        end
      end

      -- Handle cases where the recipe uses `result` instead of `results`
      if recipe.result and recipe.result_count and recipe.result_count > 1 then
        recipe.result_count = 1
        recipe.result_probability = 1 / factor
      end
  end
end
