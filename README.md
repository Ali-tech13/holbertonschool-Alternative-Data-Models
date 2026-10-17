# Learner Profiles: Document Model with SQLite JSON

A small document-model demonstration using fictional learner profiles. Each
profile contains scalar fields, a nested address, a skills array, and an array
of project objects. The project demonstrates CRUD and nested JSON queries.

SQLite remains a relational database. This demo stores JSON documents in a
relational table; it does not turn SQLite into a native document database.

## Requirements

- SQLite CLI with JSON functions (`json_valid`, `json_extract`, `json_each`,
  `json_set`, and `json_insert`).
- A shell such as Bash, available in WSL.

On Ubuntu, if the CLI is not installed:

```bash
sudo apt update
sudo apt install sqlite3
```

Check JSON support:

```bash
sqlite3 :memory: "SELECT json_extract('{\"ready\":true}', '$.ready');"
```

Expected result: `1`. If a JSON function is unavailable, use a SQLite build
that includes JSON support.

## Run

Open a terminal in this folder. Use a new database filename for the first run:

```bash
sqlite3 -bail learner_profiles.db < 0-create_profiles.sql
sqlite3 -bail learner_profiles.db < 1-insert_profiles.sql
```

Run the remaining files in numerical order:

```bash
for file in [2-9]-*.sql; do
    echo "$file"
    sqlite3 -bail -header -column learner_profiles.db < "$file" || break
done
```

Files 6, 7, and 9 change the data and normally print no rows. To inspect their
effects, run:

```bash
sqlite3 -header -column learner_profiles.db \
  "SELECT id, json_extract(document, '$.name') AS name, json_extract(document, '$.level') AS level, json_extract(document, '$.skills') AS skills FROM profiles ORDER BY id;"
```

To repeat the entire demo from its original state, use another new database
filename. The create and insert files intentionally fail on an existing table
or duplicate IDs rather than silently replacing data.

## Files and expected results

| File | Purpose | Expected result in sequence |
| --- | --- | --- |
| `0-create_profiles.sql` | Create the document container | Empty `profiles` table |
| `1-insert_profiles.sql` | Insert five JSON profiles | Ali, Sara, Omar, Noura, Fahad |
| `2-find_by_level.sql` | Filter a top-level field | Ali and Noura |
| `3-find_by_city.sql` | Filter nested `address.city` | Ali and Omar in Riyadh |
| `4-find_python_learners.sql` | Search a scalar array | Ali, Omar, Sara |
| `5-find_security_projects.sql` | Search an array of objects | Ali: Log Analyzer; Omar: Packet Inspector |
| `6-update_learner_level.sql` | Update a JSON field | Sara becomes intermediate |
| `7-append_skill.sql` | Append a skill | Ali gains Linux, without duplicates on reruns |
| `8-count_profiles_by_city.sql` | Aggregate a nested field | Jeddah: 2; Riyadh: 2; Dammam: 1 |
| `9-delete_inactive_profiles.sql` | Delete inactive documents | Fahad is deleted; four profiles remain |

The count in file 8 includes inactive profiles. Running it after file 9 gives
different counts because Fahad has been removed.

## Data representation

- `profiles.id`: unique row identifier.
- `profiles.document`: valid JSON whose root must be an object.
- `$.name` and `$.level`: top-level fields.
- `$.address.city`: a field inside a nested object.
- `$.skills`: an array of strings.
- `$.projects`: an array of objects with title, category, and completed fields.

The database validates JSON syntax and the root object type. It does not enforce
the presence or type of every profile field; a production design would need
additional validation appropriate to its requirements.

## Demo talking points

1. Show the profiles and the nested structure.
2. Run files 2 through 5 to demonstrate querying different JSON structures.
3. Run file 6, inspect Sara, then run file 7 and inspect Ali's skills.
4. Run file 8 to summarize profiles by city.
5. Run file 9 and confirm that Fahad is gone.

Document-shaped data keeps a learner's address, skills, and projects together.
A normalized relational design would often separate skills and projects into
related tables, which can help enforce relationships and query shared entities.
Embedding data also introduces choices about duplication and validation.

Compared with a basic key-value interface, this demo queries fields inside a
value instead of retrieving only by a known key. SQLite supplies these JSON
query functions. A combined system could use relational tables for registrations,
document-shaped profiles for learner details, and a key-value store for temporary
session data.

## References

- SQLite JSON functions: https://www.sqlite.org/json1.html
- SQLite CREATE TABLE: https://www.sqlite.org/lang_createtable.html

These files cover the SQL demonstration. The PLD also requests a research summary,
a presentation, and a final demonstration as separate deliverables.
