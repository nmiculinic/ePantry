-- display food diary

SELECT food_diary.time,
       food_recipes.name,
       items.name,
       food_recipe_item.amount_kilogram,
       food_diary.notes
FROM food_diary,
     food_recipes,
     food_recipe_item,
     items
WHERE food_diary.recipe_id = food_recipes.id
  AND food_recipes.id = food_recipe_item.recipe_id
  AND items.id = food_recipe_item.item_id
ORDER BY food_diary.time