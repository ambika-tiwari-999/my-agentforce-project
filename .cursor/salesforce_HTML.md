---
name: web-design
description: >
  Salesforce-branded web orchestrator: framework choice, design foundation with SF product layout knowledge, implementation with brand tokens and GSAP, React replica methodology, and Impeccable polish.
  TRIGGER when: building ANY web page, UI, landing page, interactive web experience, or React replica of SF products.
  DO NOT TRIGGER when: building Salesforce metadata (LWC, Flows, Apex) or non-web work.
---

# Web Design — SF-Branded Web Orchestrator

This skill's unique value: SF brand visual system (sacred color palette, typography, effects), product layout anatomy for replicas, motion graphics pipeline, Google MCP visual references, and orchestration logic for WHEN to invoke WHICH sub-skill.

---

## SACRED VISUAL SYSTEM — Non-Negotiable Brand Rules

These rules override everything. Inspect the `sf-assets/` archive before generating ANY web output.

### Typography
- **AvantGarde** for headlines (h1/h2). **Salesforce Sans** for body and UI. No exceptions.
- Font files: `sf-assets/brand/typography/`

### Color Palette (ONLY these values — no arbitrary hex)

```css
:root {
  /* Electric Blue — primary action, links, CTAs */
  --electric-blue-15: #001E5B;
  --electric-blue-30: #022AC0;
  --electric-blue-50: #066AFE;

  /* Cloud Blue — highlights, hover states, light accents */
  --cloud-blue-68: #00B3FF;
  --cloud-blue-80: #90D0FE;
  --cloud-blue-95: #EAF5FE;

  /* Neutrals */
  --white: #FFFFFF;
  --black: #000B2E;
  --gray-20: #181818;
  --gray-40: #3E3E3C;
  --gray-60: #706E6B;
  --gray-80: #DDDBDA;
  --gray-95: #F3F2F2;

  /* Accent — use sparingly */
  --green: #2E844A;
  --orange: #DD7A01;
  --violet: #9050E9;
  --hot-pink: #FF538A;

  /* Gradients — section backgrounds (Morning=lightest → Evening=darkest) */
  --gradient-morning: linear-gradient(180deg, #EAF5FE 0%, #FFFFFF 100%);
  --gradient-midday: linear-gradient(180deg, #00B3FF 0%, #066AFE 100%);
  --gradient-dusk: linear-gradient(180deg, #022AC0 0%, #001E5B 100%);
  --gradient-evening: linear-gradient(180deg, #001E5B 0%, #000B2E 100%);

  /* Spacing */
  --space-xs: 8px; --space-sm: 16px; --space-md: 24px;
  --space-lg: 32px; --space-xl: 48px; --space-2xl: 64px; --space-3xl: 96px;

  /* Radii */
  --radius-sm: 8px; --radius-md: 12px; --radius-lg: 16px; --radius-xl: 24px;

  /* Shadows */
  --shadow-sm: 0 2px 8px rgba(0, 0, 0, 0.08);
  --shadow-md: 0 4px 16px rgba(0, 0, 0, 0.12);
  --shadow-lg: 0 8px 24px rgba(0, 0, 0, 0.16);
  --shadow-glow: 0 0 20px rgba(6, 106, 254, 0.15);
}
```

**Headings:** `#001E5B` (Electric Blue 15) on light surfaces, `#FFFFFF` on dark gradients.
**If a color is not in this list, you cannot use it.** Period.

### Effects — Frosted Glass

Apply to headers, buttons, and cards. ALWAYS include `-webkit-backdrop-filter` for Safari.

```css
.glass { background: rgba(255,255,255,0.12); backdrop-filter: blur(20px); -webkit-backdrop-filter: blur(20px); border: 1px solid rgba(255,255,255,0.18); border-radius: var(--radius-lg); }
.glass-light { background: rgba(255,255,255,0.7); backdrop-filter: blur(16px); -webkit-backdrop-filter: blur(16px); border: 1px solid rgba(255,255,255,0.5); border-radius: var(--radius-md); }
.glass-dark { background: rgba(0,30,91,0.6); backdrop-filter: blur(20px); -webkit-backdrop-filter: blur(20px); border: 1px solid rgba(6,106,254,0.3); border-radius: var(--radius-lg); }
```

