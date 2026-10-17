-- Promote Sara while keeping her other JSON fields.
UPDATE profiles
SET document = json_set(document, '$.level', 'intermediate')
WHERE id = 2;
