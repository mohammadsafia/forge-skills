---
name: forge:performance-audit
description: "Audit React or frontend performance using evidence from loading, waterfalls, bundles, rendering, hydration, assets, caching, and Core Web Vitals. Use for slow pages, large bundles, excessive rendering, performance regressions, or optimization requests."
---

# Performance Audit

Find the largest user-impacting bottlenecks before recommending code-level micro-optimizations.

## Establish the runtime

Discover the framework, rendering model, React version, Compiler configuration, deployment target, browser support, performance budgets, and available production or lab measurements. Read `../_shared/react-version-compatibility.md` before recommending memoization.

## Priority order

1. Network and async waterfalls
2. Initial JavaScript, CSS, fonts, images, and third-party bundle cost
3. Server rendering, streaming, serialization, and hydration work
4. Cache behavior and duplicated client requests
5. Layout shifts, main-thread work, long tasks, and interaction latency
6. Re-rendering and expensive calculations
7. Low-level JavaScript optimizations only when measured

## Method

- Prefer production telemetry and reproducible traces over intuition.
- Compare against a baseline and state device/network conditions.
- Inspect route chunks and dependency composition before blaming component renders.
- Identify independent async work that can start earlier or run concurrently.
- Verify image dimensions, responsive sources, font loading, and below-fold deferral.
- Use React Profiler or framework tooling to prove render-frequency problems.
- With React Compiler, do not default to manual `memo`, `useMemo`, or `useCallback`; without Compiler, still require a meaningful identity or computation boundary.
- Treat Core Web Vitals as user-experience signals, not the only performance goals.

## Findings

For each finding provide evidence, affected user journey, estimated impact, confidence, correction, and verification method. Separate measured findings from hypotheses requiring profiling.

Do not claim a performance improvement from source inspection alone when it can be measured. Preserve correctness and accessibility; faster incorrect UI is not an optimization.
