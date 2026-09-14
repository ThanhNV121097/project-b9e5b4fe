# SRS — Greeting

Module: `greeting`
Design: [View the approved design](http://localhost:8080/design/b9e5b4fe-34af-4f22-92a9-cee95c3b0f51)
Design system: `design/design-system.md`

> One file per module, at `docs/greeting/SRS.md`. It covers only the functions
> that belong to this module. Never write `docs/SRS.md`.

## 1. Purpose

The greeting module lets any visitor view and update the single greeting for "Hello World Acceptance 2". It proves the full pipeline end to end: persisted data in PostgreSQL, served by the Go API, and shown by the Next.js page. Without it, the product is a static page and cannot demonstrate persisted edits.

## 2. Actors

| Actor | Who they are | What they may do in this module |
|---|---|---|
| Visitor | Anyone who opens the public page | View the stored greeting, edit the greeting text, and save the new greeting |

## 3. Scope

**In scope** — the functions specified below, by their plan titles:

- Persistent editable greeting

**Out of scope** — name what a reader would reasonably expect here and say where it lives instead. This section prevents the same argument twice.

- Sign-in and permissions — deliberately not built; the approved scope has no accounts or roles beyond Visitor.
- Multiple greetings, lists, history, delete, and undo — deliberately not built; the approved scope has exactly one stored greeting.
- Navigation and additional sections — deliberately not built; the approved design has one centered greeting section only.
- External services — deliberately not built; the stakeholder specified no external services.

## 4. Functional requirements

### 4.1 Persistent editable greeting

**Requirement GREETING-001 — Show stored greeting**

*As a* Visitor, *I want to* see the current stored greeting as the page heading, *so that* the page reflects persisted data.

Behaviour:

1. When the Visitor opens the page for the first time and no prior edit exists, the page displays `Hello, World!` as the large greeting heading.
2. When the Visitor opens or reloads the page after a saved edit, the page displays the most recently saved greeting as the large heading.
3. The greeting heading preserves the saved text content exactly, except for trimming leading and trailing whitespace at save time.
4. Long greeting text wraps within the centered content area instead of causing horizontal page scroll.

**Acceptance criteria** — each is proved by at least one test case in `docs/greeting/test-cases/persistent-editable-greeting.md`, through the story plan that cites it (`SC-1 [GREETING-001 AC-1]`). Given/When/Then, no compound conditions: one behaviour per criterion.

| # | Given | When | Then |
|---|---|---|---|
| AC-1 | No greeting has been saved after initial seed | Visitor opens the page | Large heading text is `Hello, World!` |
| AC-2 | Stored greeting is `Pipeline accepted` | Visitor opens the page | Large heading text is `Pipeline accepted` |
| AC-3 | Stored greeting is `Reload survives` | Visitor reloads the page | Large heading text remains `Reload survives` |
| AC-4 | Stored greeting is longer than one line at the viewport width | Visitor opens the page | Heading wraps within the content area with no horizontal page scroll |

**Requirement GREETING-002 — Edit and save greeting**

*As a* Visitor, *I want to* enter a replacement greeting and save it, *so that* future page loads show my new greeting.

Behaviour:

1. The page includes one text field labelled `Greeting` for editing the greeting.
2. The text field initially contains the same text as the displayed heading.
3. The page includes one primary action button labelled `Save`.
4. When the Visitor enters a non-empty greeting and submits the form by clicking `Save` or pressing Enter in the text field, the saved greeting becomes the trimmed text.
5. After a successful save, the heading and text field both show the saved greeting.
6. After a successful save, the status message region announces `Saved.`.
7. If the Visitor submits an empty or whitespace-only value, no greeting is saved, focus returns to the text field, and the status message region announces `Enter a greeting.`.

**Acceptance criteria** — each is proved by at least one test case in `docs/greeting/test-cases/persistent-editable-greeting.md`, through the story plan that cites it (`SC-1 [GREETING-002 AC-1]`).

| # | Given | When | Then |
|---|---|---|---|
| AC-1 | Stored greeting is `Hello, World!` | Visitor opens the page | Text field value is `Hello, World!` |
| AC-2 | Page is open | Visitor views the form | Text field has accessible label `Greeting` |
| AC-3 | Page is open | Visitor views the form | Primary button text is `Save` |
| AC-4 | Stored greeting is `Hello, World!` | Visitor enters `New greeting` and clicks `Save` | Heading text becomes `New greeting` |
| AC-5 | Stored greeting is `Hello, World!` | Visitor enters `New greeting` and presses Enter in the text field | Heading text becomes `New greeting` |
| AC-6 | Visitor has saved `New greeting` | Visitor reloads the page | Heading text is `New greeting` |
| AC-7 | Visitor has saved `  Trimmed greeting  ` | Save completes | Heading text is `Trimmed greeting` |
| AC-8 | Visitor has saved `Saved text` | Save completes | Text field value is `Saved text` |
| AC-9 | Visitor has saved `Saved text` | Save completes | Status message text is `Saved.` |
| AC-10 | Stored greeting is `Existing greeting` | Visitor submits an empty value | Heading text remains `Existing greeting` |
| AC-11 | Stored greeting is `Existing greeting` | Visitor submits a whitespace-only value | Status message text is `Enter a greeting.` |
| AC-12 | Stored greeting is `Existing greeting` | Visitor submits a whitespace-only value | Keyboard focus is on the text field |

**Failure, boundary and permission behaviour** — the part most often skipped and most often the source of bugs. Every case this function actually has needs a defined outcome; "should not happen" is not an outcome.

| Case | Condition | Expected behaviour |
|---|---|---|
| Invalid input | Visitor submits empty or whitespace-only greeting | No save occurs; existing heading remains; status message is `Enter a greeting.`; focus returns to the text field |
| Boundary | Visitor saves text with leading or trailing whitespace | Saved greeting is trimmed before display and persistence |
| Boundary | Visitor saves long text | Text is accepted and wraps within the centered content area with no horizontal page scroll |
| Not found | Stored greeting row does not exist after startup seed has run | Not applicable: product state is a single seeded greeting, and missing row recovery belongs to service design rather than an approved screen state |
| Not permitted | Visitor is not signed in | Not applicable: there is no sign-in and all visitors may view and save the greeting |
| Conflict | Multiple visitors save different greetings | Last successful save determines the greeting shown on subsequent load |
| Upstream failure | API or database is unavailable while loading or saving | No error, loading, or retry state is part of the approved design; API contract error envelope belongs to `docs/architecture/services.md` |

**Data touched** — the fields this function reads and writes, in product terms. The physical schema is TL's job in `docs/architecture/erd.md`; this is the list that document has to satisfy.

| Field | Type | Required | Rule |
|---|---|---|---|
| Greeting text | text | yes | Initial value is `Hello, World!`; saved value is trimmed; empty or whitespace-only values are rejected |

## 5. Screens

The design is the source of truth for appearance; this section maps functions onto it so nothing in the design is unaccounted for and nothing specified here is missing from the design.

List only the states the approved design actually shows. A screen the design draws once, with no variant for waiting, for no data, or for a failure, has exactly **one** state and its name is `default`.

| Screen | Section in the design | Functions it serves | States that must exist |
|---|---|---|---|
| Greeting page | `<section class="greeting-section" aria-labelledby="greeting-heading">` in approved `index.html` | GREETING-001, GREETING-002 | default |

Approved design elements covered by criteria:

- Large centered `h1` greeting — GREETING-001 AC-1 through AC-4, GREETING-002 AC-4 through AC-8.
- Visually hidden label text `Greeting` — GREETING-002 AC-2.
- Text input with required greeting value — GREETING-002 AC-1, AC-7, AC-8, AC-10 through AC-12.
- Blue primary `Save` button — GREETING-002 AC-3 through AC-5.
- Status message region — GREETING-002 AC-9, AC-11.
- Empty input message `Enter a greeting.` — GREETING-002 AC-11.
- Success message `Saved.` — GREETING-002 AC-9.
- Centered one-section layout with no navigation — §3 scope and §6 responsive/accessibility requirements.

## 6. Non-functional requirements

Only what is real for this module. Delete rows that do not apply rather than inventing a number nobody will check.

| Area | Requirement |
|---|---|
| Performance | Initial greeting display completes within 2 seconds on a local deployment with cold browser cache and seeded PostgreSQL data |
| Accessibility | Text field has accessible label `Greeting`; status message uses polite status semantics; input and button are keyboard reachable; visible focus exists for input and button; text contrast is at least 4.5:1 |
| Responsive | Page works from 320px viewport width upward with no horizontal page scroll; form stacks at 520px and below |
| Localisation | Static UI copy is English: `Greeting`, `Save`, `Saved.`, and `Enter a greeting.`; visitor-entered greeting text is displayed as entered after save trimming |
| Privacy | No personal data is requested or stored; only the shared greeting text is persisted |

## 7. Dependencies and assumptions

- **Depends on:** PostgreSQL persistence, for retaining the greeting after reload and restart.
- **Depends on:** Go API, for reading and updating the stored greeting.
- **Depends on:** Next.js frontend, for rendering the approved one-page UI.
- **Assumption:** One shared greeting is enough for all visitors. If per-visitor greetings are later required, sign-in, permissions, and data model change.

| Open question | Proposed default | Who decides |
|---|---|---|
| — | No open questions | Stakeholder |

## 8. Traceability

Every plan item in this module appears exactly once, and every requirement id traces to a test case. A gap in this table is a gap in the build.

| Plan item | Requirement ids | Test cases |
|---|---|---|
| Persistent editable greeting | GREETING-001, GREETING-002 | `test-cases/persistent-editable-greeting.md` |
