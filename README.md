🏥 Obesity Level Analysis — SQL Project
Project Overview
This project analyzes an obesity dataset collected from surveys conducted in Dhaka, Bangladesh. Using SQL, the goal is to uncover behavioral and genetic patterns that contribute to different obesity levels, drawing insights around diet, physical activity, screen time, and family history. The analysis is structured around four core health conclusions supported by query findings.

Dataset
Source: Kaggle — Obesity Levels Based on Eating Habits and Physical Condition
Records: 2,182
Columns: 17
Column	Data Type	Description
gender	VARCHAR	Gender of the individual
age	DECIMAL	Age of the individual
height	DECIMAL	Height in metres
weight	DECIMAL	Weight in kg
family_history_overweight	VARCHAR	Family history of overweight (Yes/No)
high_caloric_food	VARCHAR	High caloric food consumption (Yes/No)
vegetable_consumption	VARCHAR	Frequency of vegetable consumption
daily_main_meals	VARCHAR	Number of main meals per day
between_meal_consumption	VARCHAR	Between meal food consumption frequency
smoking	VARCHAR	Smoking status (Yes/No)
alcohol_intake	VARCHAR	Alcohol intake frequency
daily_water_intake	VARCHAR	Daily water intake frequency
monitor_calories	VARCHAR	Whether calories are monitored (Yes/No)
physical_exercise	VARCHAR	Physical exercise frequency
daily_device_usage	VARCHAR	Daily device usage duration
mode_of_transportation	VARCHAR	Mode of transportation used
obesity_level	VARCHAR	Obesity classification level
Tools Used
PostgreSQL — Database
pgAdmin 4 — Query interface
Business Questions & Queries
Dietary Habits
1. What is the distribution of high caloric food consumption across each obesity level?

SELECT obesity_level, COUNT(*) AS high_caloric_food_consumption
FROM obesity
WHERE high_caloric_food = 'Yes'
GROUP BY obesity_level
ORDER BY high_caloric_food_consumption DESC;
2. What percentage of people in Obesity Type II and III consume high caloric food?

SELECT obesity_level, 
    ROUND(COUNT(high_caloric_food) * 100.0 / 
        (SELECT COUNT(high_caloric_food) FROM obesity 
         WHERE obesity_level IN ('Obesity_Type_II', 'Obesity_Type_III') 
         AND high_caloric_food = 'Yes'), 2) AS people_consuming_high_caloric_food
FROM obesity
WHERE obesity_level IN ('Obesity_Type_II', 'Obesity_Type_III') AND high_caloric_food = 'Yes'
GROUP BY obesity_level
ORDER BY people_consuming_high_caloric_food DESC;
3. How does high caloric food consumption rate compare between normal weight and obese individuals?

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
Physical Inactivity
4. What is the most common physical exercise frequency for each obesity level?

SELECT obesity_level, physical_exercise, COUNT(physical_exercise) AS most_common_exercise_frequency
FROM obesity
GROUP BY obesity_level, physical_exercise
ORDER BY obesity_level, most_common_exercise_frequency DESC;
5. What percentage of people with Obesity Type II and III report no physical exercise?

SELECT obesity_level, 
    ROUND(COUNT(CASE WHEN physical_exercise = 'I do not have' THEN 1 END) * 100.0 / COUNT(*), 2) AS no_exercise_rate
FROM obesity
WHERE obesity_level IN ('Obesity_Type_II', 'Obesity_Type_III')
GROUP BY obesity_level
ORDER BY no_exercise_rate DESC;
6. How does exercise frequency differ between normal weight and obese individuals?

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
Sedentary Screen Time
7. What is the most common daily device usage duration per obesity level?

SELECT obesity_level, daily_device_usage, COUNT(*) AS usage_duration
FROM obesity
GROUP BY obesity_level, daily_device_usage
ORDER BY obesity_level, usage_duration DESC;
8. What percentage of obese individuals use devices for more than 5 hours daily?

SELECT obesity_level, 
    ROUND(COUNT(CASE WHEN daily_device_usage = 'More than 5 hours' THEN 1 END) * 100.0 / COUNT(*), 2) AS percentage_of_high_usage
FROM obesity
WHERE obesity_level IN ('Obesity_Type_I','Obesity_Type_II', 'Obesity_Type_III')
GROUP BY obesity_level
ORDER BY obesity_level;
9. How does device usage differ between normal weight and obese individuals?

SELECT 
    CASE
        WHEN obesity_level IN ('Obesity_Type_I','Obesity_Type_II', 'Obesity_Type_III') THEN 'Obese'
        WHEN obesity_level = 'Normal_Weight' THEN 'Normal_Weight'
    END AS weight_category,
    daily_device_usage, COUNT(daily_device_usage) AS amount_of_people
