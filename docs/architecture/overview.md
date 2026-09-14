# Architecture overview

## Stack

| Part | Choice | Reason |
|---|---|---|
| Frontend | Next.js 15 App Router, TypeScript, Tailwind v3, ESLint | Required UI stack; standalone output fits committed image. |
| Backend | Go 1.25, `net/http`, pgx v5 | Small API; stdlib HTTP avoids router dependency. |
| Database | PostgreSQL 16 | Required durable shared greeting. |

## Layout

- `code/backend/cmd/api`: only `main` package and HTTP entry point.
- `code/backend/migrations`: embedded ordered SQL migrations.
- `code/frontend/app`: App Router shell and frozen shared CSS tokens.
- `code/frontend/components`: one default-exported PascalCase component per story.
- `code/frontend/lib/mock`: UI-stage fixtures; backend stage deletes story fixture.
- `docs/architecture`: overview, ERD, API contract.

## Contracts and conventions

- API routes use `/v1/...`, never `/api`; proxy owns `/api` prefix.
- Backend reads `DATABASE_URL`, migrates before listening, then `/healthz` verifies `SELECT 1`.
- Greeting writes trim input; database keeps one seeded row. Last successful write wins.
- API errors use one envelope in `services.md`; external messages stay generic.
- Go uses `cmd/api`, `snake_case` SQL, parameterized queries, context-aware database calls.
- React components use `export default function ComponentName()`; interactive files begin with `"use client"`.
- `app/page.tsx` only composes story components. `app/globals.css` owns all shared tokens and base styles.

## Decisions

| Decision | Rejected | Tradeoff |
|---|---|---|
| One-row PostgreSQL table | Per-user/history model | Meets shared greeting scope; later history needs new table. |
| pgx driver | ORM | One query path needs no abstraction; SQL remains explicit. |
| Self-applied embedded migrations | External migration job | Empty runtime DB works; migration changes need backward-compatible rollout. |
| Native `net/http` | Router framework | Fewer dependencies; add router only when routes need middleware groups. |

## Environment

- Backend: `DATABASE_URL` PostgreSQL connection string; `PORT` listen port; `APP_PORT` local fallback.
- Frontend: `NEXT_PUBLIC_API_URL` browser API origin; `API_ORIGIN` server-side API origin.
- Compose: `POSTGRES_USER`, `POSTGRES_PASSWORD`, `POSTGRES_DB`; optional port and memory overrides in `docker-compose.yml`.

## Run

1. Copy `.env.example` to `.env` if defaults need changing.
2. Run `docker compose --profile local up --build` from repository root.
3. Open `http://localhost:3000`; backend health is `http://localhost:8080/healthz`.

Unknown: production proxy ownership of `/api` is assumed by committed compose/deploy setup. Migration rollout: add ordered up/down pair; never rewrite applied migration.
