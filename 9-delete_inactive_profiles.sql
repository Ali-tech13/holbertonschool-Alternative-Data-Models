-- JSON false is returned as SQL integer 0 by json_extract.
DELETE FROM profiles
WHERE json_extract(document, '$.active') = 0;