### Sparkles
- Place ONLY on left/right edges of sections. **NEVER centered.**
- Vary size (24-96px) and rotation randomly.
- Default palette: yellow + blue. Max 2 sparkle colors per page.
- ALWAYS use the original sparkle SVG/PNG files from `sf-assets/brand/sparkles/` — never redraw or substitute.
- Note filename inconsistencies: `Yellow Inclined.png` (not .svg), `Magent Inclined.png` (typo in source).

### Visual Density — Minimum Requirements
- **Every section MUST have at least 2 sparkles** (1 left edge + 1 right edge). Sections taller than 80vh should have 4+.
- **Vary sparkle sizes** within each section (min 28px, max 96px) — monotonous sizing looks template-y.
- **Decorative 3D icons or Agentforce balls** should appear in at least ONE section beyond the value cards. They add depth and brand warmth.
- If a page feels "empty" or "sad", the fix is ALWAYS more sparkles and decorative elements on the edges — never centered content filler.

### Characters
- **Astro** = friendly mascot (welcome, celebrations, CTAs)
- **Agent Astro** = sunglasses robot (AI / agentic / Agentforce contexts)
- Use contextually — not every page needs one, but include when it adds warmth.

### Images & Icons
- Frame photos through `Forms/Subtract-*.svg` shapes as CSS mask. Plain rectangles only for very complex images.
- **Person photos MUST use `object-position: top center`** — these are portrait crops. The face is always at the top. Without this, CSS `object-fit: cover` crops from center and shows torso/chest instead of the face.
- **When masking a GROUP of parallel items** (e.g., 3 personas in a row), use the SAME `Subtract-*.svg` for all of them. Mixing shapes on parallel items creates visual inconsistency. Only vary masks when items are intentionally asymmetric.
- **Prefer vertical Subtract masks** (viewBox ~200×215: Subtract-2, -3, -6, -7, -8) for person photos. Horizontal masks (viewBox ~290×155: Subtract, -1, -4, -5, -9) clip faces.
- Use 3D storytelling icons (`Acceleration-3D-Storytelling-Icon-preview *.png`) for value-prop bullets.
- Pull Product Logos when a specific Salesforce product is mentioned in the copy.

### Motion Graphics — CRITICAL
- Source files are `.mov` (Apple ProRes with alpha). **Browsers other than Safari CANNOT play .mov.**
- **ALWAYS convert to .mp4 before serving on web:**
  ```bash
  ffmpeg -i input.mov -c:v libx264 -pix_fmt yuv420p -movflags +faststart -an -preset fast output.mp4
  ```
- Use as `<video autoPlay loop muted playsInline>`. Never autoplay with sound.
- Add `prefers-reduced-motion` media query to pause/hide animations.
- .mov files with alpha channels lose transparency in .mp4 — use a dark background behind the video.
- **PREFER static character PNGs over converted .mp4 for hero sections.** The .mov→.mp4 conversion produces a black matte background that looks cheap unless the composition is specifically designed for it. Use `.mp4` only when the motion is the PRIMARY content (e.g., a product walkthrough, not a character floating). For character appearances in heroes/sections, use the 3D PNG renders — they have real transparency and look premium with `filter: drop-shadow()`.

### Logo
- Use ONLY `sf-assets/brand/logos/Salesforce Cloud - Primary.svg`
- **Never** recolor it with CSS filters.

### Layout
- Base composition on the SVGs in `sf-assets/brand/layout-examples/`
- Preserve Spanish/Portuguese accents in all text (transformação, geração, é, ñ, etc.)

---

## Step 0: Framework Choice

