# ERD

## `greetings`

Single shared row. Migration seeds `id = 1` with `Hello, World!`.

| Column | Type | Constraints | Notes |
|---|---|---|---|
| `id` | `smallint` | primary key, check `id = 1` | Enforces one greeting. |
| `text` | `text` | not null, check `btrim(text) <> ''` | API trims before write. |
| `updated_at` | `timestamptz` | not null, default `now()` | Last successful save time. |

Relationships: none. No users, ownership, or history exist.

Migration compatibility: create and seed table in first ordered migration. Later migrations must be additive or include compatible backfill before constraint changes.
