---
name: wcag-aaa-web-design
description: Create corporate/formal, device-sensitive web applications compliant with WCAG 2.2 AAA standards. Use for building highly accessible websites and web apps that require strict adherence to accessibility, a formal tone, and responsive design for at least three device sizes. This skill provides a complete workflow, design system, component templates, and validation scripts.
---

# WCAG 2.2 AAA Web Design Skill (Enterprise Edition)

## Overview

This skill provides a comprehensive, framework-agnostic workflow for creating **enterprise-grade, corporate/formal web applications** that meet the highest level of web accessibility, **WCAG 2.2 Level AAA**. It is grounded in industry best practices from Nielsen Norman Group, IBM Carbon Design System, and OWASP.

It provides production-grade resources: a formal design system, responsive HTML/CSS templates, ARIA patterns, a modular JavaScript template, security guidance, and robust validation scripts.

## Core Principles

-   **Corporate/Formal Tone**: All content must use professional language. No emoji, slang, or informalities.
-   **Enterprise-Grade UX**: Prioritize efficiency, clarity, and scalability for complex, data-intensive workflows.
-   **Device-Sensitive**: The layout must be responsive and tested on at least three breakpoints (mobile, tablet, desktop).
-   **AAA Compliance**: All 87 WCAG 2.2 success criteria (A, AA, and AAA) must be met.
-   **Secure by Default**: All templates and patterns follow OWASP best practices for front-end security.
-   **Modular & Maintainable**: No hardcoded values. All styling uses CSS custom properties. All JavaScript is modular with single-responsibility functions.

## The 7-Step Enterprise Workflow

### Step 1: Foundation & Theming

Set up the project and apply the corporate visual style.

1.  **Copy Templates**: Copy all files from the `templates/` directory into your project.
2.  **Consult Design System**: Read `references/corporate-design-system.md` for the AAA-compliant color palette, typography, spacing, CSS architecture (BEM naming), and performance guidance.
3.  **Apply Tokens**: Use CSS custom properties from `tokens.css` and `components.css` for all styling.
4.  **Custom Branding**: If brand colors are provided, validate the entire color system:
    ```bash
    python3 scripts/check_contrast.py --tokens templates/tokens.css
    ```

### Step 2: Security Configuration

Harden the application against common web vulnerabilities.

1.  **Read Security Guide**: Read `references/security-error-handling.md` for essential patterns covering CSP, XSS prevention, CSRF protection, and secrets management.
2.  **Configure CSP**: Set a strict, nonce-based Content Security Policy as an HTTP header. If no server is available, use the `<meta>` tag fallback in `base.html`.
3.  **Configure Headers**: Set all recommended HTTP security headers on the server (`Strict-Transport-Security`, `X-Content-Type-Options`, `Referrer-Policy`, `Permissions-Policy`).

### Step 3: Information Architecture & Navigation

Define the application structure and navigation.

1.  **Consult Navigation Patterns**: Read `references/navigation-patterns.md`.
2.  **Implement Navigation**: Use `sidebar-nav.html` for complex apps or `header.html` for simpler sites.
3.  **Include JavaScript**: Use `main.js` as the entry point. It provides accessible navigation toggle, focus trapping, sidebar, and Escape key handling.

### Step 4: Content & Structure

Build pages with semantic HTML and proper heading hierarchy.

1.  **Use `base.html`**: Use as the foundation for all pages. It includes skip links, ARIA landmarks, live regions, and security meta tags.
2.  **Heading Hierarchy (2.4.10)**: Every page MUST have exactly one `<h1>`. Sections must use logical heading order.
3.  **Line Length (1.4.8)**: Place long-form text inside `.text-container` (max-width: 80ch).
4.  **External Links**: All links opening in a new tab MUST use `rel="noopener noreferrer"` and include screen reader text `(opens in a new tab)`.

### Step 5: Data Presentation & Application States

Design for data-heavy screens and non-ideal states.

1.  **Data Tables**: Use `data-table.html`. Read `references/data-presentation.md` for sorting, filtering, and density patterns.
2.  **Application States**: Read `references/application-states.md` for loading (skeleton screens from `components.css`), empty states (`empty-state.html`), error states, API error handling, and JavaScript error boundaries.

### Step 6: Interactive Components & Forms

Build accessible interactive elements with proper security.

1.  **ARIA Patterns**: Read `references/aria-patterns.md` for Modals, Tabs, Accordions, and Menus.
2.  **Form Security**: Read `references/form-patterns.md`. All state-changing forms MUST use CSRF tokens. All user input MUST be encoded on output (`textContent`, never `innerHTML`).
3.  **Destructive Actions**: All delete/irreversible actions MUST require confirmation. Use `data-confirm` attribute with `main.js`.
4.  **Error Handling**: Use `main.js` global error handlers. Announce errors to screen readers via the live regions in `base.html`.

### Step 7: Validation & Auditing

Automated and manual checks confirm compliance.

1.  **Run Automated Audit**:
    ```bash
    bash scripts/validate_accessibility.sh http://localhost:3000
    bash scripts/validate_accessibility.sh --pages urls.txt --output report.json
    ```
2.  **Manual Review**: Automated tools catch ~40% of issues. Use `references/wcag-aaa-checklist.md` for a full manual audit.

## Resources

| Directory | File | Purpose |
|---|---|---|
| `scripts/` | `check_contrast.py` | AAA contrast checker with `--tokens` mode and suggestion engine. |
| | `validate_accessibility.sh` | Automated WCAG 2.2 AAA audit with JSON reporting. |
| `references/` | `security-error-handling.md` | CSP, XSS, CSRF, secrets management, and error handling patterns. |
| | `corporate-ux-patterns.md` | Enterprise UX guide: visual hierarchy, information density. |
| | `application-states.md` | Loading, empty, error states, API errors, JS error boundaries. |
| | `data-presentation.md` | Data table and dashboard design patterns. |
| | `navigation-patterns.md` | Sidebar, tab, and breadcrumb navigation patterns. |
| | `wcag-aaa-checklist.md` | Complete 87-criteria WCAG 2.2 checklist. |
| | `corporate-design-system.md` | AAA color palette, typography, spacing, CSS architecture, BEM naming. |
| | `aria-patterns.md` | ARIA patterns for Modals, Tabs, Accordions, Menus. |
| | `form-patterns.md` | Accessible forms with CSRF, XSS prevention, and validation. |
| | `responsive-breakpoints.md` | 3+ breakpoint system with layout and touch target guidance. |
| `templates/` | `base.html` | HTML5 boilerplate with security meta tags, skip links, live regions. |
| | `header.html` | Accessible header with responsive nav and XSS-safe search. |
| | `footer.html` | Accessible footer with external link security pattern. |
| | `main.js` | Modular JS: nav toggle, focus trap, sidebar, error handling, announcements. |
| | `data-table.html` | Sortable, responsive data table with bulk actions. |
| | `empty-state.html` | Templates for empty, no-results, and error scenarios. |
| | `sidebar-nav.html` | Collapsible, hierarchical sidebar navigation. |
| | `tokens.css` | Design tokens, base styles, skeleton tokens, external link indicator. |
| | `responsive.css` | Mobile-first responsive grid system. |
| | `components.css` | Enterprise components: tables, skeletons, sidebar, toasts, badges. |
