# Design System — Hello World Acceptance 2

> Source of truth: approved `index.html`.
> Every value below is extracted from it. Changing a value here without changing approved design is a defect.

Last updated: 2026-09-14

## 1. Foundations

### 1.1 Color

Semantic tokens. Name by job, never by hue.

| Token | Value | Used for |
|---|---|---|
| `--color-bg` | `#FFFFFF` | Page background, input background, button text |
| `--color-text` | `#000000` | Heading text, input text, input border, default body text |
| `--color-primary-action` | `#2563EB` | Save button background and border, focus outline |

#### Contrast audit

Every text-on-background pair actually used. Body text ≥ 4.5:1, large text (≥ 18.66px bold or ≥ 24px) ≥ 3:1, UI borders ≥ 3:1.

| Foreground | Background | Ratio | Passes |
|---|---|---|---|
| `--color-text` | `--color-bg` | `21:1` | AA |
| `--color-bg` | `--color-primary-action` | `5.17:1` | AA |
| `--color-primary-action` | `--color-bg` | `5.17:1` | AA |

### 1.2 Spacing

Base unit: `4px`. Product spacing uses these values, plus deviations recorded in section 4.

| Token | Value |
|---|---|
| `--space-3` | `12px` |
| `--space-5` | `20px` |
| `--space-6` | `24px` |

### 1.3 Typography

Font families:

- Body: `Arial, Helvetica, sans-serif`, loaded from system fonts.
- Headings: `Arial, Helvetica, sans-serif`, loaded from system fonts.

| Token | Size | Line height | Weight | Used for |
|---|---|---|---|---|
| `--text-sm` | `14px` | normal | inherited | Status message |
| `--text-base` | `16px` | normal | inherited | Input and button text |
| `--text-display` | `clamp(48px, 10vw, 88px)` | `1` | `700` | h1 greeting |

Heading levels are used in order: one `h1`, no skipped heading level.

| Token | Value | Used for |
|---|---|---|
| `--font-weight-body` | browser default via `font: inherit` | Input text, status text |
| `--font-weight-action` | `700` | Save button |
| `--font-weight-heading` | `700` | Greeting h1 |
| `--tracking-tight` | `-0.04em` | Greeting h1 |

### 1.4 Radius, border, shadow, motion

| Token | Value | Used for |
|---|---|---|
| `--border-width` | `1px` | Input border, button border |
| `--focus-ring-width` | `3px` | Input and button focus outline |
| `--focus-ring-offset` | `3px` | Input and button focus outline offset |

Motion: no animation or transition in approved design.

### 1.5 Layout and breakpoints

| Name | Max width | Container | Columns | Gutter |
|---|---|---|---|---|
| `mobile-form-stack` | `520px` | `100%` | 1 | `12px` |
| `content` | `640px` | `100%` | 1 | `24px` |

Z-index scale:

| Layer | Value |
|---|---|
| Base | `0` |
## 2. Components

### 2.1 Greeting Section

**Purpose** — Center single editable greeting task on page. Do not use for multi-section pages or navigation.

**Anatomy** — `[h1 greeting] [edit form] [status message]`.

**Variants**

| Variant | Tokens | When to use |
|---|---|---|
| Default | `--color-bg`, `--color-text`, `--space-6`, `--text-display` | Only page section |

**Sizes**

| Size | Width | Gap | Text token |
|---|---|---|---|
| Default | `100%`, max `640px` | `24px` | `--text-display` |

**States**

| State | Visual change | Tokens |
|---|---|---|
| Default | Centered column, greeting wraps anywhere, status area reserved with `20px` minimum height | `--color-bg`, `--color-text`, `--space-6`, `--text-display` |

**Accessibility** — Section uses `aria-labelledby="greeting-heading"`. Greeting uses `h1`. Status message uses `role="status"` and `aria-live="polite"`.

### 2.2 Greeting Text Field

**Purpose** — Edit greeting text before saving.

**Anatomy** — `[visually hidden label] [text input]`.

**Variants**

| Variant | Tokens | When to use |
|---|---|---|
| Default | `--color-bg`, `--color-text`, `--border-width`, `--text-base` | Greeting edit input |

