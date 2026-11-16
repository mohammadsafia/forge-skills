---
name: forge:review-ui-ux
description: "Review a frontend interface, implementation, screenshot, or flow for usability, visual hierarchy, interaction quality, responsive behavior, accessibility, and design-system consistency. Use for UI critique, UX review, design QA, or pre-release interface polish."
---

# Review UI/UX

Evaluate whether the interface helps its intended users complete the intended task clearly, efficiently, and
confidently, by using it: at each width, in each state, with the keyboard.

## Step 1 — Context

Identify the audience, primary task, device range, supported themes and languages, design system, and product
constraints. Read the project's design record if it has one (`docs/design.md` or similar) and the decisions of its
business analyst: where a design rule and a recorded business decision disagree, the decision wins.

If `kit.lock.json` exists at the repository root, the app is built on the RSK kit: read `../_shared/rsk-kit.md`. Judge
screens against the kit's components and tokens (default theme dark; light and dark both supported; English and
Arabic).

## Step 2 — Plan the Matrix

List the screens in scope, and for each the states to see:

| State | How to reach it |
|---|---|
| Loading | slow the network, or look before data arrives |
| Empty, first use | no data at all: does the screen say what to do first? |
| Empty, no match | a search or filter with no result: is it worded differently from first use? |
| Error | the API answers 500, 403, 404, or is unreachable |
| Long content | long names, long Arabic text, many rows, a value with no spaces |
| Validation | submit a form empty and with wrong values |
| Success | after save, delete, and each other action |
| Limited access | a person without the role for some actions |

Widths: 1280 px (desktop), 768 px (tablet), 375 px (phone), and 320 px for reflow. Languages: each one the product
supports (Arabic shows right-to-left faults). Themes: each one it supports.

Write down which cells of the matrix you could not reach and why.

## Step 3 — Look

When a browser is available, run the app, sign in with the project's test or development accounts (never a real person's account, never production data; reach states with test data), and for every screen × state × width × language take a screenshot
named `<screen>-<state>-<width>-<lang>.png`. Look at each one; a script that passed is not a look. Check:

- Information architecture and task flow: is the primary action obvious; does the order of the page follow the task?
- Visual hierarchy, spacing, density and alignment; one name per action across the flow.
- Responsive reflow: no sideways page scroll, no clipped controls, tables usable at phone width, sticky parts not
  covering content.
- RTL: mirrored layout, icons, popover sides, numbers and names reading correctly (see `forge:audit-rtl`).
- Feedback: every action shows its result where the person is looking.

When no browser is available, review the code and screenshots you were given, and say that rendering was not seen.

## Step 4 — Walk It With the Keyboard

On each changed screen, with the keyboard only:

1. Tab through the page: every stop visible and in reading order.
2. Navigate to the screen through the menu: where is focus after the page loads?
3. Open and close each sheet, dialog and menu: where is focus after it closes?
4. Press Enter in each form's text fields: which button acts?
5. Do the primary task end to end without a mouse, at phone width too.

Record each step's result. Use `forge:audit-a11y` for the code-level checks; this walk finds what it cannot.

## Step 5 — Report

For each issue: the screen and component, the state, width and language where it shows, the steps to see it, user
impact, severity, and a concrete change. Attach or name the screenshot. Group into:

- Blockers
- High-value improvements
- Polish
- Validation needing user testing or product evidence
- Not checked (cells of the matrix and walk steps not reached, and why)

Distinguish objective accessibility or usability defects, verified design-system deviations, and subjective
suggestions. Avoid generic advice such as "improve hierarchy": name the element, the competing signals, and the
proposed change.
