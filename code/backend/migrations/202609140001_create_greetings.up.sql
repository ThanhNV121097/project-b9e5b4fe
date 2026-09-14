CREATE TABLE greetings (
  id SMALLINT PRIMARY KEY CHECK (id = 1),
  text TEXT NOT NULL CHECK (btrim(text) <> ''),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

INSERT INTO greetings (id, text) VALUES (1, 'Hello, World!');
