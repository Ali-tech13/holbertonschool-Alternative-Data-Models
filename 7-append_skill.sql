-- Append Linux to Ali's skills; do not add it twice on reruns.
UPDATE profiles
SET document = json_insert(document, '$.skills[#]', 'Linux')
WHERE id = 1
  AND NOT EXISTS (
      SELECT 1
      FROM json_each(profiles.document, '$.skills') AS skill
      WHERE skill.value = 'Linux'
  );
