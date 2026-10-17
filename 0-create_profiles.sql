-- Store one learner profile per row as a JSON object.
CREATE TABLE profiles (
    id INTEGER PRIMARY KEY,
    document TEXT NOT NULL
        CHECK (json_valid(document))
        CHECK (json_type(document) = 'object')
);
