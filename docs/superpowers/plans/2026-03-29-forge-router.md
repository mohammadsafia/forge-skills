# Forge Router Maintenance Plan

**Spec:** `docs/superpowers/specs/2026-03-29-forge-router-design.md`

**Executable source:** `skills/forge/SKILL.md`

## Current implementation

- [x] Create the portable `forge:forge` router.
- [x] Catalog creation, migration, verification, and workflow skills.
- [x] Add subsumption and dependency ordering.
- [x] Replace the host-specific `Skill(...)` assumption with capability-based invocation.
- [x] Replace unconditional confirmation with risk-based confirmation.
- [x] Add structured brainstorming without making it a universal gate.
- [x] Add React 18/19 and React Compiler discovery.
- [x] Add testing, design-system, and React-migration routes.
- [x] Keep focused quality skills as direct entry points.
- [x] Add optional companion-skill guidance with graceful fallback.
- [x] Add deterministic repository validation.

## Maintenance workflow

When adding, removing, or renaming a skill:

1. Decide whether it is routable, direct-entry, or an optional companion.
2. Update `skills/forge/SKILL.md` only when the router should select it.
3. Assign a dependency layer and document subsumption or conflict rules where real overlap exists.
4. Add trigger language that is discriminating rather than exhaustive.
5. Update README and `CLAUDE.md` counts and catalogs.
6. Update the design spec when router behavior or architecture changes.
7. Run:

   ```bash
   npm run validate
   git diff --check
   ```

## Behavioral evaluation matrix

- [ ] A direct request for one skill selects only that skill.
- [ ] A full-feature request removes redundant `create-api` and `create-page` selections.
- [ ] Explicit brainstorming does not begin implementation.
- [ ] A clear implementation request is not blocked by mandatory brainstorming or confirmation.
- [ ] React work discovers React version and Compiler state before optimization advice.
- [ ] React migration runs independently from unrelated generation.
- [ ] Testing is suggested based on risk without silently installing infrastructure.
- [ ] Figma work routes through design interpretation before downstream UI creation.
- [ ] External Git actions still require appropriate authorization.
- [ ] Missing companion skills degrade gracefully to native Forge capabilities.
- [ ] Review and audit skills are not auto-appended to ordinary building work.
- [ ] Ambiguous requests cause at most one material clarifying question at a time.

## Future hardening

- Add fixture-based router evaluations with representative user prompts and expected capability sets.
- Validate that every routed skill named in the router exists on disk.
- Validate that direct-entry skill names in the spec exist on disk.
- Consider a generated catalog section if manual router/catalog drift becomes frequent.
- Track false-positive and false-negative routing examples from real usage and update trigger descriptions narrowly.
