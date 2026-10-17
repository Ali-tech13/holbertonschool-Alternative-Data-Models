-- Follow the nested address.city path.
SELECT id,
       json_extract(document, '$.name') AS learner_name,
       json_extract(document, '$.address.city') AS city
FROM profiles
WHERE json_extract(document, '$.address.city') = 'Riyadh'
ORDER BY learner_name ASC, id ASC;