FROM obesity
WHERE obesity_level IN ('Obesity_Type_I','Obesity_Type_II', 'Obesity_Type_III', 'Normal_Weight')
GROUP BY weight_category, daily_device_usage
ORDER BY weight_category, amount_of_people DESC;
Genetics & Family History
10. What percentage of people with a family history of overweight fall into obese categories?

SELECT obesity_level, 
    ROUND(COUNT(CASE WHEN family_history_overweight = 'Yes' THEN 1 END) * 100.0 / COUNT(*), 2) AS overweight_history
FROM obesity
GROUP BY obesity_level
ORDER BY overweight_history DESC;
11. How does family history of overweight distribute across each obesity level?

SELECT obesity_level, family_history_overweight, COUNT(*) AS amount_of_people
FROM obesity
GROUP BY obesity_level, family_history_overweight
ORDER BY obesity_level, amount_of_people DESC;
12. What percentage of normal weight individuals have no family history of overweight?

SELECT obesity_level, 
    ROUND(COUNT(CASE WHEN family_history_overweight = 'No' THEN 1 END) * 100.0 / COUNT(*), 2) AS unaffected_individuals
FROM obesity
WHERE obesity_level = 'Normal_Weight'
GROUP BY obesity_level;
Key Findings
1. Dietary Habits
Unhealthy eating patterns show a strong association with higher obesity levels. Among obese individuals, 77.79% reported consuming high caloric food regularly, compared to only 46.98% among those with normal weight — a difference of nearly 31 percentage points. Within the two most severe obesity categories, Obesity Type III accounted for 56.37% of high caloric food consumers while Obesity Type II accounted for 43.63%.

2. Physical Inactivity
Physical inactivity is overwhelmingly prevalent among individuals with higher obesity levels. Among those classified as Obesity Type III, 98.80% reported having no regular physical exercise, with Obesity Type II close behind at 96.11%. In contrast, normal weight individuals showed a more varied exercise distribution, with a notable portion exercising 1 to 2 days per week or more — suggesting that physical activity plays a meaningful role in maintaining a healthy weight.

3. Sedentary Screen Time
Prolonged device usage is common across all weight categories in this dataset, though it remains more concentrated among obese individuals. Among the three obese categories, Obesity Type II had the highest proportion of heavy screen time users at 63.25%, followed by Obesity Type I at 57.41%, while Obesity Type III was comparatively lower at 44.22%. Notably, even normal weight individuals showed high device usage, suggesting that screen time alone may not be the sole driver of obesity in this population.

4. Genetics & Family History
Family history of overweight shows a clear gradient across obesity levels. Obesity Type II had the highest rate of family history at 69.26%, followed by Obesity Type III at 53.39% and Obesity Type I at 47.95%. In contrast, only 31.51% of normal weight individuals reported a family history of overweight, and a mere 3.70% of those with insufficient weight did so. This pattern suggests that genetic predisposition is a meaningful contributor to obesity risk, working alongside behavioral factors.

Skills Demonstrated
COUNT(), SUM(), AVG(), ROUND() aggregate functions
COUNT(CASE WHEN...) for conditional counting within groups
CASE statements for custom grouping and segmentation
WHERE and IN for targeted filtering
Subqueries for percentage calculations
Multi-column GROUP BY and ORDER BY
Comparative analysis between population segments
How to Run
Install PostgreSQL and pgAdmin 4
Create a new database in pgAdmin
Run the CREATE TABLE statement below
Import obesity.csv via pgAdmin's Import/Export tool (ensure Header is toggled ON)
Open and run queries from obesity_analysis.sql
CREATE TABLE obesity (
    gender VARCHAR(10),
    age DECIMAL(5,2),
    height DECIMAL(4,2),
    weight DECIMAL(5,2),
    family_history_overweight VARCHAR(10),
    high_caloric_food VARCHAR(10),
    vegetable_consumption VARCHAR(20),
    daily_main_meals VARCHAR(20),
    between_meal_consumption VARCHAR(20),
    smoking VARCHAR(10),
    alcohol_intake VARCHAR(20),
    daily_water_intake VARCHAR(20),
    monitor_calories VARCHAR(10),
    physical_exercise VARCHAR(20),
    daily_device_usage VARCHAR(20),
    mode_of_transportation VARCHAR(30),
    obesity_level VARCHAR(50)
);
About Me
I am currently transitioning into a data analytics career and building this portfolio to demonstrate my SQL skills. This is one of several projects I am working on as part of my self-learning journey.
