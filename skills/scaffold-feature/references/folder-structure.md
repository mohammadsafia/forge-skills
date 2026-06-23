# Feature Folder Structure

## Complete Scaffold

For a feature named "communities" with entity "Community":

```
src/
├── types/api/
│   ├── CommunityDto.ts                    # All DTOs for this entity
│   └── index.ts                           # Add: export * from './CommunityDto'
│
├── api/
│   ├── config/
│   │   └── ApiEndpoints.ts                # Add COMMUNITY endpoints
│   └── handlers/
│       ├── community.ts                   # Handler file
│       └── index.ts                       # Add: export * from './community'
│
├── lib/hooks/
│   ├── queries/
│   │   └── useCommunityQuery.ts           # List + detail query hooks
│   └── mutations/
│       └── useCommunityMutation.ts        # Create + update + delete mutations
│
├── pages/communities/
│   ├── CommunitiesPage.tsx                # List page (route-level)
│   └── CommunityDetailPage.tsx            # Detail page (route-level)
│
├── views/communities/                     # Only if reusable across pages
│   ├── community-card/
│   │   ├── CommunityCard.tsx
│   │   └── index.ts
│   ├── community-form/
│   │   ├── CommunityForm.tsx
│   │   └── index.ts
│   ├── Community.schemas.ts                # Zod form schemas
│   └── index.ts                           # Barrel export
│
├── routes/
│   └── index.ts                           # Add routes + lazy imports
│
└── locales/
    ├── en.json                            # Add community translation keys
    └── ar.json                            # Add Arabic translations
```

## Naming Conventions

| File | Convention | Example |
|------|-----------|---------|
| DTO file | PascalCase | `CommunityDto.ts` |
| Handler file | kebab-case | `community.ts` |
| Handler export | PascalCase + Handler | `CommunityHandler` |
| Query hook file | PascalCase | `useCommunityQuery.ts` |
| Mutation hook file | PascalCase | `useCommunityMutation.ts` |
| Page file | PascalCase + Page | `CommunitiesPage.tsx` |
| View folder | kebab-case | `community-card/` |
| View component | PascalCase | `CommunityCard.tsx` |
| Schema file | PascalCase + `.schemas.ts` | `Community.schemas.ts` |
| Route constant | UPPER_SNAKE | `ROUTES.COMMUNITIES.LIST` |

## Minimal vs Full Scaffold

**Minimal** (read-only feature):
- DTOs: ForReadDto, ListDto, ListResponseDto
- Handler: list + details
- Hooks: list query + detail query
- Page: list page

**Full CRUD**:
- DTOs: ForReadDto, ForCreateDto, ForUpdateDto, ListDto, ListResponseDto, ParamsDto
- Handler: list + details + create + update + delete
- Hooks: all queries + all mutations
- Pages: list + detail
- Views: form component + card component
- Schema: Zod validation
