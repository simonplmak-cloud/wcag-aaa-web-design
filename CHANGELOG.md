# Changelog

## v5.0 — Consistency Review (2026-02-15)

This release resolves all cross-file inconsistencies identified during a comprehensive audit of all 24 files, with WCAG and coding standard fixes taking priority.

### P0 Bug Fixes (Factual Contradictions Between Files)

| File | Issue | Fix |
|---|---|---|
| `corporate-design-system.md` | Typography table showed heading line-heights of 1.333 and 1.278 | Corrected to 1.5 to match `tokens.css` |
| `corporate-design-system.md` | Code examples used hardcoded values (`44px`, `0.625rem`, `0.25rem`) | Replaced with CSS custom properties (`var(--target-size-min)`, `var(--space-2)`, `var(--radius-md)`) |
| `corporate-design-system.md` | Code examples used directional CSS (`margin-bottom`, `text-align: left`) | Replaced with logical properties (`margin-block-end`, `text-align: start`) |
| `application-states.md` | Skeleton code used hardcoded colors (`#e0e0e0`, `#f0f0f0`) | Replaced with `var(--color-skeleton)` and `var(--color-skeleton-highlight)` tokens |

### P1 Structural Consistency

| Area | Change |
|---|---|
| File path references | Standardized all cross-references to use relative paths from skill root (e.g., `references/file.md`) |
| Missing H1 headings | Added to `wcag-aaa-checklist.md`, `responsive-breakpoints.md`, `corporate-design-system.md` |
| Template comments | All HTML templates now correctly reference both `tokens.css` and `components.css` as style dependencies |
| `base.html` | Added structured header comment matching other templates; fixed duplicate `</html>` closing tag |

### P2 Documentation Structure

| Area | Change |
|---|---|
| Missing Table of Contents | Added to `corporate-ux-patterns.md`, `application-states.md`, `data-presentation.md`, `navigation-patterns.md` |
| Duplicated content | Consolidated error handling: `application-states.md` now references `security-error-handling.md` as single source of truth |

---

## v4.0 — Full-Stack Security & Coding Best Practices (2026-02-15)

This release hardens the skill against common web vulnerabilities and elevates all code to production-grade quality with modular, maintainable patterns.

### New Resources

| File | Description |
|---|---|
| `references/security-error-handling.md` | Comprehensive security guide covering HTTP security headers, Content Security Policy (CSP), XSS prevention, CSRF protection, secrets management, API error handling, and JavaScript error boundaries. |
| `templates/main.js` | Production-ready, modular JavaScript file. Extracts all JS from HTML comments into a proper module with single-responsibility functions: mobile nav toggle, sidebar toggle, expandable sections, focus trapping, global error handling, accessible announcements, and destructive action confirmation. |

### Security Hardening

| Area | Change |
|---|---|
| `base.html` | Added security meta tags (`X-Content-Type-Options`, `Referrer-Policy`). Added commented-out strict nonce-based CSP meta tag with documentation. Added `nonce` guidance on script tags. |
| `header.html` | Added XSS prevention comments on search form output encoding. |
| `footer.html` | Added external link security pattern (`rel="noopener noreferrer"`) with documentation. |
| `form-patterns.md` | Added CSRF Synchronizer Token Pattern. Added XSS output encoding guidance. Added destructive action confirmation pattern. |
| `application-states.md` | Added API error handling table (network, 4xx, 5xx, timeouts). Added JavaScript error boundary patterns. |
| `check_contrast.py` | Added hex input validation (`re.fullmatch`). Added max file size check (1 MB) for `--file` mode. |
| `validate_accessibility.sh` | Added URL scheme validation (allowlist: http, https, file). Fixed JSON report assembly using Python `json.dump`. Added temp directory cleanup via `trap`. |

### Coding Best Practices

| Area | Change |
|---|---|
| `main.js` | All DOM text uses `textContent` (never `innerHTML`). All events use `addEventListener`. All DOM queries cached. Defensive null checks. IIFE prevents global leakage. |
| `tokens.css` | Added `--color-skeleton` and `--color-skeleton-highlight` tokens. Added external link visual indicator. |
| `components.css` | Replaced hardcoded skeleton colors with tokens. Fixed duplicate `display` in `.sidebar__sublink`. |
| `corporate-design-system.md` | Added CSS Architecture section. Added BEM naming convention. Added Performance Best Practices. |

### Workflow Changes

Expanded from 6 steps to 7 steps, adding a dedicated **Security Configuration** step (Step 2).

---

## v3.0 — Enterprise UX Refinement (2026-02-15)

This release transforms the skill from a general accessibility toolkit into a comprehensive enterprise web application design system, grounded in industry best practices from Nielsen Norman Group, IBM Carbon Design System, and leading enterprise UX research.

### New Reference Documents

| File | Purpose |
|---|---|
| `corporate-ux-patterns.md` | Central guide to enterprise UX: efficiency over delight, progressive disclosure, visual hierarchy. |
| `application-states.md` | Patterns for loading, empty, and error states. |
| `data-presentation.md` | Enterprise data table and dashboard best practices. |
| `navigation-patterns.md` | Sidebar, tabbed, and breadcrumb navigation patterns. |

### New Templates

| File | Purpose |
|---|---|
| `data-table.html` | Accessible, sortable data table with sticky headers, bulk actions, pagination. |
| `empty-state.html` | Three variants: No Data, No Results, Error State. |
| `sidebar-nav.html` | Collapsible sidebar navigation with hierarchical sections. |
| `components.css` | Enterprise component stylesheet (tables, skeletons, sidebar, toasts, badges). |

---

## v2.0 — Industrial Best Practices Refinement (2026-02-15)

### Critical Bug Fixes

| File | Issue | Fix |
|---|---|---|
| `tokens.css` | `:focus { outline: none; }` removed focus without `:focus-visible` | Replaced with `:focus:not(:focus-visible)` |
| `tokens.css` | Heading `line-height: 1.333` violated AAA (1.4.8) | Changed to `1.5` |
| `tokens.css` | `scroll-behavior: smooth` unconditional | Conditional on `prefers-reduced-motion` |
| `responsive.css` | `display: block` on `<table>` broke semantics | `.table-responsive` wrapper |
| `validate_accessibility.sh` | pa11y exit codes reversed | Corrected |
| `header.html` | Unicode emoji search icon | Inline SVG |
| `footer.html` | `<address>` misused | Changed to `<div>` |

### New Resources

Added `aria-patterns.md` and `form-patterns.md`. Enhanced scripts with `--tokens`, `--json`, `--pages` modes.

---

## v1.0 — Initial Release (2026-02-15)

Initial creation with core design system, templates, and validation scripts.