| Need | Choice | When |
|------|--------|------|
| **React + Vite** | Interactive apps, headless embeds, component reuse, complex state | Phase 4 Mode B (headless), React replicas, multi-page apps |
| **Vanilla HTML/CSS/JS** | Landing pages, demos, zero-build prototypes, single-file deliverables | Phase 4 Mode A (screenshot), expert briefs, scrolly-telling pages |

---

## Step 1: Visual Reference — See Before Building

Before replicating ANY Salesforce surface, get a visual reference.

**Source of Truth Principle:** The reference (slide, screenshot, or DESIGN.md) is GOSPEL for layout hierarchy, section rhythm, density, and first-viewport composition. You may adapt copy and content — you may NOT restructure the layout, flatten distinctive sections into generic grids, or change the visual density. If the reference has 3 columns, you build 3 columns. If it has a full-bleed hero, you keep it full-bleed.

### Option A: Google MCP (preferred)

Use `google__docs_get` with the presentation ID to SEE actual product screens:

| Surface | Presentation ID | What's Inside |
|---------|----------------|---------------|
| Official (Social, Commerce, Web, Email, Chatbot, Mobile) | `1lZ5NPDqo6XkQCb_OS2qVNpCod3DZMrFzA0LuBvpRLyg` | 7+ product screens with device frames |
| Agentforce (Chat, Builder, FINS/HLS/Auto) | `1RgfumMNO06SwZenewLDgBDVStN5brcYgtYlcWIPvJNo` | Agent chat panels, builder UI, industry variants |
| Data Cloud 360 (Mapping, Segments, Streams) | `1X-pEN3Ni_5EDumZuJyAJYQNq140zAtyc8VDHpCMYUt8` | Data mapping, segments, calculated insights |
| Slack (Threads, Search, DMs, Workflows) | `14woSdpLMGEu3zn-0ndaV-481D1cWJ_wAfUaorAlNkSo` | Slack UI surfaces |
| Journey Builder (Retail, HLS, FINS, Auto, MFG) | `18u2x71yzoPZYp45o3B6G023gbcZLPs4dNGLsXQN2uzc` | Marketing Cloud journey canvases |
| Retail B2C (Cart, Ads, Loyalty, Curbside) | `1FhttLyqejHfOajttQq-6y4HV-Qeb2EAVFo_mkk1Q7jo` | Abandoned cart, clienteling, loyalty |
| FINS (Personalization, Mobile, Lead Capture) | `1_MQwixDVZz3WWyW2HtO4n9lK3SKJ-W86ZOxU3BD9tBQ` | Financial services screens |
| FINS MC Advanced (Flow Builder, Campaign Agent) | `19ZOv4pHErLs08WqSb9hq9NEGE_7RvEeghph8CVbhTfA` | MC engagement for FINS |
| HLS (Veeva, Scheduler, Referrals) | `1Uh0hkEpVq6KFkaTd79tV9_5BkUuzCXOnkN16daowu-A` | Healthcare provider screens |
| HLS MC Engagement (Flow Builder, Lead Form) | `1uQwaaPOKzR-iJhGthvLMJHgR-NdqsrIyquZDrwVo_X4` | HLS marketing engagement |
| HLS Personalization (HCP, Patient Support) | `1QXt4hleuJ4EsCgdoH7kKYwqBfU77jRnXd3NLncb3e_s` | HCP views, clinical trials |
| Manufacturing (Agreements, Forecasting, Rebate) | `1sheYEM_5CrmF4Ek0ntB3MXVAj9DUtNuZ4ySvzp_eFQw` | Manufacturing B2B screens |
| Consumer Goods B2B (Retail Exec, Trade Promo) | `16jaaVc9AvmtRQOTDu0dmS_feXXcdb89wNDXqaf3iQ10` | CG retail execution, loyalty |
| Animated Personas (GIFs) | `1qdJ6v1MaE2Z78562wsc8lG4wUliTpuVWZ1_PVAWn_Ic` | People with motion |
| Animated Icon GIFs | `1w5fT2NimcRQaSdXz5TGs7TDy97kezQbefO4gZ8XfegI` | Product icons animated |

