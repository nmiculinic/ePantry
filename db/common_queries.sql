-- display abbrev food diary

SELECT food_diary.time,
       food_recipes.id,
       food_recipes.name,
       food_recipes.meal_type,
       food_diary.notes
FROM food_diary,
     food_recipes
WHERE food_diary.recipe_id = food_recipes.id
  AND food_diary.time > '2020-03-06 9:00'
  AND food_diary.time < '2020-03-09'
ORDER BY food_diary.time

-- display food diary with details

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
  AND food_diary.time < '2020-03-04'
ORDER BY food_diary.time


-- meal prep meals

SELECT food_recipes.id, food_recipes.name, food_recipes.meal_type, amounts.amount
FROM (
         SELECT food_diary.recipe_id, COUNT(*) as "amount"
         FROM food_diary
         WHERE food_diary.time > '2020-03-06 9:00'
           AND food_diary.time < '2020-03-09'
         GROUP BY food_diary.recipe_id
     ) AS amounts,
     food_recipes
WHERE food_recipes.id = amounts.recipe_id
ORDER BY meal_type

-- shopping list


SELECT
    -- food_recipes.id,
    -- items.id,
    items.name,
    -- food_recipe_item.amount_kilogram
    SUM(food_recipe_item.amount_kilogram) * 1000.0 AS "g",
    COUNT(*)                                       AS "times repeated"
FROM food_diary,
     food_recipes,
     food_recipe_item,
     items
WHERE food_diary.recipe_id = food_recipes.id
  AND food_recipes.id = food_recipe_item.recipe_id
  AND items.id = food_recipe_item.item_id
  AND food_diary.time > '2020-03-06'
  AND food_diary.time < '2020-03-10'
GROUP BY items.id
ORDER BY items.name
