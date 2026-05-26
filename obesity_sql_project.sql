SELECT * FROM obesity

--Dietary Habits--

--What is the distribution of high caloric food consumption across each obesity level?
SELECT obesity_level, COUNT(high_caloric_food) AS high_caloric_food_consumption
FROM obesity
WHERE high_caloric_food = 'Yes'
GROUP BY obesity_level
ORDER BY high_caloric_food_consumption DESC;

--What percentage of people in Obesity Type II and III consume high caloric food?
SELECT obesity_level, ROUND(COUNT(high_caloric_food) * 100.0 / (SELECT COUNT(high_caloric_food) FROM obesity 
WHERE obesity_level IN ('Obesity_Type_II', 'Obesity_Type_III') AND high_caloric_food = 'Yes'), 2) AS people_consuming_high_caloric_food
FROM obesity
WHERE obesity_level IN ('Obesity_Type_II', 'Obesity_Type_III') AND high_caloric_food = 'Yes'
GROUP BY obesity_level
ORDER BY people_consuming_high_caloric_food DESC;

--How does high caloric food consumption rate compare between normal weight and obese individuals?
SELECT 
	CASE
    WHEN obesity_level IN ('Obesity_Type_I', 'Obesity_Type_II', 'Obesity_Type_III') THEN 'Obese'
    WHEN obesity_level = 'Normal_Weight' THEN 'Normal Weight'
END AS weight_category,
ROUND(COUNT(CASE WHEN high_caloric_food = 'Yes' THEN 1 END) * 100.0 / COUNT(*), 2) AS high_caloric_rate
FROM obesity
WHERE obesity_level IN ('Obesity_Type_I', 'Obesity_Type_II', 'Obesity_Type_III', 'Normal_Weight')
GROUP BY weight_category
ORDER BY high_caloric_rate DESC;

--Physical Inactivity--

--What is the most common physical exercise frequency for each obesity level?
SELECT obesity_level, physical_exercise, COUNT(physical_exercise) AS most_common_exercise_frequency
FROM obesity
GROUP BY obesity_level, physical_exercise
ORDER BY obesity_level, most_common_exercise_frequency DESC;

--What percentage of people with Obesity Type II and III report no physical exercise?
SELECT obesity_level, ROUND(COUNT(CASE WHEN physical_exercise = 'I do not have' THEN 1 END) * 100.0 / COUNT(*), 2) AS no_exercise_rate
FROM obesity
WHERE obesity_level IN ('Obesity_Type_II', 'Obesity_Type_III')
GROUP BY obesity_level
ORDER BY no_exercise_rate DESC;

--How does exercise frequency differ between normal weight and obese individuals?
SELECT
	CASE
		WHEN obesity_level IN ('Obesity_Type_I','Obesity_Type_II', 'Obesity_Type_III') THEN 'Obese'
		WHEN obesity_level = 'Normal_Weight' THEN 'Normal_Weight'
		END AS weight_category,
		physical_exercise, COUNT(physical_exercise) AS amount_of_people
FROM obesity
WHERE obesity_level IN ('Obesity_Type_I', 'Obesity_Type_II', 'Obesity_Type_III', 'Normal_Weight')
GROUP BY weight_category, physical_exercise
ORDER BY weight_category, amount_of_people DESC;

--Sedentary Screen Time--

--What is the most common daily device usage duration per obesity level?
SELECT obesity_level, daily_device_usage, COUNT(*) AS usage_duration
FROM obesity
GROUP BY obesity_level, daily_device_usage
ORDER BY obesity_level, usage_duration DESC;

--What percentage of obese individuals use devices for more than 5 hours daily?
SELECT obesity_level, ROUND(COUNT(CASE WHEN daily_device_usage = 'More than 5 hours' THEN 1 END) * 100.0 / COUNT(*), 2) AS percentage_of_high_usage
FROM obesity		
WHERE obesity_level in ('Obesity_Type_I','Obesity_Type_II', 'Obesity_Type_III')
GROUP BY obesity_level
ORDER BY obesity_level;

--How does device usage differ between normal weight and obese categories?
SELECT 
	CASE
		WHEN obesity_level in ('Obesity_Type_I','Obesity_Type_II', 'Obesity_Type_III') THEN 'obese'
		WHEN obesity_level = 'Normal_Weight' THEN 'Normal_Weight'
	END AS weight_category,
	daily_device_usage, COUNT(daily_device_usage) AS amount_of_people
FROM obesity
WHERE obesity_level IN ('Obesity_Type_I','Obesity_Type_II', 'Obesity_Type_III', 'Normal_Weight')
GROUP BY weight_category, daily_device_usage
ORDER BY weight_category, amount_of_people DESC;
	
--Genetics & Family History--

--What percentage of people with a family history of overweight fall into obese categories?
SELECT obesity_level, ROUND(COUNT(CASE WHEN family_history_overweight = 'Yes' THEN 1 END) * 100.0 / COUNT(*), 2) AS overweight_history
FROM obesity
GROUP BY obesity_level
ORDER BY overweight_history DESC;

--How does family history of overweight distribute across each obesity level?
SELECT obesity_level, family_history_overweight, COUNT(*) AS amount_of_people
FROM obesity
GROUP BY obesity_level, family_history_overweight
ORDER BY obesity_level, amount_of_people DESC;

--What percentage of normal weight individuals have no family history of overweight?
SELECT obesity_level, ROUND(COUNT(CASE WHEN family_history_overweight = 'No' THEN 1 END) * 100.0 / COUNT(*), 2) AS unaffected_individuals
FROM obesity
WHERE obesity_level = 'Normal_Weight'
GROUP BY obesity_level