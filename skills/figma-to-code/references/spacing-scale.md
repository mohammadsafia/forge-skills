# Spacing Scale — Pixel to Tailwind

Divide pixel values by 4 to get the Tailwind spacing unit.

| Pixels | Tailwind | Example |
|--------|----------|---------|
| 1px | 0.25 (or `px`) | `border` uses `px` |
| 2px | 0.5 | `gap-0.5`, `p-0.5` |
| 4px | 1 | `gap-1`, `p-1`, `m-1` |
| 6px | 1.5 | `gap-1.5`, `p-1.5` |
| 8px | 2 | `gap-2`, `p-2`, `m-2` |
| 10px | 2.5 | `gap-2.5`, `p-2.5` |
| 12px | 3 | `gap-3`, `p-3`, `m-3` |
| 14px | 3.5 | `gap-3.5`, `p-3.5` |
| 16px | 4 | `gap-4`, `p-4`, `m-4` |
| 18px | 4.5 | `gap-4.5`, `p-4.5` |
| 20px | 5 | `gap-5`, `p-5`, `m-5` |
| 24px | 6 | `gap-6`, `p-6`, `m-6` |
| 28px | 7 | `gap-7`, `p-7` |
| 32px | 8 | `gap-8`, `p-8`, `m-8` |
| 36px | 9 | `gap-9`, `p-9` |
| 40px | 10 | `gap-10`, `p-10` |
| 44px | 11 | `gap-11`, `p-11` |
| 48px | 12 | `gap-12`, `p-12` |
| 52px | 13 | `gap-13`, `p-13` |
| 56px | 14 | `gap-14`, `p-14` |
| 60px | 15 | `gap-15`, `p-15` |
| 64px | 16 | `gap-16`, `p-16` |
| 72px | 18 | `gap-18`, `p-18` |
| 80px | 20 | `gap-20`, `p-20` |
| 96px | 24 | `gap-24`, `p-24` |
| 100px | 25 | `gap-25`, `w-25` |
| 112px | 28 | `w-28`, `h-28` |
| 120px | 30 | `w-30`, `h-30` |
| 128px | 32 | `w-32`, `h-32` |
| 140px | 35 | `w-35`, `h-35` |
| 144px | 36 | `w-36`, `h-36` |
| 160px | 40 | `w-40`, `h-40` |
| 176px | 44 | `w-44` |
| 180px | 45 | `w-45` |
| 192px | 48 | `w-48`, `h-48` |
| 200px | 50 | `w-50` |
| 224px | 56 | `w-56` |
| 240px | 60 | `w-60` |
| 256px | 64 | `w-64` |
| 288px | 72 | `w-72` |
| 320px | 80 | `w-80` |
| 384px | 96 | `w-96` |

## Typography Scale

| Figma Size | Tailwind |
|-----------|----------|
| 12px | `text-xs` |
| 14px | `text-sm` |
| 16px | `text-base` |
| 18px | `text-lg` |
| 20px | `text-xl` |
| 24px | `text-2xl` |
| 30px | `text-3xl` |
| 36px | `text-4xl` |
| 48px | `text-5xl` |
| 60px | `text-6xl` |

## Font Weights

| Figma Weight | Tailwind |
|-------------|----------|
| 300 / Light | `font-light` |
| 400 / Regular | `font-normal` |
| 500 / Medium | `font-medium` |
| 600 / SemiBold | `font-semibold` |
| 700 / Bold | `font-bold` |
| 800 / ExtraBold | `font-extrabold` |

## Border Radius

| Figma Radius | Tailwind |
|-------------|----------|
| 2px | `rounded-sm` |
| 4px | `rounded` |
| 6px | `rounded-md` |
| 8px | `rounded-lg` |
| 12px | `rounded-xl` |
| 16px | `rounded-2xl` |
| 24px | `rounded-3xl` |
| 9999px | `rounded-full` |

## When to Use Arbitrary Values

Only use arbitrary values (`p-[13px]`, `w-[437px]`) when:
- The value doesn't divide cleanly by 4 AND there's no close scale equivalent
- It's a truly unique layout measurement (like `max-w-[1018px]`)
- It's a one-off positioning value

Convert arbitrary to scale whenever possible: `max-w-[1018px]` → `max-w-254.5`
