# Evaluation: forge skills on an RSK app (17 Nov 2026)

Method: for each case in `evals/evals.json`, a fresh agent got only the skill's SKILL.md path and the example input
(it could follow files the SKILL.md points to; no evals, no other skills, no repository, written output only). The
output was graded against the case's assertions. One run per case; no wording had to be changed after a run.

| Skill | Case | Passed | Notes |
|---|---|---|---|
| create-page | create-page-rsk-role-page | 7/7 | Asked where roles live and held the route and menu until answered; no `<main>`; `Conditional.Else`. |
| create-api | create-api-rsk-orders | 6/6 | `'/orders'` with the doubled-prefix reason; no toast in hooks. SECURITY passed by absence: no manual token, `withToken` untouched (not stated in words). |
| add-translations | add-translations-rsk-desks | 5/5 | Per-namespace files; code → key; English `detail` never shown; Arabic listed for an approver to be named. |
| create-form | create-form-rsk-booking | 7/7 | `useForm` in the page; `useFieldArray` keyed by id; fieldset/legend per guest; one submit. |
| create-table | create-table-rsk-guests | 5/5 | Plain `Table` with reason; stacked rows with explicit roles. Flagged that `references/table-pattern.md` still uses legacy tokens (the file's header now points RSK apps away from it). |
| test-frontend | test-frontend-rsk-booking | 6/6 | Helper with 5 s wait / 15 s limit and a helper test; declined the "no error toast" assertion with the reason. |
| audit-rtl | audit-rtl-rsk-guestrow | 7/7 | Flagged `ms-2 rtl:me-2`; `<bdi>` via `<Trans>`; `rtl:-scale-x-100`. |
| audit-a11y | audit-a11y-rsk-desks | 8/8 | Found focus return, default button, 28 px target, unnamed group, route-change focus, `ring-tokens-primary`; keyboard walk listed as not verified. |
| review-ui-ux | review-ui-ux-rsk-desks | 5/5 | Matrix (1280/768/375/320, en/ar, dark/light), states, walk; "no verified findings" stated. |

Before this change, each case fails on the line named in its `old_wording_fails_because`.
