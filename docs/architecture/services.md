# Service contracts

Backend routes omit proxy prefix `/api`.

## Shared errors

All failures return `application/json`:

```json
{"error":{"code":"invalid_greeting","message":"Greeting must not be empty."}}
```

`code` is stable machine-readable snake_case. `message` is safe display text. No internal database details return to visitors.

## Greeting

### `GET /v1/greeting`

Response `200`:

```json
{"greeting":{"text":"Hello, World!"}}
```

Errors: `500` with `internal_error` if greeting cannot be read.

### `PUT /v1/greeting`

Request:

```json
{"text":"New greeting"}
```

Response `200`:

```json
{"greeting":{"text":"New greeting"}}
```

The server trims `text` before validation and persistence. Errors: `400 invalid_request` for invalid JSON or missing text; `422 invalid_greeting` for empty-after-trim text; `500 internal_error` for persistence failure. Concurrent requests use last successful write wins.

## Health

### `GET /healthz`

Response `200` with `{"status":"ok"}` only after migrations and database `SELECT 1` succeed. Otherwise server does not begin listening; compose marks it unhealthy.
