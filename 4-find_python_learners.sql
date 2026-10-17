-- EXISTS prevents duplicate profiles if a skill occurs more than once.
SELECT p.id,
       json_extract(p.document, '$.name') AS learner_name
FROM profiles AS p
WHERE EXISTS (
    SELECT 1
    FROM json_each(p.document, '$.skills') AS skill
    WHERE skill.value = 'Python'
)
ORDER BY learner_name ASC, p.id ASC;