Also search with `google__docs_search` for specific screens (e.g., "Agentforce chat mobile").

### Option B: Ask the User

If Google MCP is unavailable or the presentation isn't accessible:
> "Necesito ver cómo luce [surface]. ¿Me podés compartir un screenshot del slide X de [presentation name], o exportar ese slide como PNG?"

### Option C: Playwright MCP Screenshots

For LIVE org surfaces not in slides, use Playwright MCP:
`browser_navigate` → `browser_take_screenshot` from the user's connected org.

---

## Step 2: Design Foundation

1. **Assets SF Brand** (`/brandkit`) — ALWAYS active (frosted glass, gradients, sparkles, Astro)
2. **TASTE skills** (`/design-taste-frontend`, `/high-end-visual-design`) — Design direction, anti-slop patterns, $150k agency-level quality
3. **UI/UX Pro Max** (`/ui-ux-pro-max`) — Layout and interaction patterns
4. **Emil Kowalski** (`/emil-design-eng`) — Micro-interaction philosophy, spring physics, invisible details

### SF Product Layout Anatomy (for React replicas)

What each Salesforce surface structurally IS:

| Surface | Layout | Key Structure | Mobile Collapse |
|---------|--------|---------------|-----------------|
| **Console (Service/Sales)** | Three-column split (list 25% \| record 50% \| sidebar 25%) | Compact header, split-view tabs, utility bar fixed bottom | Single column, utility bar → bottom nav |
| **Record Page** | Highlights panel (top) + 2-col grid (main 66% + sidebar 33%) | Record name as pill badges, action buttons right-aligned | Sidebar drops below main |
| **Agentforce Chat Panel** | Floating panel (400×600px), bottom-right fixed | Header (agent+avatar) → messages → typing indicator → input | Full-screen takeover |
| **Dashboard** | Filter bar top → responsive grid (2-4 columns) of widget cards | Chart card: title, viz area, metric footer | Single column, charts resize |
| **Experience Cloud Portal** | Full-width header → hero → card grid → footer | Theme-able via CSS variables, branded header/footer | Hamburger nav, stacked cards |
| **Flow Screen** | Centered card (max 640px), progress indicator top | Step title → field groups → Previous/Next buttons | Already narrow, removes padding |

---

## Step 2.5: Motion Intent — Feel Before Code

Before jumping to GSAP specifics, define the **motion personality** of the page. This guides implementation without prescribing it.

### Motion Intent Declaration

For each section, declare its motion **feel** using these dimensions:

| Dimension | Options | Example |
|-----------|---------|---------|
| **Entrance** | fade-up, masked-reveal, staggered-cascade, scale-in, none | Hero headline: masked-reveal |
| **Scroll behavior** | parallax-drift, pin-and-reveal, fade-through, sticky-progress | Value cards: staggered-cascade on scroll |
| **Hover/interact** | lift-shadow, glow-pulse, scale-subtle, color-shift | CTA button: lift-shadow + glow-pulse |
| **Ambient** | float, rotate-slow, pulse-breathe, shimmer, none | Sparkles: float + rotate-slow |
| **Pacing** | snappy (0.2-0.4s), smooth (0.5-0.8s), dramatic (1-1.5s) | Hero: dramatic entrance, snappy interactions |

### Rules
- **Hero gets the most motion budget** — dramatic entrance, then quiets down.
- **Each subsequent section reduces motion intensity** — the page "settles" as you scroll.
- **Effects are SUPPORTING layers** — behind content, secondary to interface. Never let WebGL/particles/canvas compete with text readability.
- **Ambient motion is continuous but subtle** — if you notice it consciously, it's too much.
- Declare intent FIRST, then pick the GSAP implementation that matches.

---

## Step 2.6: Page Guardrails — Lock What Must Not Change

