# Compound Component Pattern

## Full Template

```typescript
import { type ComponentProps, type FC, type ReactNode } from 'react';

import { cn } from '@utils';

// 1. Sub-component props — extend native elements
type HeaderProps = ComponentProps<'header'>;
type ContentProps = ComponentProps<'section'>;
type FooterProps = ComponentProps<'footer'>;

// 2. Root props
type MyComponentProps = {
  children: ReactNode;
  className?: string;
};

// 3. Compound type definition
type MyComponentType = FC<MyComponentProps> & {
  Header: FC<HeaderProps>;
  Content: FC<ContentProps>;
  Footer: FC<FooterProps>;
};

// 4. Sub-components — every sub-component follows this exact signature
const Header: FC<HeaderProps> = ({ className, children, ...props }) => (
  <header data-slot="my-component-header" className={cn('border-b p-4', className)} {...props}>
    {children}
  </header>
);

const Content: FC<ContentProps> = ({ className, children, ...props }) => (
  <section data-slot="my-component-content" className={cn('p-4', className)} {...props}>
    {children}
  </section>
);

const Footer: FC<FooterProps> = ({ className, children, ...props }) => (
  <footer data-slot="my-component-footer" className={cn('border-t p-4', className)} {...props}>
    {children}
  </footer>
);

// 5. Root component + static property assignment
const MyComponent: MyComponentType = ({ children, className }) => (
  <div data-slot="my-component" className={cn('rounded-lg border bg-background', className)}>
    {children}
  </div>
);

MyComponent.Header = Header;
MyComponent.Content = Content;
MyComponent.Footer = Footer;

export default MyComponent;
```

## Usage

```tsx
<MyComponent className="shadow-md">
  <MyComponent.Header>
    <h2 className="text-lg font-semibold">Title</h2>
  </MyComponent.Header>
  <MyComponent.Content>
    <p>Body content here</p>
  </MyComponent.Content>
  <MyComponent.Footer>
    <Button>Action</Button>
  </MyComponent.Footer>
</MyComponent>
```

## With Shared Context

Use `createContext` ONLY when state must be shared across 3+ sub-components:

```typescript
import { createContext, useContext, type FC, type ReactNode } from 'react';

import { cn } from '@utils';

type DialogContextValue = {
  isLoading: boolean;
  dialogMode: 'create' | 'edit';
  onClose: () => void;
};

const DialogContext = createContext<DialogContextValue>({} as DialogContextValue);

// Root provides context
type RootProps = {
  children: ReactNode;
  className?: string;
  isLoading: boolean;
  dialogMode: 'create' | 'edit';
  onClose: () => void;
};

const Root: FC<RootProps> = ({ children, className, isLoading, dialogMode, onClose }) => (
  <DialogContext.Provider value={{ isLoading, dialogMode, onClose }}>
    <div data-slot="dialog-root" className={cn('rounded-lg', className)}>
      {children}
    </div>
  </DialogContext.Provider>
);

// Sub-components consume context
const Actions: FC<{ className?: string; children?: ReactNode }> = ({ className, children }) => {
  const { isLoading } = useContext(DialogContext);
  return (
    <footer data-slot="dialog-actions" className={cn('flex gap-3 p-4', className)}>
      {children}
    </footer>
  );
};
```

## When NOT to Use Compound Pattern

- One-off view-specific components
- Simple leaf components (badge, loader, status dot)
- Components in `src/components/ui/` (follow shadcn/ui conventions)
