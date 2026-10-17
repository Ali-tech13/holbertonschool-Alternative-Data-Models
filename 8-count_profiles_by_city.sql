-- Count all stored profiles, including inactive profiles.
SELECT json_extract(document, '$.address.city') AS city,
       COUNT(*) AS profile_count
FROM profiles
GROUP BY json_extract(document, '$.address.city')
ORDER BY profile_count DESC, city ASC;
