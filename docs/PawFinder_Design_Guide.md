# PawFinder Design Guide & UI System

> **Project:** PawFinder  
> **Platform:** Flutter (iOS & Android) + Flutter Web  
> **Purpose:** Complete visual and interaction guideline for developers and designers  
> **Date:** June 2026  
> **Version:** 1.0

---

## Table of Contents
1. [Design Philosophy](#1-design-philosophy)
2. [Color System](#2-color-system)
3. [Typography](#3-typography)
4. [Spacing & Layout](#4-spacing--layout)
5. [Component Library](#5-component-library)
6. [Iconography](#6-iconography)
7. [Motion & Animation](#7-motion--animation)
8. [Platform Adaptations](#8-platform-adaptations)
9. [Accessibility](#9-accessibility)
10. [Flutter Implementation](#10-flutter-implementation)
11. [Screen Specifications](#11-screen-specifications)
12. [Asset Guidelines](#12-asset-guidelines)

---

## 1. Design Philosophy

### Core Principles

| Principle | Description | In Practice |
|-----------|-------------|-------------|
| **Urgency with Empathy** | The app deals with emotional, time-sensitive situations. UI must feel urgent but never panic-inducing. | Red alerts use warm tones, not alarming bright red. Progress indicators are gentle. |
| **Trust through Transparency** | Users share sensitive information. Every screen must reinforce safety and privacy. | Lock icons, privacy badges, and clear data-use explanations are standard. |
| **Community Warmth** | This is a neighbor-helping-neighbor platform. The visual language should feel human, not corporate. | Rounded corners, friendly illustrations, warm color palette. |
| **Clarity under Stress** | A user whose pet is missing is stressed. Actions must be obvious and frictionless. | Large tap targets, clear hierarchy, minimal steps to critical actions. |
| **Celebrate Goodness** | Finding a pet is joyful. The app should celebrate these moments. | Confetti animations, warm success colors, shareable achievement cards. |

### Emotional Tone Map

```
PANIC ──────────────────────────────────────── JOY
   │                                              │
   │  [Alert Creation]        [Reunion Success]   │
   │     ↓ Stress                ↓ Elation        │
   │     ↓ Calm guidance         ↓ Celebration    │
   │                                              │
   └──────────────────────────────────────────────┘
              Trust & Safety (constant baseline)
```

---

## 2. Color System

### Primary Palette

| Name | Hex | RGB | Usage | Flutter Constant |
|------|-----|-----|-------|------------------|
| **Paw Orange** | `#FF6B35` | 255, 107, 53 | Primary actions, CTAs, FABs, urgent alerts | `AppColors.primary` |
| **Paw Orange Dark** | `#E55A2B` | 229, 90, 43 | Pressed states, hover, emphasis | `AppColors.primaryDark` |
| **Paw Orange Light** | `#FFF0E8` | 255, 240, 232 | Background tints, light badges, hover backgrounds | `AppColors.primaryLight` |

### Secondary Palette

| Name | Hex | RGB | Usage | Flutter Constant |
|------|-----|-----|-------|------------------|
| **Trust Teal** | `#4ECDC4` | 78, 205, 196 | Safety badges, verified indicators, success accents | `AppColors.secondary` |
| **Trust Teal Dark** | `#3BA99E` | 59, 169, 158 | Pressed states | `AppColors.secondaryDark` |
| **Trust Teal Light** | `#E8FAF8` | 232, 250, 248 | Light backgrounds, info banners | `AppColors.secondaryLight` |

### Semantic Colors

| Name | Hex | RGB | Usage | Flutter Constant |
|------|-----|-----|-------|------------------|
| **Success Green** | `#2ECC71` | 46, 204, 113 | Pet found, resolved alerts, positive actions | `AppColors.success` |
| **Success Green Light** | `#E8F9F0` | 232, 249, 240 | Success backgrounds, confirmation banners | `AppColors.successLight` |
| **Danger Red** | `#E74C3C` | 231, 76, 60 | Missing status, critical warnings, report abuse | `AppColors.danger` |
| **Danger Red Light** | `#FDEDEC` | 253, 237, 236 | Error backgrounds, validation messages | `AppColors.dangerLight` |
| **Reward Gold** | `#FFE66D` | 255, 230, 109 | Reward badges, coins, premium features | `AppColors.reward` |
| **Reward Gold Dark** | `#E5C84A` | 229, 200, 74 | Reward pressed states | `AppColors.rewardDark` |

### Neutral Palette

| Name | Hex | RGB | Usage | Flutter Constant |
|------|-----|-----|-------|------------------|
| **Ink 900** | `#1A1A2E` | 26, 26, 46 | Primary text, headings | `AppColors.ink900` |
| **Ink 700** | `#4A4A68` | 74, 74, 104 | Secondary text, labels | `AppColors.ink700` |
| **Ink 500** | `#8A8AA3` | 138, 138, 163 | Placeholder text, disabled states | `AppColors.ink500` |
| **Ink 300** | `#C8C8D8` | 200, 200, 216 | Borders, dividers, inactive icons | `AppColors.ink300` |
| **Ink 100** | `#E8E8F0` | 232, 232, 240 | Light borders, separators | `AppColors.ink100` |
| **Surface** | `#F7F7F9` | 247, 247, 249 | Page backgrounds, cards on dark | `AppColors.surface` |
| **Background** | `#FFFFFF` | 255, 255, 255 | Primary background | `AppColors.background` |
| **Dark Surface** | `#12121E` | 18, 18, 30 | Dark mode backgrounds | `AppColors.darkSurface` |

### Color Usage Rules

#### DO
- Use **Paw Orange** for the primary FAB ("+ Report Missing Pet")
- Use **Success Green** for "I Found This Pet" buttons
- Use **Trust Teal** for verification badges and privacy indicators
- Use **Reward Gold** sparingly — only for reward amounts and premium badges
- Maintain 60-30-10 rule: 60% neutral, 30% primary, 10% accent

#### DON'T
- Don't use pure red (`#FF0000`) — always use **Danger Red** (`#E74C3C`)
- Don't use **Paw Orange** for success states (use **Success Green**)
- Don't use more than 3 colors on a single card or button
- Don't use low-contrast color combinations (see Accessibility section)

### Dark Mode Mapping

| Light Mode | Dark Mode | Notes |
|------------|-----------|-------|
| Background `#FFFFFF` | Dark Surface `#12121E` | |
| Surface `#F7F7F9` | `#1E1E2E` | Elevated cards |
| Ink 900 `#1A1A2E` | `#FFFFFF` | Primary text inverts |
| Ink 700 `#4A4A68` | `#B8B8D1` | Secondary text |
| Paw Orange `#FF6B35` | `#FF8A5C` | Slightly lighter for visibility |
| Success Green `#2ECC71` | `#4ADE80` | Brighter in dark mode |

---

## 3. Typography

### Font Family

**Primary:** `Inter` (Google Fonts)  
**Fallback:** `system-ui`, `-apple-system`, `Roboto`, `sans-serif`

> **Rationale:** Inter is highly legible at small sizes, has excellent number rendering (critical for rewards/distances), and feels modern yet friendly. It supports a wide range of weights and is free for commercial use.

### Type Scale

| Token | Size | Weight | Line Height | Letter Spacing | Usage | Flutter Style |
|-------|------|--------|-------------|----------------|-------|---------------|
| **Display** | 32px | 700 (Bold) | 40px | -0.5px | Hero numbers, empty states | `displayLarge` |
| **H1** | 28px | 700 (Bold) | 36px | -0.5px | Screen titles, major headings | `headlineLarge` |
| **H2** | 24px | 600 (SemiBold) | 32px | -0.3px | Section headers, card titles | `headlineMedium` |
| **H3** | 20px | 600 (SemiBold) | 28px | -0.2px | Sub-sections, alert titles | `headlineSmall` |
| **Body Large** | 18px | 400 (Regular) | 28px | 0px | Primary body text, descriptions | `bodyLarge` |
| **Body** | 16px | 400 (Regular) | 24px | 0px | Standard body text | `bodyMedium` |
| **Body Small** | 14px | 400 (Regular) | 20px | 0px | Secondary text, metadata | `bodySmall` |
| **Caption** | 12px | 500 (Medium) | 16px | 0.2px | Labels, timestamps, badges | `labelSmall` |
| **Button** | 16px | 600 (SemiBold) | 24px | 0.3px | Button text | `labelLarge` |
| **Overline** | 11px | 700 (Bold) | 16px | 0.8px | All-caps labels, category tags | `labelMedium` |

### Typography Rules

#### Hierarchy Example
```
[Screen: Alert Detail]

H2: "Max" (Pet name)
Body Small: "Golden Retriever • Missing 2 hours ago"
Body: "Max is very friendly but may be scared. He has a blue collar with a tag. Last seen near Oak Street Park."
Caption: "2.3 km away • Reward: $100"
Button: "I Saw This Pet"
```

#### Text Color Rules
- **Primary text** (headings, body): Ink 900
- **Secondary text** (metadata, hints): Ink 700
- **Tertiary/Disabled**: Ink 500
- **Links/Actions**: Paw Orange
- **Success text**: Success Green (darker shade for readability)
- **Error text**: Danger Red

---

## 4. Spacing & Layout

### Spacing Scale (8px Base Grid)

| Token | Value | Usage | Flutter Constant |
|-------|-------|-------|------------------|
| **space-1** | 4px | Tight padding, icon gaps | `AppSpacing.xs` |
| **space-2** | 8px | Default element spacing | `AppSpacing.sm` |
| **space-3** | 12px | Small component padding | `AppSpacing.md` |
| **space-4** | 16px | Standard padding | `AppSpacing.lg` |
| **space-5** | 20px | Medium gaps | `AppSpacing.xl` |
| **space-6** | 24px | Section separation | `AppSpacing.xxl` |
| **space-8** | 32px | Large section gaps | `AppSpacing.xxxl` |
| **space-10** | 40px | Hero spacing | `AppSpacing.hero` |
| **space-12** | 48px | Major section breaks | `AppSpacing.section` |

### Layout Grid

- **Mobile:** 4-column grid, 16px margins, 12px gutters
- **Tablet:** 6-column grid, 24px margins, 16px gutters
- **Desktop/Web:** 12-column grid, 32px margins, 24px gutters

### Safe Areas & Insets

| Context | Value | Notes |
|---------|-------|-------|
| Screen horizontal padding | 16px | Default page padding |
| Card internal padding | 16px | Standard card padding |
| Card internal padding (compact) | 12px | List items, small cards |
| Bottom sheet corner radius | 24px (top only) | iOS-style bottom sheets |
| Dialog corner radius | 16px | All corners |
| Button border radius | 12px | Standard buttons |
| Pill/chip border radius | 999px | Fully rounded |
| FAB border radius | 16px | Floating action buttons |

### Elevation & Shadows

| Level | Shadow | Usage | Flutter Equivalent |
|-------|--------|-------|---------------------|
| **Level 0** | None | Flat elements, inputs | `BoxShadow` none |
| **Level 1** | `0 1px 3px rgba(26,26,46,0.08)` | Cards at rest, buttons | `elevation: 1` |
| **Level 2** | `0 2px 8px rgba(26,26,46,0.10)` | Hover states, expanded cards | `elevation: 2` |
| **Level 3** | `0 4px 16px rgba(26,26,46,0.12)` | FABs, modals, bottom sheets | `elevation: 3` |
| **Level 4** | `0 8px 24px rgba(26,26,46,0.14)` | Dialogs, full-screen overlays | `elevation: 4` |

---

## 5. Component Library

### 5.1 Buttons

#### Primary Button (Paw Orange)
```
Background: Paw Orange (#FF6B35)
Text: White (#FFFFFF), Button weight (16px, SemiBold)
Height: 56px (minimum touch target)
Padding: 0 24px
Border Radius: 12px
Shadow: Level 1 (rest), Level 2 (pressed)
Disabled: Background Ink 300, text Ink 500
```

**Usage:** "Report Missing Pet", "Submit Alert", "Send Message"

#### Secondary Button (Outlined)
```
Background: Transparent
Border: 1.5px solid Ink 300
Text: Ink 900, Button weight
Height: 56px
Padding: 0 24px
Border Radius: 12px
Pressed: Background Ink 100
Disabled: Border Ink 100, text Ink 500
```

**Usage:** "Cancel", "Skip", "Later"

#### Success Button (Green)
```
Background: Success Green (#2ECC71)
Text: White
Height: 56px
Border Radius: 12px
Shadow: Level 1
```

**Usage:** "I Found This Pet", "Mark as Resolved", "Confirm Reunion"

#### Danger Button (Red)
```
Background: Danger Red (#E74C3C)
Text: White
Height: 56px
Border Radius: 12px
```

**Usage:** "Report Scam", "Delete Account", "Cancel Alert"

#### FAB (Floating Action Button)
```
Size: 64px x 64px (circular or rounded square)
Background: Paw Orange
Icon: White, 24px
Shadow: Level 3
Position: Bottom-right, 24px from edges
```

**Usage:** Primary action on map/list screens

#### Text Button
```
Background: Transparent
Text: Paw Orange, Body weight
Underline: None (use color to indicate action)
Padding: 8px 12px
Pressed: Paw Orange Light background
```

**Usage:** "View Details", "Edit", "See More"

#### Icon Button
```
Size: 48px x 48px (touch target)
Background: Transparent (or Surface for contained)
Icon: Ink 700 (default), Ink 900 (active)
Border Radius: 12px (or 999px for circular)
Pressed: Ink 100 background
```

### 5.2 Cards

#### Alert Card (Primary)
```
Background: Background (#FFFFFF)
Border Radius: 16px
Shadow: Level 1
Padding: 16px
Internal Layout:
  ┌─────────────────────────────────────┐
  │ [Photo]  [Species Badge]  [Time]    │  ← Top row
  │ [Pet Name]        [Distance]        │  ← Title row
  │ [Description snippet...]            │  ← Body
  │ [Reward Badge]  [Action Button]     │  ← Bottom row
  └─────────────────────────────────────┘
```

**Photo:** 80px x 80px, border radius 12px, object-fit cover  
**Species Badge:** Pill shape, background Primary Light, text Primary Dark, Caption size  
**Time:** Caption, Ink 500  
**Pet Name:** H3, Ink 900  
**Distance:** Caption, Ink 700 with location icon  
**Description:** Body Small, Ink 700, max 2 lines, ellipsis overflow  
**Reward Badge:** Pill, background Reward Gold Light, text Reward Gold Dark, with coin icon  
**Action Button:** Small primary button (height 40px) or text button

#### Sighting Card
```
Background: Background
Border Radius: 16px
Border Left: 4px solid Trust Teal
Shadow: Level 1
Padding: 16px
```

**Visual cue:** Teal left border indicates "new sighting"  
**Content:** Finder alias, timestamp, photo thumbnail, location, action buttons

#### Stat Card (Dashboard)
```
Background: Background
Border Radius: 16px
Shadow: Level 1
Padding: 20px
Width: Flexible (min 140px)
```

**Content:** Large number (Display size), label (Caption), trend indicator (optional)  
**Color coding:** Active = Danger Red, Resolved = Success Green, Avg Time = Trust Teal

#### Info Banner
```
Background: Trust Teal Light (or variant based on type)
Border Radius: 12px
Padding: 12px 16px
Icon: 20px, left-aligned
Text: Body Small, Ink 700
```

**Types:**
- **Info:** Trust Teal Light + Trust Teal icon
- **Success:** Success Green Light + Success Green icon
- **Warning:** Reward Gold Light + Reward Gold Dark icon
- **Error:** Danger Red Light + Danger Red icon

### 5.3 Inputs

#### Text Field
```
Background: Surface (#F7F7F9)
Border: 1px solid Ink 100
Border Radius: 12px
Height: 56px
Padding: 0 16px
Text: Body, Ink 900
Placeholder: Body, Ink 500
Focus: Border Paw Orange, shadow Level 1
Error: Border Danger Red, background Danger Red Light
Icon: 24px, Ink 500 (left or right)
```

#### Text Area
```
Same as Text Field
Height: 120px (min), expands to content
Padding: 16px
```

#### Search Field
```
Background: Surface
Border Radius: 12px (or 999px for pill style)
Height: 48px
Left Icon: Search icon, Ink 500
Right Icon: Clear button (when text present)
```

#### Dropdown / Selector
```
Background: Surface
Border: 1px solid Ink 100
Border Radius: 12px
Height: 56px
Trailing Icon: Chevron down, Ink 500
```

### 5.4 Chips & Badges

#### Filter Chip
```
Background: Surface (inactive) / Paw Orange (active)
Border: 1px solid Ink 100 (inactive) / none (active)
Border Radius: 999px
Height: 36px
Padding: 0 16px
Text: Caption, Ink 700 (inactive) / White (active)
Icon: 16px, optional prefix
```

#### Status Badge
```
Border Radius: 8px
Padding: 4px 10px
Text: Caption, weight 600
```

| Status | Background | Text |
|--------|------------|------|
| Active | Danger Red Light | Danger Red |
| Resolved | Success Green Light | Success Green |
| Pending | Reward Gold Light | Reward Gold Dark |
| Verified | Trust Teal Light | Trust Teal |

#### Reward Badge
```
Background: Reward Gold Light
Border Radius: 8px
Padding: 4px 10px
Text: Caption, Reward Gold Dark, weight 600
Prefix Icon: Coin/star, 14px
```

### 5.5 Navigation

#### Bottom Navigation Bar
```
Background: Background (#FFFFFF)
Border Top: 1px solid Ink 100
Height: 64px + safe area
Items: 5 max
Icon: 24px, Ink 500 (inactive) / Paw Orange (active)
Label: Caption, same color logic
Active Indicator: None (use color change only)
```

**Items:** Home, Alerts, Report (center FAB), Messages, Profile

#### Top App Bar
```
Background: Background (or transparent on map screens)
Height: 56px
Title: H3, Ink 900 (left-aligned, default)
Actions: Icon buttons, right-aligned
Elevation: 0 (flat) or Level 1 (scrolled)
```

**Variants:**
- **Standard:** Title + actions
- **Contextual:** Colored background (Paw Orange or Trust Teal) + white text
- **Search:** Search field embedded in app bar

#### Tab Bar
```
Background: Background
Indicator: 2px line, Paw Orange
Label: Body, weight 500
Active: Ink 900
Inactive: Ink 500
```

### 5.6 Lists

#### Standard List Item
```
Background: Background
Padding: 16px
Divider: 1px solid Ink 100 (bottom, indented 72px if leading image)
Leading: 48px avatar/image, border radius 12px
Title: Body, Ink 900
Subtitle: Body Small, Ink 700
Trailing: Caption, Ink 500, or action icon
```

#### List Item (Selectable)
```
Same as standard
Selected: Background Primary Light, leading icon checkmark
```

### 5.7 Dialogs & Bottom Sheets

#### Confirmation Dialog
```
Background: Background
Border Radius: 16px
Padding: 24px
Max Width: 320px (mobile), 400px (tablet)
Shadow: Level 4
```

**Content:** Icon (48px, centered), H2 title, Body text, 2 buttons (primary + secondary)

#### Bottom Sheet
```
Background: Background
Border Radius: 24px (top corners only)
Padding: 24px 24px 32px 24px
Handle: 36px x 4px, Ink 300, centered at top
Shadow: Level 4 (top only)
Max Height: 85% of screen
```

**Content:** Drag handle, title, scrollable content, action buttons (sticky bottom)

#### Snackbar / Toast
```
Background: Ink 900
Border Radius: 12px
Padding: 12px 16px
Text: Body, White
Action: Text button, Paw Orange
Position: Bottom, 24px from bottom nav
Duration: 3 seconds (auto-dismiss)
```

---

## 6. Iconography

### Icon Style
- **Style:** Outlined (line weight 1.5px), rounded corners
- **Size:** 24px (standard), 20px (compact), 48px (empty states)
- **Color:** Ink 700 (default), Ink 900 (active), Paw Orange (action), semantic colors (status)
- **Library:** `phosphor_flutter` (Phosphor Icons) — modern, consistent, extensive pet/community icons

### Core Icon Set

| Icon | Name | Usage | Size |
|------|------|-------|------|
| 🐕 | `PhosphorIcons.dog` | Species indicator | 24px |
| 🐈 | `PhosphorIcons.cat` | Species indicator | 24px |
| 📍 | `PhosphorIcons.mapPin` | Location, distance | 20px |
| 🔔 | `PhosphorIcons.bell` | Notifications | 24px |
| 🔍 | `PhosphorIcons.magnifyingGlass` | Search | 24px |
| ✕ | `PhosphorIcons.x` | Close, dismiss | 24px |
| ← | `PhosphorIcons.arrowLeft` | Back | 24px |
| 📸 | `PhosphorIcons.camera` | Photo upload | 24px |
| 💬 | `PhosphorIcons.chatCircle` | Messages | 24px |
| 👤 | `PhosphorIcons.user` | Profile | 24px |
| 🏠 | `PhosphorIcons.house` | Home | 24px |
| ⚠️ | `PhosphorIcons.warning` | Alert, warning | 24px |
| ✅ | `PhosphorIcons.checkCircle` | Success, verified | 24px |
| 🔒 | `PhosphorIcons.lockKey` | Privacy, secure | 20px |
| 🏆 | `PhosphorIcons.trophy` | Rewards, achievements | 24px |
| 🔄 | `PhosphorIcons.arrowsClockwise` | Refresh, update | 24px |
| 📤 | `PhosphorIcons.shareNetwork` | Share | 24px |
| ❤️ | `PhosphorIcons.heart` | Save, favorite | 24px |
| 🎯 | `PhosphorIcons.crosshair` | Current location | 24px |
| 📋 | `PhosphorIcons.clipboardText` | Report, details | 24px |

### Custom Icons (SVG/PNG)
- Paw print logo (app icon, splash screen)
- Pet species silhouettes (for map markers)
- Badge illustrations (achievement system)
- Empty state illustrations (no alerts, no messages)

---

## 7. Motion & Animation

### Animation Principles
- **Purposeful:** Every animation guides attention or provides feedback
- **Quick:** Most animations complete within 300ms (users are often stressed)
- **Consistent:** Same motion language across the app
- **Respectful:** No bouncing, wiggling, or playful animations on alert screens

### Standard Durations

| Context | Duration | Easing | Flutter Curve |
|---------|----------|--------|---------------|
| Button press | 100ms | `ease-out` | `Curves.easeOut` |
| Color transition | 200ms | `ease-in-out` | `Curves.easeInOut` |
| Page transition | 300ms | `ease-out` | `Curves.easeOutCubic` |
| Bottom sheet | 300ms | `ease-out` | `Curves.easeOutCubic` |
| Dialog open | 250ms | `ease-out` | `Curves.easeOutBack` (subtle) |
| List item enter | 150ms | `ease-out` | `Curves.easeOut` |
| Skeleton loading | 1200ms | `ease-in-out` | `Curves.easeInOut` (loop) |
| Success celebration | 800ms | `ease-out` | `Curves.easeOut` |
| Map pin drop | 400ms | `bounce` | `Curves.bounceOut` |

### Page Transitions

#### Default (Mobile)
```
Slide from right (enter)
Slide to right (exit)
Duration: 300ms
```

**Flutter:** `MaterialPageRoute` (default) or custom `PageTransitionSwitcher`

#### Bottom Sheet (Modal)
```
Slide from bottom (enter)
Fade background overlay (opacity 0 → 0.5)
Duration: 300ms
```

#### Dialog
```
Scale from 0.9 → 1.0 + fade in
Duration: 250ms
```

### Micro-interactions

#### Button Press
```
Scale: 1.0 → 0.97
Opacity: 1.0 → 0.9
Duration: 100ms
Release: Snap back with 100ms ease-out
```

#### Card Tap
```
Elevation: Level 1 → Level 2
Duration: 150ms
Release: Return to Level 1
```

#### Pull-to-Refresh
```
Indicator: Trust Teal spinner
Success: Brief checkmark flash
Duration: 1500ms typical
```

#### Loading States

**Skeleton Screen:**
```
Background: Ink 100
Shimmer: Linear gradient sweep (white at 20% opacity)
Duration: 1200ms loop
Border Radius: match content (12px for cards)
```

**Spinner:**
```
Style: CircularProgressIndicator
Color: Paw Orange
Size: 24px (inline), 48px (full screen)
Stroke Width: 3px
```

### Success Animations

#### Reunion Celebration
```
Trigger: Owner marks alert as resolved
Animation:
  1. Checkmark scale + fade (300ms)
  2. Confetti burst (800ms, 20 particles)
  3. Success message slide up (300ms)
  4. Badge award pop (400ms, slight bounce)
```

**Flutter:** `Confetti` package or custom `CustomPainter`  
**Tone:** Warm, celebratory, not overly playful (respect the emotional moment)

---

## 8. Platform Adaptations

### iOS vs Android (Flutter Considerations)

| Element | iOS Style | Android Style | Flutter Implementation |
|---------|-----------|---------------|---------------------|
| **Back Button** | Chevron left (`<`) in app bar | Arrow back (system) | `Platform.isIOS` check in custom app bar |
| **Bottom Nav** | Labels always visible | Labels on active only | `BottomNavigationBar` with `type: BottomNavigationBarType.fixed` for iOS |
| **Status Bar** | Dark icons on light bg | System handles | `SystemChrome.setSystemUIOverlayStyle` |
| **Scroll Physics** | Bouncing overscroll | Clamping overscroll | `BouncingScrollPhysics` vs `ClampingScrollPhysics` |
| **Dialogs** | Centered, rounded | Edge-to-edge bottom sheets | `Platform.isIOS` to choose `CupertinoAlertDialog` vs `AlertDialog` |
| **Switch** | Rounded, sliding thumb | Material with ripple | `Switch.adaptive` (Flutter handles automatically) |
| **Page Transition** | Slide from right | Shared element/fade | `PageTransitionsTheme` in `ThemeData` |

### Platform-Specific Colors

| Context | iOS | Android | Notes |
|---------|-----|---------|-------|
| System Status Bar | Default | Default | Let system handle, ensure contrast |
| Navigation Bar (gesture) | Transparent | System color | Use `SystemUiMode.edgeToEdge` |
| Keyboard Appearance | Light/Dark match | System default | `SystemChrome.setSystemUIOverlayStyle` |

### Flutter Theme Configuration

```dart
// Platform-adaptive theme
final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  colorScheme: ColorScheme.fromSeed(
    seedColor: AppColors.primary,
    brightness: Brightness.light,
  ),
  scaffoldBackgroundColor: AppColors.background,
  textTheme: AppTypography.textTheme,
  appBarTheme: AppBarTheme(
    elevation: 0,
    centerTitle: Platform.isIOS, // iOS centers, Android left-aligns
    backgroundColor: AppColors.background,
    foregroundColor: AppColors.ink900,
    systemOverlayStyle: SystemUiOverlayStyle.dark,
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    type: Platform.isIOS 
      ? BottomNavigationBarType.fixed 
      : BottomNavigationBarType.shifting,
    selectedItemColor: AppColors.primary,
    unselectedItemColor: AppColors.ink500,
    backgroundColor: AppColors.background,
    elevation: 2,
  ),
  cardTheme: CardTheme(
    elevation: 1,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      minimumSize: const Size(double.infinity, 56),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      textStyle: AppTypography.button,
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.surface,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: AppColors.ink100),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: AppColors.primary, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: AppColors.danger),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
  ),
  pageTransitionsTheme: PageTransitionsTheme(
    builders: {
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
    },
  ),
);
```

---

## 9. Accessibility

### WCAG 2.1 AA Compliance Targets

| Requirement | Target | Implementation |
|-------------|--------|----------------|
| **Contrast** | 4.5:1 for text, 3:1 for UI components | All color pairs verified in Figma/Flutter |
| **Touch Targets** | 48px x 48px minimum | Buttons 56px, icons 48px, spacing 8px between |
| **Text Scaling** | Support 200% zoom | Use `MediaQuery.textScaleFactor`, flexible layouts |
| **Screen Readers** | Full VoiceOver/TalkBack support | All images labeled, buttons described, states announced |
| **Focus Indicators** | Visible focus rings | 2px Paw Orange outline on focused elements |
| **Motion** | Respect `prefers-reduced-motion` | Disable animations when system setting is on |

### Contrast Ratios (Verified)

| Foreground | Background | Ratio | Pass AA? |
|------------|------------|-------|----------|
| Ink 900 `#1A1A2E` | Background `#FFFFFF` | 14.8:1 | ✅ |
| Ink 700 `#4A4A68` | Background `#FFFFFF` | 7.2:1 | ✅ |
| White `#FFFFFF` | Paw Orange `#FF6B35` | 3.8:1 | ✅ (large text) |
| White `#FFFFFF` | Paw Orange `#FF6B35` | 3.8:1 | ⚠️ (small text — use Paw Orange Dark `#E55A2B` for 4.6:1) |
| Ink 900 `#1A1A2E` | Surface `#F7F7F9` | 12.1:1 | ✅ |
| Danger Red `#E74C3C` | Background `#FFFFFF` | 5.7:1 | ✅ |
| Trust Teal `#4ECDC4` | Background `#FFFFFF` | 2.1:1 | ❌ (don't use for text on white — use Trust Teal Dark `#3BA99E` for 3.2:1) |

### Screen Reader Labels

```dart
// Example: Alert card accessibility
Semantics(
  label: 'Missing pet alert: Max, Golden Retriever, missing 2 hours ago, 2.3 kilometers away, 100 dollar reward',
  button: true,
  child: GestureDetector(
    onTap: () => navigateToAlertDetail(),
    child: AlertCard(...),
  ),
)

// Example: FAB
Semantics(
  label: 'Report a missing pet',
  button: true,
  child: FloatingActionButton(...),
)
```

### Reduced Motion

```dart
// Check system preference
final bool reduceMotion = MediaQuery.of(context).disableAnimations;

// Apply in animations
AnimatedContainer(
  duration: reduceMotion ? Duration.zero : Duration(milliseconds: 300),
  // ...
)
```

---

## 10. Flutter Implementation

### Complete Color Constants

```dart
// lib/core/theme/app_colors.dart
import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary
  static const Color primary = Color(0xFFFF6B35);
  static const Color primaryDark = Color(0xFFE55A2B);
  static const Color primaryLight = Color(0xFFFFF0E8);

  // Secondary
  static const Color secondary = Color(0xFF4ECDC4);
  static const Color secondaryDark = Color(0xFF3BA99E);
  static const Color secondaryLight = Color(0xFFE8FAF8);

  // Semantic
  static const Color success = Color(0xFF2ECC71);
  static const Color successLight = Color(0xFFE8F9F0);
  static const Color danger = Color(0xFFE74C3C);
  static const Color dangerLight = Color(0xFFFDEDEC);
  static const Color reward = Color(0xFFFFE66D);
  static const Color rewardDark = Color(0xFFE5C84A);
  static const Color rewardLight = Color(0xFFFFFBE8);

  // Neutral
  static const Color ink900 = Color(0xFF1A1A2E);
  static const Color ink700 = Color(0xFF4A4A68);
  static const Color ink500 = Color(0xFF8A8AA3);
  static const Color ink300 = Color(0xFFC8C8D8);
  static const Color ink100 = Color(0xFFE8E8F0);
  static const Color surface = Color(0xFFF7F7F9);
  static const Color background = Color(0xFFFFFFFF);
  static const Color darkSurface = Color(0xFF12121E);

  // Dark mode variants
  static Color primaryDarkMode = const Color(0xFFFF8A5C);
  static Color successDarkMode = const Color(0xFF4ADE80);
}
```

### Typography Implementation

```dart
// lib/core/theme/app_typography.dart
import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTypography {
  AppTypography._();

  static const String fontFamily = 'Inter';

  static TextTheme get textTheme => TextTheme(
    displayLarge: _display,
    headlineLarge: _h1,
    headlineMedium: _h2,
    headlineSmall: _h3,
    bodyLarge: _bodyLarge,
    bodyMedium: _body,
    bodySmall: _bodySmall,
    labelLarge: _button,
    labelMedium: _overline,
    labelSmall: _caption,
  );

  static const TextStyle _display = TextStyle(
    fontFamily: fontFamily,
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: 1.25, // 40px line height
    letterSpacing: -0.5,
    color: AppColors.ink900,
  );

  static const TextStyle _h1 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 28,
    fontWeight: FontWeight.w700,
    height: 1.29,
    letterSpacing: -0.5,
    color: AppColors.ink900,
  );

  static const TextStyle _h2 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 1.33,
    letterSpacing: -0.3,
    color: AppColors.ink900,
  );

  static const TextStyle _h3 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.4,
    letterSpacing: -0.2,
    color: AppColors.ink900,
  );

  static const TextStyle _bodyLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w400,
    height: 1.56,
    color: AppColors.ink900,
  );

  static const TextStyle _body = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: AppColors.ink900,
  );

  static const TextStyle _bodySmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.43,
    color: AppColors.ink700,
  );

  static const TextStyle _caption = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.33,
    letterSpacing: 0.2,
    color: AppColors.ink500,
  );

  static const TextStyle _button = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.5,
    letterSpacing: 0.3,
    color: Colors.white,
  );

  static const TextStyle _overline = TextStyle(
    fontFamily: fontFamily,
    fontSize: 11,
    fontWeight: FontWeight.w700,
    height: 1.45,
    letterSpacing: 0.8,
    color: AppColors.ink500,
  );
}
```

### Spacing Constants

```dart
// lib/core/theme/app_spacing.dart
import 'package:flutter/material.dart';

class AppSpacing {
  AppSpacing._();

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;
  static const double xxxl = 32;
  static const double hero = 40;
  static const double section = 48;

  // EdgeInsets helpers
  static const EdgeInsets pagePadding = EdgeInsets.all(lg);
  static const EdgeInsets cardPadding = EdgeInsets.all(lg);
  static const EdgeInsets listItemPadding = EdgeInsets.symmetric(
    horizontal: lg,
    vertical: md,
  );
}
```

### Reusable Components

```dart
// lib/presentation/widgets/app_button.dart
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';

enum AppButtonType { primary, secondary, success, danger, text }

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final AppButtonType type;
  final IconData? icon;
  final bool isLoading;
  final bool isFullWidth;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = AppButtonType.primary,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = true,
  });

  @override
  Widget build(BuildContext context) {
    final (bgColor, fgColor, borderColor) = _getColors();

    Widget child = isLoading
      ? SizedBox(
          height: 24,
          width: 24,
          child: CircularProgressIndicator(
            strokeWidth: 3,
            valueColor: AlwaysStoppedAnimation<Color>(fgColor),
          ),
        )
      : Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 20, color: fgColor),
              const SizedBox(width: AppSpacing.sm),
            ],
            Text(
              text,
              style: AppTypography.textTheme.labelLarge?.copyWith(
                color: fgColor,
              ),
            ),
          ],
        );

    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      height: 56,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          foregroundColor: fgColor,
          elevation: type == AppButtonType.text ? 0 : 1,
          shadowColor: type == AppButtonType.text 
            ? Colors.transparent 
            : AppColors.ink900.withOpacity(0.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: borderColor != null 
              ? BorderSide(color: borderColor, width: 1.5)
              : BorderSide.none,
          ),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
        ),
        child: child,
      ),
    );
  }

  (Color, Color, Color?) _getColors() {
    switch (type) {
      case AppButtonType.primary:
        return (AppColors.primary, Colors.white, null);
      case AppButtonType.secondary:
        return (Colors.transparent, AppColors.ink900, AppColors.ink300);
      case AppButtonType.success:
        return (AppColors.success, Colors.white, null);
      case AppButtonType.danger:
        return (AppColors.danger, Colors.white, null);
      case AppButtonType.text:
        return (Colors.transparent, AppColors.primary, null);
    }
  }
}
```

```dart
// lib/presentation/widgets/alert_card.dart
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';

class AlertCard extends StatelessWidget {
  final String petName;
  final String species;
  final String timeMissing;
  final String distance;
  final String? description;
  final String? reward;
  final String imageUrl;
  final VoidCallback onTap;
  final VoidCallback? onActionTap;

  const AlertCard({
    super.key,
    required this.petName,
    required this.species,
    required this.timeMissing,
    required this.distance,
    this.description,
    this.reward,
    required this.imageUrl,
    required this.onTap,
    this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shadowColor: AppColors.ink900.withOpacity(0.08),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: AppSpacing.cardPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top row: Image + Meta
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Pet photo
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      imageUrl,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 80,
                        height: 80,
                        color: AppColors.surface,
                        child: const Icon(Icons.pets, color: AppColors.ink300),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.lg),
                  // Meta info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Species badge + time
                        Row(
                          children: [
                            _buildBadge(species, AppColors.primaryLight, AppColors.primaryDark),
                            const SizedBox(width: AppSpacing.sm),
                            Text(
                              timeMissing,
                              style: AppTypography.textTheme.labelSmall,
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        // Pet name
                        Text(
                          petName,
                          style: AppTypography.textTheme.headlineSmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        // Distance
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              size: 14,
                              color: AppColors.ink500,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              distance,
                              style: AppTypography.textTheme.labelSmall,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              // Description
              if (description != null) ...[
                const SizedBox(height: AppSpacing.md),
                Text(
                  description!,
                  style: AppTypography.textTheme.bodySmall,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              // Bottom row: Reward + Action
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  if (reward != null) ...[
                    _buildBadge(
                      '🏆 $reward',
                      AppColors.rewardLight,
                      AppColors.rewardDark,
                    ),
                    const Spacer(),
                  ] else ...[
                    const Spacer(),
                  ],
                  TextButton(
                    onPressed: onActionTap,
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.sm,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'I Saw This Pet',
                      style: AppTypography.textTheme.labelLarge?.copyWith(
                        color: AppColors.primary,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBadge(String text, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: AppTypography.textTheme.labelSmall?.copyWith(
          color: textColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
```

---

## 11. Screen Specifications

### 11.1 Home Dashboard

```
┌─────────────────────────────────────────┐
│ [≡]  Downtown Seattle • 2km      [🔔] │  ← App Bar (56px)
├─────────────────────────────────────────┤
│                                         │
│  ┌─────────────────────────────────┐    │
│  │ ⚠️  3 pets missing near you     │    │  ← Hero Banner (64px)
│  │     Tap to view and help        │    │
│  └─────────────────────────────────┘    │
│                                         │
│  ╔═══════════════════════════════════╗  │
│  ║                                   ║  │
│  ║         [MAP VIEW]                ║  │  ← Map (flexible height)
│  ║     📍     🐕      🐈            ║  │
│  ║                                   ║  │
│  ║     [🎯 My Location]              ║  │
│  ╚═══════════════════════════════════╝  │
│                                         │
│  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━  │  ← Drag Handle (24px)
│  ┌─────────────────────────────────┐  │
│  │ [🐕] Max        Golden Retriever│  │  ← Alert Card 1
│  │      2.3km • 2h ago    [🏆$100]│  │
│  └─────────────────────────────────┘  │
│  ┌─────────────────────────────────┐  │
│  │ [🐈] Luna       Tabby Cat       │  │  ← Alert Card 2
│  │      1.1km • 5h ago             │  │
│  └─────────────────────────────────┘  │
│  ┌─────────────────────────────────┐  │
│  │ [🐕] Buddy      Beagle          │  │  ← Alert Card 3
│  │      3.5km • 1d ago    [🏆$50] │  │
│  └─────────────────────────────────┘  │
│                                         │
│         ┌─────────┐                     │
│         │ + Report│  ← FAB (64px)       │
│         │ Missing │     Paw Orange      │
│         └─────────┘                     │
│                                         │
├─────────────────────────────────────────┤
│ [🏠] [🔍]    [📋]    [💬]   [👤]     │  ← Bottom Nav (64px)
└─────────────────────────────────────────┘
```

**Key Details:**
- App bar: Transparent over map, solid white when scrolled past map
- Hero banner: Trust Teal Light background, Trust Teal icon, H3 title + Body Small subtitle
- Map: Google Maps, custom pet markers (48px), clustering at zoom levels < 12
- Bottom sheet: Draggable, snaps to 35% (peek) and 85% (expanded)
- FAB: 64px, Paw Orange, white "+" icon, 24px from right, 24px above bottom nav
- Bottom nav: 5 items, center is "Report" (raised icon, Paw Orange)

### 11.2 Create Alert Wizard

```
┌─────────────────────────────────────────┐
│ [←]  Report Missing Pet          [1/5] │  ← App Bar
├─────────────────────────────────────────┤
│                                         │
│  Which pet is missing?                  │  ← H2
│                                         │
│  ┌─────────────────────────────────┐  │
│  │ [🐕] Max                        │  │  ← Selectable Card
│  │ Golden Retriever • 3 years old  │  │
│  │              [✓]                │  │
│  └─────────────────────────────────┘  │
│                                         │
│  ┌─────────────────────────────────┐  │
│  │ [🐈] Luna                       │  │
│  │ Tabby Cat • 2 years old         │  │
│  │              [○]                │  │
│  └─────────────────────────────────┘  │
│                                         │
│  ───────────  OR  ───────────           │
│                                         │
│  ┌─────────────────────────────────┐  │
│  │  [+] Add a new pet profile      │  │  ← Secondary Button
│  └─────────────────────────────────┘  │
│                                         │
│         ┌───────────────────────┐       │
│         │    Continue →         │       │  ← Primary Button
│         └───────────────────────┘       │
│                                         │
└─────────────────────────────────────────┘
```

**Step Indicators:**
- Step 1: Select Pet
- Step 2: Last Location (map pin + address search)
- Step 3: Details (when, circumstances, temperament)
- Step 4: Reward (optional, suggested amounts)
- Step 5: Review & Submit (privacy reminder)

**Step Progress:** Linear progress indicator at top (5 segments), or stepper dots

### 11.3 Alert Detail (Community View)

```
┌─────────────────────────────────────────┐
│ [←]                          [⋮] [🔔]  │  ← App Bar (transparent over image)
├─────────────────────────────────────────┤
│ ┌─────────────────────────────────────┐ │
│ │                                     │ │
│ │      [Pet Photo Carousel]           │ │  ← Hero Image (240px)
│ │         🐕 Max                       │ │
│ │                                     │ │
│ └─────────────────────────────────────┘ │
│                                         │
│  ┌─────────────────────────────────┐    │
│  │ 🔒 Your contact info is hidden │    │  ← Privacy Banner
│  │ Only you can start a chat.     │    │
│  └─────────────────────────────────┘    │
│                                         │
│  Max                                    │  ← H1
│  Golden Retriever • Missing 2 hours ago │  ← Body, Ink 700
│                                         │
│  Last seen near Oak Street Park        │  ← Body Large
│  (approximate location shown)          │
│                                         │
│  Description:                           │  ← H3
│  Max is very friendly but may be       │  ← Body
│  scared. He has a blue collar with     │
│  a tag. He responds to treats.         │
│                                         │
│  ┌─────────────────────────────────┐    │
│  │ ⚠️ Never send money upfront.    │    │  ← Safety Banner
│  │ Rewards are handled in-app.    │    │
│  └─────────────────────────────────┘    │
│                                         │
│  ┌─────────────────────────────────┐    │
│  │ 🏆 Reward: $100                 │    │  ← Reward Card
│  │ Guaranteed by PawFinder         │    │
│  └─────────────────────────────────┘    │
│                                         │
│  Recent Sightings (2)                   │  ← H3
│  ┌─────────────────────────────────┐    │
│  │ [👤] HelpfulHank • 30 min ago   │    │  ← Sighting Card
│  │ "Saw a similar dog near Market"│    │
│  │ [View Details]                  │    │
│  └─────────────────────────────────┘    │
│                                         │
│         ┌───────────────────────┐       │
│         │   📸 I Saw This Pet   │       │  ← Success Button
│         └───────────────────────┘       │
│                                         │
└─────────────────────────────────────────┘
```

### 11.4 Secure Messaging

```
┌─────────────────────────────────────────┐
│ [←] Conversation about Max      [⋮]    │  ← App Bar
├─────────────────────────────────────────┤
│                                         │
│  ┌─────────────────────────┐            │
│  │ Hi, I think I saw Max   │            │  ← Finder Message (left)
│  │ near the park on 5th.   │            │
│  │ I have a photo.        │ 10:23 AM   │
│  └─────────────────────────┘            │
│                                         │
│            ┌─────────────────────────┐  │
│            │ Can you share the photo?│  │  ← Owner Message (right)
│            │ And your location?     │  │
│            │                   10:25 │  │
│            └─────────────────────────┘  │
│                                         │
│  ┌─────────────────────────┐            │
│  │ [📷 Photo]              │            │  ← Image Message
│  │ 5th & Pine St          │ 10:26 AM   │
│  └─────────────────────────┘            │
│                                         │
│  ┌─────────────────────────────────┐    │
│  │ 🔒 Your phone and email are     │    │  ← Safety Footer (sticky)
│  │ hidden. Stay in-app to stay safe│    │
│  └─────────────────────────────────┘    │
│                                         │
│  ┌──────────────────────────────────┐   │
│  │ [📷] [📍] Type a message... [➤]│   │  ← Input Bar
│  └──────────────────────────────────┘   │
│                                         │
└─────────────────────────────────────────┘
```

**Message Bubbles:**
- Finder (left): Surface background, Ink 900 text, 12px border radius
- Owner (right): Primary Light background, Ink 900 text, 12px border radius
- Images: Full width within bubble, 12px border radius, tap to expand
- Timestamps: Caption, Ink 500, aligned to bottom of bubble

### 11.5 Metrics Dashboard (Public)

```
┌─────────────────────────────────────────┐
│ [←]  Community Impact            [⋮]    │  ← App Bar
├─────────────────────────────────────────┤
│                                         │
│  1,247 pets reunited 🎉                 │  ← Display, centered
│  since launch in June 2026              │  ← Body, Ink 700
│                                         │
│  ┌──────────┐ ┌──────────┐ ┌──────────┐ │
│  │   42     │ │   38     │ │  18h     │ │  ← Stat Cards
│  │ Active   │ │ Resolved │ │ Avg Time │ │
│  │  today   │ │ this week│ │ to find  │ │
│  └──────────┘ └──────────┘ └──────────┘ │
│                                         │
│  [📈 Trend Chart: Alerts vs Resolved]   │  ← Line Chart
│                                         │
│  Recent Success Stories                 │  ← H2
│  ┌─────────────────────────────────┐   │
│  │ [🐕] Max reunited with Sarah!   │   │  ← Story Card
│  │     "Thank you to everyone who   │   │
│  │      helped look for Max!"       │   │
│  │     — Seattle, 2 days ago       │   │
│  └─────────────────────────────────┘   │
│                                         │
│  Top Rescuers This Month                │  ← H2
│  1. 🥇 HelpfulHank     12 reunions     │  ← Leaderboard
│  2. 🥈 PetDetective     8 reunions     │
│  3. 🥉 ShelterAngel     7 reunions     │
│                                         │
└─────────────────────────────────────────┘
```

---

## 12. Asset Guidelines

### 12.1 App Icon

**Primary Icon:** Stylized paw print with location pin integration
- **Shape:** Adaptive (Android) + Squircle (iOS)
- **Background:** Paw Orange gradient (top-left `#FF6B35`, bottom-right `#E55A2B`)
- **Foreground:** White paw print with subtle location pin negative space
- **Sizes:** 1024x1024 (base), exported to all platform sizes

**Adaptive Icon (Android):**
- Background layer: Gradient
- Foreground layer: Paw icon
- Safe zone: 66px from edges on 108px canvas

### 12.2 Splash Screen

**iOS:**
- Background: Paw Orange
- Center: White paw icon (120px)
- Below: "PawFinder" in Inter Bold, white, 24px
- Minimum display: 2 seconds

**Android:**
- Use `flutter_native_splash` package
- Same design as iOS
- Branded launch window (API 31+)

### 12.3 Illustrations (Empty States)

| Screen | Illustration | Style |
|--------|-------------|-------|
| No Alerts Nearby | Dog looking at empty map | Flat, warm colors, 200px |
| No Messages | Two people with speech bubbles | Flat, friendly, 180px |
| No Pets Added | Person with pet outline | Flat, inviting, 200px |
| Success/Reunion | Person hugging pet with confetti | Flat, celebratory, 240px |
| Error/Offline | Sad pet with disconnected wifi | Flat, empathetic, 180px |

**Style:** Flat vector, 2D, no gradients, rounded shapes, warm color palette matching app colors

### 12.4 Map Markers

| Type | Icon | Size | Color |
|------|------|------|-------|
| Missing Dog | Dog silhouette | 48px | Danger Red |
| Missing Cat | Cat silhouette | 48px | Danger Red |
| Missing Other | Paw print | 48px | Danger Red |
| Sighting Report | Eye icon | 36px | Trust Teal |
| My Location | Crosshair | 32px | Paw Orange |
| Shelter | Building icon | 40px | Ink 700 |

**Selected State:** Scale 1.2x, add white ring border (4px), elevation shadow

### 12.5 Image Handling

**Pet Photos:**
- Upload: Max 5MB, JPEG/PNG
- Display: 400x400 (thumbnail), 800x800 (detail), 1200x1200 (full screen)
- Aspect Ratio: 1:1 (square crop) or 4:3 (landscape)
- Compression: 80% quality JPEG
- Placeholder: Paw icon on Surface background

**User Avatars:**
- Size: 48px (list), 64px (profile), 120px (settings)
- Shape: Circle
- Fallback: Initials on colored background (generated from user ID)

---

## Appendix A: Flutter Theme Quick Reference

```dart
// Complete theme setup in main.dart

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: AppColors.background,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const PawFinderApp());
}

class PawFinderApp extends StatelessWidget {
  const PawFinderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PawFinder',
      debugShowCheckedModeBanner: false,
      theme: _buildLightTheme(),
      darkTheme: _buildDarkTheme(),
      themeMode: ThemeMode.system, // Respect OS setting
      home: const SplashScreen(),
    );
  }

  ThemeData _buildLightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.light,
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        error: AppColors.danger,
        surface: AppColors.surface,
        background: AppColors.background,
      ),
      scaffoldBackgroundColor: AppColors.background,
      textTheme: AppTypography.textTheme,
      fontFamily: AppTypography.fontFamily,
      // ... (all component themes from Section 10)
    );
  }

  ThemeData _buildDarkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryDarkMode,
        brightness: Brightness.dark,
        primary: AppColors.primaryDarkMode,
        secondary: AppColors.secondary,
        error: AppColors.danger,
        surface: const Color(0xFF1E1E2E),
        background: AppColors.darkSurface,
      ),
      scaffoldBackgroundColor: AppColors.darkSurface,
      textTheme: AppTypography.textTheme.apply(
        bodyColor: Colors.white,
        displayColor: Colors.white,
      ),
      fontFamily: AppTypography.fontFamily,
    );
  }
}
```

---

## Appendix B: Design Checklist for Developers

Before submitting any screen for review, verify:

- [ ] All colors use `AppColors` constants (no hardcoded hex values)
- [ ] All text uses `AppTypography` styles (no manual font sizes)
- [ ] All spacing uses `AppSpacing` values (no magic numbers)
- [ ] Touch targets are minimum 48px x 48px
- [ ] Images have loading placeholders and error states
- [ ] Empty states have illustrations and helpful copy
- [ ] Loading states use skeleton screens (not just spinners)
- [ ] Error states are informative and offer recovery actions
- [ ] Screen works in both portrait and landscape (where applicable)
- [ ] Screen respects system font size (accessibility)
- [ ] Screen respects dark mode
- [ ] Screen respects reduced motion preference
- [ ] All interactive elements have visible focus states
- [ ] All images have semantic labels for screen readers
- [ ] Bottom nav and FAB don't obscure content (padding added)
- [ ] Keyboard doesn't obscure input fields (ScrollView + padding)
- [ ] Back navigation works correctly (physical button + gesture)
- [ ] Deep links navigate to correct screen state

---

*Document Version: 1.0*  
*Last Updated: June 2026*  
*Maintained by: Product & Design Team*  
*Questions? Tag @design-system in Slack*
