-- Each result row represents one completed security project.
SELECT p.id AS learner_id,
       json_extract(p.document, '$.name') AS learner_name,
       json_extract(project.value, '$.title') AS project_title
FROM profiles AS p
CROSS JOIN json_each(p.document, '$.projects') AS project
WHERE json_extract(project.value, '$.category') = 'security'
  AND json_extract(project.value, '$.completed') = 1
ORDER BY learner_name ASC, project_title ASC,
         learner_id ASC, project.key ASC;
