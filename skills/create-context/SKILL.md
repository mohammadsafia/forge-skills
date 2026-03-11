---
name: create-context
description: "Create React Context with provider and custom hook following project conventions. Use when the user wants to add global state, create a context provider, share state across components, or says 'create context', 'add context for', 'new provider', 'global state for', 'shared state'. Triggers whenever React Context + Provider + hook needs to be set up."
---

# Create Context

Generate a React Context with typed provider and consumer hook.

## Step 1 — Verify Context is Needed

Context should only be used for **global UI state**. Check alternatives first:

| State Type | Solution |
|------------|----------|
| Server data | React Query (not Context) |
| Local UI state | useState (not Context) |
| URL state | nuqs (not Context) |
| Global UI state | Context (Auth, Theme, Products, Bookmarks) |

If the state comes from an API, use React Query instead.

## Step 2 — Scan Existing Contexts

Read `src/lib/contexts/` to mirror the pattern. The project already has:
- `AuthContext` — authentication state and roles
- `ThemeContext` — light/dark theme
- `ProductsContext` — product state
- `BookmarksContext` — bookmark state

Check if the existing contexts already cover the need.

## Step 3 — Generate Files

### Context File

File: `src/lib/contexts/<ContextName>Context.tsx`

```typescript
import { createContext, useContext, useState, useMemo, type FC, type ReactNode } from 'react';

type FeatureContextValue = {
  selectedId: string | null;
  isOpen: boolean;
  setSelectedId: (id: string | null) => void;
  setIsOpen: (open: boolean) => void;
};

const FeatureContext = createContext<FeatureContextValue | undefined>(undefined);

type FeatureProviderProps = {
  children: ReactNode;
};

export const FeatureProvider: FC<FeatureProviderProps> = ({ children }) => {
  const [selectedId, setSelectedId] = useState<string | null>(null);
  const [isOpen, setIsOpen] = useState(false);

  const value = useMemo(
    () => ({ selectedId, isOpen, setSelectedId, setIsOpen }),
    [selectedId, isOpen],
  );

  return (
    <FeatureContext.Provider value={value}>
      {children}
    </FeatureContext.Provider>
  );
};

export const useFeature = (): FeatureContextValue => {
  const context = useContext(FeatureContext);
  if (!context) {
    throw new Error('useFeature must be used within a FeatureProvider');
  }
  return context;
};
```

### Update Barrel Export

```typescript
// src/lib/contexts/index.ts — add:
export { FeatureProvider, useFeature } from './FeatureContext';
```

### Wrap in Layout

Add the provider at the appropriate level in the component tree (typically in a layout or the app root).

## Rules

- Use `type` not `interface` for context value
- Memoize the value object with `useMemo` to prevent unnecessary re-renders
- Always create a custom hook with a descriptive error message
- Export both Provider and hook through the barrel `@contexts`
- Separate setters from getters in the context type for clarity
- Do not put server state in Context — use React Query
