> The content of this `README.md` is written for a human audience on GitHub. The `SKILL.md` file contains the instructions for the Manus agent.

# WCAG 2.2 AAA Web Design Toolkit

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![WCAG 2.2 AAA Compliant](https://img.shields.io/badge/WCAG%202.2-AAA%20Compliant-brightgreen.svg)](https://www.w3.org/TR/WCAG22/)

A framework-agnostic toolkit for building enterprise-grade, corporate/formal web applications that meet the highest level of web accessibility, **WCAG 2.2 Level AAA**.

This repository provides a comprehensive, production-ready system grounded in industry best practices from Nielsen Norman Group, IBM Carbon Design System, and OWASP. It includes a formal design system, responsive HTML/CSS templates, ARIA patterns, a modular JavaScript template, security guidance, and robust validation scripts.

## What is This?

Achieving WCAG 2.2 AAA compliance is notoriously difficult. This toolkit aims to provide a complete, practical, and well-documented starting point for developers tasked with building highly accessible, corporate web applications. It is designed to be framework-agnostic, using standard HTML, CSS custom properties, and modular JavaScript that can be adapted to any technology stack.

## Features

-   **Enterprise-Grade UX**: Patterns prioritizing efficiency, clarity, and scalability for complex, data-intensive workflows.
-   **AAA-Compliant Design System**: A complete, token-based design system for colors, typography, and spacing where all defaults meet AAA contrast ratios.
-   **Secure by Default**: All templates and patterns follow OWASP best practices for front-end security, including guidance on Content Security Policy (CSP), Cross-Site Scripting (XSS), and Cross-Site Request Forgery (CSRF).
-   **Responsive & Device-Sensitive**: A mobile-first, 3-breakpoint responsive system that ensures usability on phones, tablets, and desktops.
-   **Modular & Maintainable**: No hardcoded values. All styling is driven by CSS custom properties. All JavaScript is modular with single-responsibility functions.
-   **Robust Validation**: Includes scripts for automated contrast checking and full WCAG 2.2 AAA accessibility audits.

## How to Use

1.  **Clone or download** this repository.
2.  **Copy the `templates/` directory** into your project's source folder.
3.  **Consult the `references/` directory** for in-depth guidance on design patterns, security, and accessibility.
4.  **Use the `scripts/`** to validate your work.

### The 7-Step Workflow

This toolkit is built around a 7-step workflow to guide development from foundation to final audit:

1.  **Foundation & Theming**: Set up the project and apply the corporate visual style using `tokens.css`.
2.  **Security Configuration**: Harden the application using the guidance in `security-error-handling.md`.
3.  **Information Architecture & Navigation**: Define the application structure using the patterns in `navigation-patterns.md`.
4.  **Content & Structure**: Build pages with semantic HTML and proper heading hierarchy using `base.html`.
5.  **Data Presentation & Application States**: Design for data-heavy screens and non-ideal states (loading, empty, error).
6.  **Interactive Components & Forms**: Build accessible interactive elements with proper security using ARIA patterns.
7.  **Validation & Auditing**: Use the provided scripts and checklists to confirm compliance.

## Resources Included

| Directory | Purpose |
|---|---|
| `scripts/` | Automated validation scripts for contrast checking (`check_contrast.py`) and full WCAG 2.2 AAA audits (`validate_accessibility.sh`). |
| `references/` | 11 in-depth guides covering the entire system: security, UX patterns, ARIA, forms, data presentation, navigation, design system, and a full WCAG checklist. |
| `templates/` | 11 production-ready, framework-agnostic templates: a secure HTML5 boilerplate, modular JavaScript, responsive CSS, design tokens, and accessible components (header, footer, data table, sidebar, empty states). |

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