After the initial design direction is set, generate 3-5 **page-specific guardrails** that protect the design's identity. These complement the global ANTI-PATTERNS with constraints unique to THIS page.

### Template

```markdown
## Guardrails for [Page Name]
1. [First viewport signal] — e.g., "The hero is a full-bleed gradient-evening with a single masked character. Do not add cards, text blocks, or secondary CTAs above the fold."
2. [Density lock] — e.g., "Section 2 has exactly 3 value cards at equal width. Do not add a 4th or collapse to 2+1."
3. [Color mode] — e.g., "This page alternates dark→light→dark. Do not insert consecutive same-mode sections."
4. [Focal object] — e.g., "Agent Astro is the ONLY character on this page. Do not add Codey or generic personas."
5. [Rhythm] — e.g., "Sections follow 80px padding cadence. Do not compress or stretch individual sections."
```

### When to Generate
- After user approves the initial design/wireframe concept
- Before any iteration or content swap
- Include in handoff if another agent or session continues the build

---

## Step 3: Implementation

1. **Apply CSS Architecture** — Sacred Visual System tokens (above) as foundation for ALL pages
2. **Apply Motion Intent** — Use Step 2.5 declarations to guide GSAP choices
3. **Apply GSAP** (`/gsap-core`, `/gsap-timeline`, `/gsap-scrolltrigger`) — animations and motion
4. **Apply Emil Kowalski** (`/emil-design-eng`) — micro-interactions, spring physics
5. **Apply Impeccable** (`/impeccable`) — final polish, run `/audit` or `/critique`
6. **For React replicas** — follow React Replica Methodology (below)

### React Replica Methodology

1. **Identify target surface** — Use Layout Anatomy table above
2. **Source reference** — Use Google MCP (Step 1) to SEE the real design, or check `figma-links.md`
3. **Build with SLDS 2** — Clone Starter Kit (`github.com/salesforce-ux-emu/design-system-2-starter-kit`), use its tokens/classes
4. **Data layer** — Static JSON for prototype mode; Apex REST via Heroku proxy for live data
5. **Polish** — Invoke `/impeccable` for audit pass

NEVER iframe Salesforce directly (X-Frame-Options: DENY). Always replica or Figma embed.

---

## Step 4: Asset Library — Full Inventory

All paths relative to `~/Documents/CLAUDE/sf-assets/`.

### Characters (PNG + Motion)

| Character | Static (PNG) | Motion (.mov → convert to .mp4!) | Use For |
|-----------|-------------|----------------------------------|---------|
| **Agent Astro** (robot) | `characters/agent-astro/Agent Astro 3D *.png` (5 angles) | `AgentAstro_StickerMoment_v18_2.mov`, `Agent_Astro_Sunglasses_Flying_v001.mov` | Agentforce hero, AI sections |
| **Astro** (bear mascot) | `characters/astro/Astro 3D - *.png` + `Astro SF 3D - *.png` (9 poses) | `ASTRO_Trailblazer_ClappingWalkLeft_DF20.mov`, `Astro-Sign-Alpha.mov` | Welcome, celebrations, CTAs |
| **Codey** (bear coder) | `characters/codey/CODEY_*.tif` (3 poses) | `Agent_Codey_Sunglasses_FlyingA_v001B.mov` | Developer sections, fun moments |
| **Agentforce ball** | `characters/agentforce/Agentforce-*.png` (5 variants) | — | Product icon, section markers |
| **Personas** (people) | `characters/personas/Carlos_*.png`, `Jose_*.png`, `Laura_*.png`, `Sara_*.png` | — | Demo story characters, user avatars |

### Brand Elements