**Sizes**

| Size | Width | Padding | Text token |
|---|---|---|---|
| Default | `min(100%, 380px)` | `12px 14px` | `--text-base` |
| Mobile | `100%` | `12px 14px` | `--text-base` |

**States**

| State | Visual change | Tokens |
|---|---|---|
| Default | White background, black text, black 1px border | `--color-bg`, `--color-text`, `--border-width` |
| Focus visible | 3px blue outline with 3px offset | `--color-primary-action`, `--focus-ring-width`, `--focus-ring-offset` |

**Accessibility** — Input has label text `Greeting`, visually hidden with 1px clipped technique. Input is `required` and references status message with `aria-describedby="form-message"`. Keyboard focus uses visible `:focus-visible` outline. Minimum height from 12px vertical padding and 16px text is at least 40px; approved design is below 44px target.

### 2.3 Save Button

**Purpose** — Submit greeting update.

**Anatomy** — `[label]`.

**Variants**

| Variant | Tokens | When to use |
|---|---|---|
| Primary action | `--color-primary-action`, `--color-bg`, `--border-width`, `--font-weight-action` | Main save action |

**Sizes**

| Size | Width | Padding | Text token |
|---|---|---|---|
| Default | content width | `12px 20px` | `--text-base` |
| Mobile | `100%` | `12px 20px` | `--text-base` |

**States**

| State | Visual change | Tokens |
|---|---|---|
| Default | Blue background and border, white text, pointer cursor | `--color-primary-action`, `--color-bg`, `--border-width` |
| Focus visible | 3px blue outline with 3px offset | `--color-primary-action`, `--focus-ring-width`, `--focus-ring-offset` |

**Accessibility** — Native `button type="submit"`. Keyboard submits form through Enter/Space. Focus uses visible `:focus-visible` outline. Minimum height from 12px vertical padding and 16px text is at least 40px; approved design is below 44px target.

### 2.4 Greeting Form

**Purpose** — Group input and Save button for one greeting update.

**Anatomy** — `[label + input] [button]`.

**Variants**

| Variant | Tokens | When to use |
|---|---|---|
| Inline | `--space-3` | Viewport above 520px |
| Stacked | `--space-3` | Viewport at or below 520px |

**Sizes**

| Size | Width | Gap | Text token |
|---|---|---|---|
| Default | `100%` | `12px` | `--text-base` |

**States**

| State | Visual change | Tokens |
|---|---|---|
| Default | Centered row with 12px gap | `--space-3` |
| Mobile | Column layout with full-width input and button | `--space-3` |

**Accessibility** — Native form submission. `novalidate` lets custom message show `Enter a greeting.` when trimmed input is empty.

## 3. Content and formatting

- Voice and tone: plain, direct, minimal.
- Locale: English (`lang="en"`).
- Button capitalization: title case for action label, `Save`.
- Heading capitalization: preserve stored greeting text exactly.
- Label capitalization: title case, `Greeting`.
- Empty input message: imperative sentence, `Enter a greeting.`
- Success message: short past-tense sentence, `Saved.`
- Date, time, number, and currency formats: no such content appears in approved design.

## 4. Known deviations

| Where | Deviation | Why it stands | Follow-up |
|---|---|---|---|
| `input` padding | Horizontal padding uses `14px`, outside 4px spacing scale | Approved design uses exact value | Keep for current page; change only through design edit if stakeholder requests tighter scale |
| `button`, `input` hit target | Minimum height is about 40px, below 44×44px target | Approved design uses `12px` vertical padding with 16px text | Raise to 44px only through design edit |
| Interactive controls | Approved design draws default and focus-visible only; no hover, active, disabled, loading, or error visual states | Scope is minimal one-page mockup | Add states only when approved design adds them |

AI default checks: approved design avoids purple/indigo palette, gradients, maximum rounding, oversized padding, heavy shadows, generic multi-section layout, emoji iconography, filler copy, removed focus states, blank empty states, text over images, and hover-only affordances.

## 5. Change log

| Date | Change | Design PR |
|---|---|---|
| 2026-09-14 | Initial design system extracted from approved `index.html` | This PR |
