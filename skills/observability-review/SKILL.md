---
name: forge:observability-review
description: "Review frontend observability across error reporting, logs, traces, performance telemetry, analytics, privacy, release health, and operational debugging. Use for production-readiness reviews, monitoring gaps, frontend incidents, analytics instrumentation, or error-tracking design."
---

# Observability Review

Determine whether operators can detect, explain, and safely act on frontend failures without collecting unnecessary user data.

## Discover

Inspect error boundaries, logging, telemetry SDKs, analytics, tracing headers, source-map handling, release identifiers, feature flags, consent controls, privacy requirements, dashboards, alerts, and incident workflows.

## Review dimensions

- Error capture: uncaught errors, rejected promises, route/render boundaries, API failures, and actionable context.
- Release health: version, commit, environment, deployment, feature-flag state, and rollback correlation.
- Performance: Web Vitals, route/navigation timing, long tasks, resource failures, and representative sampling.
- Distributed diagnosis: request/correlation identifiers propagated without exposing secrets.
- Analytics: event names, schema ownership, duplication, funnel meaning, and validation.
- Privacy: consent, minimization, redaction, retention, regional constraints, and sensitive fields.
- Noise control: grouping, deduplication, sampling, rate limits, bot filtering, and alert thresholds.
- Debuggability: private source-map upload, breadcrumbs, reproduction context, and runbooks.

Never log credentials, tokens, full request bodies, personal form contents, or sensitive storage. Public production source maps and observability SDK keys must be evaluated according to whether they are intentionally publishable.

## Report

Tie every recommendation to an operational question such as “Can we detect it?”, “Can we identify affected releases?”, or “Can we reproduce it safely?” Separate missing signals, noisy signals, privacy risks, and process gaps. Include verification and rollout steps for instrumentation changes.