| Asset | Path | Count |
|-------|------|-------|
| **Sparkles** | `brand/sparkles/Sparkles {Color} {Angle}.{png\|svg}` | 18 |
| **Gradients** | `brand/gradients/Gradient - {Morning\|Midday\|Evening\|Dusk}.svg` | 4 |
| **Forms (masks)** | `brand/forms/Subtract-{1-9}.svg` + `Subtract.svg` | 10 |
| **3D Icons** | `brand/icons/Acceleration-3D-Storytelling-Icon-preview {1-15}.png` | 15 |
| **Emojis** | `brand/icons/Emojii_*.png` | 12 |
| **Hand Gestures** | `brand/icons/Hand_*.png` + `Thumbs Up.png` | 5 |
| **Product Logos** | `brand/product-logos/{Product}.png` | 14 |
| **SF Logo** | `brand/logos/Salesforce Cloud - Primary.svg` | 1 |
| **Typography** | `brand/typography/*.woff` + `.woff2` | 7 |

### Device Frames & Screens

| Asset | Path |
|-------|------|
| **Figma Links Catalog** | `devices/screens/figma-links.md` — 50+ Figma prototypes + all Google Slides |
| **Laptop/Tablet/Phone frames** | `devices/frames/` |

---

## Step 5: Verification

1. **First Viewport Signal** — The hero sets the ENTIRE page tone. Verify: Does the above-the-fold area have ONE clear focal point? Is it diluted by competing elements? Would a user instantly know what this page is about?
2. **Section Rhythm** — Do sections maintain consistent padding cadence? Does density (cards per row, whitespace ratio) stay deliberate throughout? No "filler" sections that break the rhythm.
3. **Colors** — EVERY hex in the output must match the Sacred palette above. Grep for arbitrary hex values.
4. **Typography** — AvantGarde h1/h2, Salesforce Sans body. No other fonts.
5. **Frosted glass** — `-webkit-backdrop-filter` present alongside `backdrop-filter`.
6. **Sparkles** — Left/right edges ONLY. Never centered. Max 2 colors.
7. **Motion Intent Match** — Do animations match the declared motion intent from Step 2.5? Hero dramatic → body smooth → footer snappy progression preserved?
8. **Motion Files** — Files served as .mp4 (NOT .mov). `muted playsInline` attrs present.
9. **Viewport** — `min-h-[100dvh]` not `h-screen`.
10. **Responsive** — Desktop (>1024), tablet (768-1024), mobile (<768).
11. **Accessibility** — Contrast 4.5:1 on gradients, `aria-hidden` on sparkles, `prefers-reduced-motion` respected.
12. **Performance** — <3s load, no layout shift, fonts preloaded.
13. **Guardrails Check** — If page guardrails were generated (Step 2.6), verify NONE were violated during implementation.

---

## ANTI-PATTERNS — Never Do These

1. **NEVER dilute the first viewport signal** — the hero has ONE job: establish tone and communicate the page's purpose instantly. Do not clutter above-the-fold with competing CTAs, secondary nav, card grids, or decorative noise. If someone sees only the hero and nothing else, they should know exactly what this page is.
2. **NEVER flatten a reference into a generic card grid** — if you have a visual reference (Google Slides, screenshot, DESIGN.md), treat its hierarchy, density, and section rhythm as the source of truth. Adapt copy, never structure.
3. **NEVER build a "gallery of assets" or "showroom catalog"** — the assets exist to be USED in real web pages, not displayed as a collection. If asked to demo the skill, build a REAL page that uses the assets in context.
4. **NEVER serve .mov files on web** — always convert to .mp4 first. .mov only works in Safari.
5. **NEVER use a hex color not in the Sacred palette** — if you need a shade, use the closest palette value with opacity. (Unless project `DESIGN.md` overrides.)
6. **NEVER center sparkles** — left/right edges only, period.
7. **NEVER redraw sparkles or icons** — use the original files from sf-assets/.
8. **NEVER use h-screen** — use min-h-[100dvh] (mobile browser navbar).
9. **NEVER iframe Salesforce directly** — X-Frame-Options: DENY. Replicas or Figma embeds only.
10. **NEVER forget -webkit-backdrop-filter** — Safari won't render frosted glass without it.
11. **NEVER skip font preloading** — FOUT (flash of unstyled text) kills the premium feel.
12. **NEVER use stock fonts** — if AvantGarde/SalesforceSans aren't loading, fix the path. Don't fallback to system-ui for headings.
13. **NEVER use a 2+1 grid layout** (2 columns with orphan centered) for 3 items. Go straight from 1-col to 3-col at 768px. The orphan card always looks misaligned.
14. **NEVER crop person photos from center** — always `object-position: top center`. Showing someone's chest instead of face is not a "creative crop", it's a bug.
15. **NEVER use .mp4 converted from .mov as a hero element when the alpha channel matters** — the black matte background is visible and ugly. Use static PNGs with transparency instead.
16. **NEVER let WebGL/canvas/particles compete with text** — effects are atmospheric background layers. If you can't read the headline clearly with the effect running, the effect is too prominent.

