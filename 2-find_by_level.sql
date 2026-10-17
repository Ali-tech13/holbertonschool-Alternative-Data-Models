-- Retrieve a top-level JSON field and filter by level.
SELECT id,
       json_extract(document, '$.name') AS learner_name,
       json_extract(document, '$.level') AS level
FROM profiles
WHERE json_extract(document, '$.level') = 'intermediate'
ORDER BY learner_name ASC, id ASC;