---

## Step 6: Per-Project DESIGN.md (Optional Override)

For non-SF branded builds or client-specific overrides, generate a `DESIGN.md` at the project root. This file overrides Sacred Visual System tokens while preserving the skill's methodology.

### When to Generate
- Client has their own brand (non-SF landing page for a partner, event, or external audience)
- User explicitly says "not Salesforce branded" or provides a different palette
- Building a product replica that needs its own visual language

### Template

```yaml
---
version: "1.0"
name: "[Project Name]"
description: "[One-line purpose]"
colors:
  primary: "#hex"
  secondary: "#hex"
  accent: "#hex"
  background: "#hex"
  surface: "#hex"
  text-primary: "#hex"
  text-secondary: "#hex"
  border: "#hex"
typography:
  display:
    fontFamily: "[Font]"
    fontSize: "64px"
    fontWeight: 500
    lineHeight: "1.04"
  body:
    fontFamily: "[Font]"
    fontSize: "16px"
    fontWeight: 400
    lineHeight: "1.6"
  mono:
    fontFamily: "[Mono Font]"
    fontSize: "12px"
    fontWeight: 600
spacing:
  base: "8px"
  section-padding: "80px"
rounded:
  card: "12px"
  control: "8px"
  pill: "9999px"
motion-intent:
  hero: "dramatic masked-reveal, 1.2s"
  sections: "staggered fade-up, 0.6s"
  interactions: "lift-shadow, snappy 0.2s"
  ambient: "float sparkles, breathe glow"
---
# [Project Name]

## Composition
[Source of truth description — what the first viewport signal is, what hierarchy must be preserved]

## Guardrails
1. [Page-specific constraint]
2. [Page-specific constraint]
3. [Page-specific constraint]
```

### Rules
- When `DESIGN.md` exists in project root, its tokens OVERRIDE Sacred Visual System
- Methodology (Steps 1-5) still applies — only colors/fonts/spacing change
- Motion Intent from `DESIGN.md` takes precedence over Step 2.5 defaults
- If no `DESIGN.md` exists, Sacred Visual System is the default (SF brand)

---

## Deploy

- **Default:** Local dev (`vite dev` / `npx serve .`)
- **Heroku:** When headless embeds need a proxy backend (SF employee account, add basic auth)

---

## Sharing as QBranch Asset

To package this skill for other SEs:

1. **The skill file** — This SKILL.md goes in `.claude/skills/web-design/`
2. **The sf-assets zip** — `~/Documents/CLAUDE/sf-assets/` (152+ files). Distribute as `sf-assets.zip`
3. **Google MCP** — Each SE needs `plugin_google_google` MCP configured
4. **Sub-skills** — `/brandkit`, `/gsap-core`, `/gsap-timeline`, `/gsap-scrolltrigger`, `/design-taste-frontend`, `/high-end-visual-design`, `/ui-ux-pro-max`, `/emil-design-eng`, `/impeccable`
5. **Fonts** — Already in `sf-assets/brand/typography/`
6. **ffmpeg** — Required for .mov → .mp4 conversion (`brew install ffmpeg`)

Minimum viable: this SKILL.md + sf-assets.zip + Google MCP + ffmpeg.
