# PawFinder — Enhanced UI/UX Design System v2.0

> **Purpose:** Escape the "vibecoded" Material Design 3 aesthetic and establish a distinctive, warm, human-centered visual identity befitting a community pet recovery platform.
>
> **Status:** Design blueprint — supersedes the visual identity portions of `PawFinder_Design_Guide.md` v1.0. The original guide's UX principles, component functionality, accessibility standards, and screen specs remain valid. This document redefines the *visual expression* of those specs.
>
> **Date:** June 2026

---

## 0. Diagnosis: What Makes It "Vibecoded"

The existing design guide is thorough and the UX principles are sound. But the visual execution falls into well-known AI-design traps:

| Symptom | Why It's a Problem | Severity |
|---------|-------------------|----------|
| **Inter font** | The single most overused font in AI-generated interfaces. Zero personality. | 🔴 Critical |
| **Pure white backgrounds** (`#FFFFFF`) | Clinical, cold, corporate. No warmth, no atmosphere. Feels like a SaaS dashboard. | 🔴 Critical |
| **Generic Material Design 3** | Rounded corners, elevation shadows, standard Material widgets. Indistinguishable from a thousand tutorial apps. | 🟠 High |
| **No texture or atmosphere** | Flat color surfaces everywhere. A lost-pet app should feel human, not sterile. | 🟠 High |
| **Standard Phosphor icons only** | Fine as a base, but no custom visual identity. The app has no "face." | 🟡 Medium |
| **Emoji as illustration** | `🐕`, `🐈`, `🎉` — emojis look amateurish in production apps. | 🟡 Medium |
| **Generic animation language** | "300ms ease-out" for everything. No personality in motion. | 🟡 Medium |
| **Cold dark mode** | `#12121E` is blue-cold. A community warmth app should darken to warm charcoal, not cold slate. | 🟡 Medium |

**The irony:** The design guide's philosophy section is genuinely good — "Urgency with Empathy," "Community Warmth," "Celebrate Goodness." But none of it *looks* like anything. The visual language is pure Material Design 3 defaults with an orange primary color swapped in.

---

## 1. Design Direction: "The Warm Signal"

### The Concept

When a pet goes missing, communities don't open apps — they put up flyers on notice boards, under street lamps, on weathered wooden posts. They knock on doors. They call out names in the dark.

**PawFinder should feel like that physical, human, community experience — translated into a trustworthy digital tool.**

Not "tech platform." Not "SaaS dashboard with dog emojis." 

**Community bulletin board meets modern craft.**

### The Feeling

| Context | Emotional State | Visual Response |
|---------|----------------|-----------------|
| Pet just went missing | Panic, urgency | Clear, prominent CTAs. Warm amber urgency, not red alarm. Paper-textured backgrounds feel grounding. |
| Searching / browsing alerts | Hopeful, determined | Comfortable information density. Card-based browsing with gentle visual rhythm. |
| Receiving a sighting | Excitement, cautious hope | Teal-tinted "good news" treatments. Gentle celebration, never over-promising. |
| Pet found / reunited | Joy, relief, gratitude | Rich celebration. Confetti particles, warm golden glow, shareable moment. |
| General browsing | Community participation | Warm, human, slightly textured. Like a well-loved community center, not a hospital. |

### The One Thing People Will Remember

**The paw-print loading indicator.** When the app loads, a small paw print "walks" across the screen — four gentle impressions that fade in sequence, like a pet walking through soft ground. It's small, warm, unmistakably PawFinder, and no other app does it.

---

## 2. Typography: Two Warm Voices

### The Problem with Inter

Inter is a *technical* font. It was designed for screens, for legibility at small sizes, for developer tools. It has no warmth, no personality, no emotion. It says "operating system," not "community helping each other find lost pets."

### The New System

```
DISPLAY VOICE — headings, hero text, CTAs
─────────────────────────────────────────────
Font: "Outfit" (Google Fonts, OFL license)
Weights: 400, 500, 600, 700
Character: Rounded geometric with warmth. Friendly but not childish.
           Distinctive without being distracting.
           Letters have a gentle softness — like rounded pebbles.

BODY VOICE — paragraphs, descriptions, metadata
─────────────────────────────────────────────
Font: "Plus Jakarta Sans" (Google Fonts, OFL license)
Weights: 300, 400, 500, 600, 700
Character: Warm humanist sans-serif with excellent readability.
           Slightly more personality than Inter without being loud.
           Alternates: DM Sans (more neutral) or Nunito Sans (more rounded).

DATA VOICE — numbers, distances, rewards, times
─────────────────────────────────────────────
Font: Plus Jakarta Sans with tabular figures enabled
      (fontFeatures: [FontFeature.tabularFigures()])
Character: Numbers must align perfectly in columns.
           Distances, times, and rewards use this voice.
           No separate monospace needed — Plus Jakarta Sans has excellent numerals.
```

### Type Scale (unchanged sizes, new fonts)

```dart
// lib/core/theme/app_typography.dart (UPDATED)

class AppTypography {
  AppTypography._();

  static const String fontDisplay = 'Outfit';
  static const String fontBody = 'PlusJakartaSans';

  // Display sizes (Outfit)
  static TextStyle get displayLarge => GoogleFonts.outfit(
    fontSize: 32.sp, fontWeight: FontWeight.w700,
    height: 1.2, letterSpacing: -0.5, color: AppColors.ink900,
  );
  
  static TextStyle get h1 => GoogleFonts.outfit(
    fontSize: 22.sp, fontWeight: FontWeight.w700,
    height: 1.3, letterSpacing: -0.3, color: AppColors.ink900,
  );
  
  static TextStyle get h2 => GoogleFonts.outfit(
    fontSize: 18.sp, fontWeight: FontWeight.w600,
    height: 1.35, color: AppColors.ink900,
  );
  
  static TextStyle get h3 => GoogleFonts.outfit(
    fontSize: 16.sp, fontWeight: FontWeight.w600,
    height: 1.4, color: AppColors.ink900,
  );

  // Body sizes (Plus Jakarta Sans)
  static TextStyle get bodyLarge => GoogleFonts.plusJakartaSans(
    fontSize: 16.sp, fontWeight: FontWeight.w400,
    height: 1.5, color: AppColors.ink700,
  );
  
  static TextStyle get body => GoogleFonts.plusJakartaSans(
    fontSize: 14.sp, fontWeight: FontWeight.w400,
    height: 1.5, color: AppColors.ink700,
  );
  
  static TextStyle get bodySmall => GoogleFonts.plusJakartaSans(
    fontSize: 12.sp, fontWeight: FontWeight.w400,
    height: 1.5, color: AppColors.ink500,
  );

  // Button text (Outfit — consistent with headings)
  static TextStyle get button => GoogleFonts.outfit(
    fontSize: 14.sp, fontWeight: FontWeight.w600,
    height: 1.2, letterSpacing: 0.5, color: Colors.white,
  );

  // Caption (Plus Jakarta Sans)
  static TextStyle get caption => GoogleFonts.plusJakartaSans(
    fontSize: 11.sp, fontWeight: FontWeight.w500,
    height: 1.4, letterSpacing: 0.2, color: AppColors.ink500,
  );

  // Label (Plus Jakarta Sans)
  static TextStyle get label => GoogleFonts.plusJakartaSans(
    fontSize: 13.sp, fontWeight: FontWeight.w500,
    height: 1.4, color: AppColors.ink700,
  );
}
```

### Typography Rules

1. **Headings always use Outfit.** Page titles, card titles, section headers, button labels.
2. **Body always uses Plus Jakarta Sans.** Descriptions, metadata, timestamps, form inputs.
3. **Numbers use Plus Jakarta Sans with `tabularFigures`.** All distances, times, reward amounts.
4. **Never mix fonts within a single text widget.** A heading with inline data should be split into two widgets.
5. **Weight hierarchy is strict:** h1=700, h2=600, h3=600, body=400, caption=500, button=600.

### pubspec.yaml Addition

```yaml
dependencies:
  google_fonts: ^6.1.0  # Add this
```

Fonts are loaded via `google_fonts` package — no asset files needed.

---

## 3. Color System: Warmth over Sterility

### The Problem with the Current Palette

The existing palette uses `#FFFFFF` (pure white) as background. White backgrounds are:
- Cold and clinical (hospitals, not communities)
- High contrast but zero atmosphere
- The default of every generic app ever made
- Exhausting to look at for extended periods (glare)

### The New Palette

```
SURFACE HIERARCHY — warm, paper-inspired
═══════════════════════════════════════════
--paper:       #FFFBF5    ← Page backgrounds. Warm cream, like community notice board paper.
                            Slight yellow undertone. Not white. Never white.
--card:        #FFF5EB    ← Elevated surfaces, cards. Slightly deeper cream.
--card-hover:  #FFEFDF    ← Interactive card hover state.
--overlay:     #FFF0E3    ← Modal backgrounds, bottom sheets.

--paper-dark:  #1A1815    ← Dark mode background. Warm charcoal, not cold blue-black.
--card-dark:   #24211D    ← Dark mode cards. Slightly lighter warm charcoal.

PRIMARY — warm, energetic, trustworthy
═══════════════════════════════════════════
--clay:        #E8612D    ← Primary actions, CTAs. Warmer and richer than the old #FF6B35.
                            "Sun-baked clay" — earthy, grounded, unmistakable.
--clay-dark:   #C94E1F    ← Pressed states, hover.
--clay-light:  #FFF0E8    ← Tinted backgrounds, badges.

SECONDARY — calm, trustworthy, reassuring
═══════════════════════════════════════════
--sage:        #5B9A8B    ← Trust indicators, success states, verified badges.
                            "Sage green" — calmer and more natural than teal.
--sage-dark:   #457A6E    ← Pressed states.
--sage-light:  #EBF5F2    ← Light backgrounds, info banners.

SEMANTIC — status communication
═══════════════════════════════════════════
--success:     #4CAF83    ← Pet found, resolved alerts.
--success-bg:  #EDF7F1    ← Success backgrounds.
--danger:      #E0554A    ← Missing status, critical warnings. Warmer than pure red.
--danger-bg:   #FDF0EE    ← Error backgrounds.
--reward:      #E8A840    ← Rewards, achievements. Rich gold, not bright yellow.
--reward-bg:   #FFF8ED    ← Reward backgrounds.

TEXT — readable, warm
═══════════════════════════════════════════
--ink-primary:    #2D241F    ← Primary text. Very dark warm brown, not cold black.
--ink-secondary:  #6B5F57    ← Secondary text. Warm grey-brown.
--ink-tertiary:   #9C9088    ← Placeholder, disabled. Warm light grey.
--ink-inverse:    #FFFBF5    ← Text on dark/clay backgrounds.

BORDER & DIVIDER
═══════════════════════════════════════════
--border:        #E8E0D8    ← Subtle warm borders.
--border-focus:  #E8612D    ← Focused input borders (clay).
--divider:       #F0E8E0    ← Even subtler dividers.
```

### Color Comparison: Old vs New

| Role | Old (v1.0) | New (v2.0) | Change |
|------|-----------|-----------|--------|
| Background | `#FFFFFF` (snow white) | `#FFFBF5` (warm paper) | 🟢 Warmer, less clinical |
| Surface | `#F7F7F9` (cool grey) | `#FFF5EB` (cream) | 🟢 Actually warm, not grey |
| Primary | `#FF6B35` (bright orange) | `#E8612D` (clay) | 🟢 Richer, more grounded |
| Secondary | `#4ECDC4` (bright teal) | `#5B9A8B` (sage) | 🟢 Calmer, more natural |
| Text | `#1A1A2E` (cold navy-black) | `#2D241F` (warm brown-black) | 🟢 Softer on eyes |
| Dark bg | `#12121E` (cold blue-black) | `#1A1815` (warm charcoal) | 🟢 Community, not terminal |

### Flutter Implementation

```dart
// lib/core/theme/app_colors.dart (UPDATED)

class AppColors {
  AppColors._();

  // ── Primary: Warm Clay ──
  static const Color primary = Color(0xFFE8612D);
  static const Color primaryDark = Color(0xFFC94E1F);
  static const Color primaryLight = Color(0xFFFFF0E8);

  // ── Secondary: Calm Sage ──
  static const Color secondary = Color(0xFF5B9A8B);
  static const Color secondaryDark = Color(0xFF457A6E);
  static const Color secondaryLight = Color(0xFFEBF5F2);

  // ── Semantic ──
  static const Color success = Color(0xFF4CAF83);
  static const Color successLight = Color(0xFFEDF7F1);
  static const Color danger = Color(0xFFE0554A);
  static const Color dangerLight = Color(0xFFFDF0EE);
  static const Color reward = Color(0xFFE8A840);
  static const Color rewardLight = Color(0xFFFFF8ED);

  // ── Surface: Warm Paper ──
  static const Color paper = Color(0xFFFFFBF5);       // Background (was background)
  static const Color card = Color(0xFFFFF5EB);        // Cards, elevated surfaces (was surface)
  static const Color cardHover = Color(0xFFFFEFDF);
  static const Color overlay = Color(0xFFFFF0E3);

  // ── Dark Mode Surfaces ──
  static const Color paperDark = Color(0xFF1A1815);   // Dark background
  static const Color cardDark = Color(0xFF24211D);    // Dark cards

  // ── Ink: Warm Text ──
  static const Color ink900 = Color(0xFF2D241F);      // Primary text (warm brown-black)
  static const Color ink700 = Color(0xFF6B5F57);      // Secondary text (was #4A4A68)
  static const Color ink500 = Color(0xFF9C9088);      // Tertiary text

  // ── Borders ──
  static const Color border = Color(0xFFE8E0D8);
  static const Color borderFocus = Color(0xFFE8612D);
  static const Color divider = Color(0xFFF0E8E0);
}
```

### Key Color Rules

1. **Never use pure `#FFFFFF`.** Always use `AppColors.paper` for backgrounds.
2. **Never use pure `#000000`.** Always use `AppColors.ink900` for dark text.
3. **Clay orange is for ONE primary action per screen max.** Not every button.
4. **Sage green signals trust, safety, and resolution.** Use for verified badges, found-pet states.
5. **Warm ink colors reduce eye strain** compared to pure black on white.
6. **Dark mode is warm, not cold.** `#1A1815` feels like a cozy room at night, not a server terminal.

---

## 4. Atmosphere & Texture

This is the single biggest differentiator from v1.0. The original design is flat. Flat is dead.

### 4.1 Background Texture

Every screen has a subtle paper texture. Not a heavy pattern — a barely-perceptible grain that makes the app feel physical:

```dart
// lib/presentation/widgets/textured_background.dart

class TexturedBackground extends StatelessWidget {
  final Widget child;
  const TexturedBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Base color
        Container(color: AppColors.paper),
        // Subtle noise texture
        Positioned.fill(
          child: Opacity(
            opacity: 0.015,
            child: CustomPaint(
              painter: _NoisePainter(),
            ),
          ),
        ),
        // Content
        child,
      ],
    );
  }
}

class _NoisePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = AppColors.ink900;
    final random = Random(42); // Seeded for consistency
    for (int i = 0; i < (size.width * size.height * 0.002); i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final alpha = random.nextInt(30);
      paint.color = AppColors.ink900.withOpacity(alpha / 255.0);
      canvas.drawCircle(Offset(x, y), 0.5, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
```

### 4.2 Card Depth

Cards don't use generic Material `elevation` shadows. They use a soft, warm, directional shadow that feels like paper on paper:

```dart
// Card decoration pattern
BoxDecoration(
  color: AppColors.card,
  borderRadius: BorderRadius.circular(16),
  boxShadow: [
    BoxShadow(
      color: AppColors.ink900.withOpacity(0.04),  // Very subtle
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ],
  border: Border.all(
    color: AppColors.border,
    width: 0.5,  // Hairline warm border, not stark
  ),
)
```

**Key:** Shadows use warm ink color (`#2D241F`), not black. This makes shadows feel like natural ambient occlusion, not UI overlays.

### 4.3 Paw Print Motif

Subtle paw-print patterns appear as decorative elements — never as primary UI:

- **Empty states:** A soft, large, low-opacity paw print behind the empty state illustration
- **Loading indicator:** The paw-print walking animation
- **Splash screen:** Paw print logo with gentle scale animation
- **Achievement badges:** Small paw print icon as part of badge design

The paw print is rendered as a custom SVG path, not an emoji:

```dart
// lib/presentation/widgets/paw_print.dart

class PawPrint extends StatelessWidget {
  final double size;
  final Color color;
  final double opacity;
  
  const PawPrint({
    super.key,
    this.size = 24,
    this.color = AppColors.primary,
    this.opacity = 0.1,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _PawPrintPainter(color.withOpacity(opacity)),
    );
  }
}

class _PawPrintPainter extends CustomPainter {
  final Color color;
  _PawPrintPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    
    final scale = size.width / 100;
    
    // Main pad
    canvas.drawPath(
      _roundedPath(
        Offset(50 * scale, 55 * scale),
        18 * scale,
        14 * scale,
      ),
      paint,
    );
    
    // Four toe pads
    for (final offset in [
      Offset(28 * scale, 25 * scale),
      Offset(50 * scale, 15 * scale),
      Offset(72 * scale, 25 * scale),
      Offset(60 * scale, 35 * scale),
    ]) {
      canvas.drawPath(
        _roundedPath(offset, 8 * scale, 12 * scale),
        paint,
      );
    }
  }

  Path _roundedPath(Offset center, double rx, double ry) {
    return Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromCenter(center: center, width: rx * 2, height: ry * 2),
        Radius.circular(rx),
      ));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
```

### 4.4 Custom Empty State Illustrations

Replace emoji-based placeholders with custom-drawn illustrations:

```dart
// lib/presentation/widgets/empty_state_illustration.dart

enum EmptyStateType {
  noAlerts,     // A dog looking at an empty map
  noMessages,   // Two speech bubbles, one dotted (waiting)
  noPets,       // A person with a pet-shaped outline
  celebration,  // Person hugging pet, confetti
  offline,      // Pet with disconnected signal icon
}

class EmptyStateIllustration extends StatelessWidget {
  final EmptyStateType type;
  final double height;
  
  // ... renders a CustomPaint widget with the appropriate vector art
}
```

These illustrations use the app color palette and have a unified style: flat 2D, rounded shapes, warm colors, no gradients, line weight 2px.

---

## 5. Animation & Motion Language

### 5.1 The Problem with v1.0

The original guide says "150ms ease-out for everything." That's not a motion language — it's a default. Motion should feel intentional and match the emotional context.

### 5.2 The PawFinder Motion Language

```
CLAY MOTION — grounded, warm, slightly weighty
──────────────────────────────────────────────
Use for: Page transitions, card reveals, content loading
Curve: Cubic(0.4, 0.0, 0.2, 1.0)  ← Custom ease-out with weight
Duration: 350–450ms
Feel: Like setting down a warm ceramic mug — deliberate, satisfying

SAGE MOTION — calm, reassuring, gentle
──────────────────────────────────────────────
Use for: Success states, verification badges, "found pet" moments
Curve: Cubic(0.2, 0.0, 0.0, 1.0)  ← Gentle deceleration
Duration: 500–800ms
Feel: Like a calm exhale — nothing rushed, nothing alarming

PAW MOTION — playful, light, friendly
──────────────────────────────────────────────
Use for: Micro-interactions, button presses, badge awards
Curve: Curves.easeOutBack  ← Slight overshoot
Duration: 200–300ms
Feel: Like a friendly nudge — small moments of delight

ALERT MOTION — clear, direct, urgent but not panicked
──────────────────────────────────────────────
Use for: Error states, missing alerts, critical notifications
Curve: Cubic(0.3, 0.0, 1.0, 1.0)  ← Quick entry, firm stop
Duration: 200–250ms
Feel: Knocking on a door — attention-getting but not alarming
```

### 5.3 Signature Animations

#### Paw Print Loading Indicator

```dart
class PawPrintLoader extends StatefulWidget {
  // A sequence of 4 paw prints that "walk" from left to right
  // Each paw print fades in and scales up in sequence
  // Total cycle: 1200ms, repeating
  // Used on splash screen and full-page loading states
}
```

#### Card Entry Stagger

```dart
// Alert cards on the home screen enter one at a time
// Each card: 350ms clay motion, 80ms stagger between cards
// Cards slide up 16px + fade in
// Direction: bottom to top (cards "rise" into view)
```

#### Reunion Celebration

```dart
// When an alert is marked as resolved:
// 1. Card pulses sage green (400ms)
// 2. Checkmark scales in with overshoot (500ms paw motion)
// 3. Confetti particles burst from center (800ms, 30 particles)
// 4. "Reunited!" banner slides down from top (400ms)
// 5. Share card fades in at bottom (300ms, 200ms delay)
```

#### Tab Bar Indicator

```dart
// Instead of Material's default slide, the active tab indicator
// "stretches" to the new position like elastic, then snaps
// Duration: 300ms, Curves.easeOutBack
```

### 5.4 Flutter Implementation Notes

Use the `flutter_animate` package (already in pubspec.yaml) for declarative animations:

```dart
// Example: Staggered card entry
ListView.builder(
  itemCount: alerts.length,
  itemBuilder: (context, index) {
    return AlertCard(...)
      .animate()
      .fadeIn(
        duration: 350.ms,
        delay: (80 * index).ms,
      )
      .slideY(
        begin: 0.05,
        end: 0,
        duration: 350.ms,
        delay: (80 * index).ms,
        curve: const Cubic(0.4, 0.0, 0.2, 1.0), // Clay motion
      );
  },
);
```

---

## 6. Component Redesigns

### 6.1 Alert Card (Redesigned)

The current alert card is a standard Material card with emoji pet photo. The redesign makes it feel like a community flyer:

```
┌─────────────────────────────────────────┐
│                                         │
│  ● MISSING — 2 hours ago               │  ← Status pill (danger bg) + time
│                                         │
│  ┌──────────┐                           │
│  │          │  Max                      │  ← Outfit h2, ink900
│  │  [photo] │  Golden Retriever · Male  │  ← Plus Jakarta Sans body, ink700
│  │          │                           │
│  └──────────┘  📍 0.5 km away          │  ← Location with custom icon
│                                         │
│  Max is very friendly but may be        │  ← Description, 2 lines max
│  scared near loud noises...             │
│                                         │
│  ═══════════════════════════════════    │  ← Warm divider
│                                         │
│  🏆 $100 reward              [I SAW →] │  ← Reward badge + text button
│                                         │
└─────────────────────────────────────────┘
```

**Key changes from current:**
1. Photo is actual image or custom silhouette, not emoji
2. Status pill at top with MISSING/FOUND label
3. Warmer card background (AppColors.card, not white)
4. Hairline warm border instead of elevation shadow
5. Reward badge uses AppColors.rewardLight bg, not emoji
6. "I SAW THIS PET" is a text button with arrow, bolder typography

### 6.2 Primary Button

```dart
// The clay button — used ONLY for the primary action per screen
// Height: 56px (unchanged)
// Background: AppColors.primary (clay)
// Text: White, Outfit 600 weight, 14sp, 0.5 letter spacing
// Shape: RoundedRectangle with 14px radius (slightly more than 12px)
// Shadow: None at rest, subtle warm glow on hover
// Pressed: Scale 0.97, 100ms paw motion
```

### 6.3 Secondary / Outline Button

```dart
// Background: Transparent
// Border: 1.5px solid AppColors.border
// Text: AppColors.ink900, Outfit 600
// Hover/Pressed: Background becomes AppColors.primaryLight
// Shape: Same 14px radius
```

### 6.4 Text Field

```dart
// Background: AppColors.paper (warm paper, not grey surface)
// Border: 1px AppColors.border at rest
// Focus: Border AppColors.primary, slight warm glow
// Error: Border AppColors.danger, background AppColors.dangerLight
// Text: AppColors.ink900, Plus Jakarta Sans 14sp
// Placeholder: AppColors.ink500
// Icon: AppColors.ink500 → AppColors.primary on focus
```

### 6.5 Bottom Navigation Bar

```
┌──────────────────────────────────────────┐
│  🏠       🔍     [+🐾]      💬      👤  │  ← Custom icons, not Material
│ Home    Search   Report   Messages  You  │  ← Labels: Outfit, 11sp
└──────────────────────────────────────────┘
```

Key changes:
- Center item is a raised paw-print button, not a standard FAB
- Background: AppColors.paper with subtle top border
- Active icon: AppColors.primary, weight 600
- Inactive icon: AppColors.ink500, weight 400
- Active label shown (not hidden like Android default)

### 6.6 Status Badges

Replace the emoji-based badges with proper pill components:

| Status | Background | Text | Icon |
|--------|-----------|------|------|
| MISSING | AppColors.dangerLight | AppColors.danger | Custom alert triangle |
| FOUND | AppColors.successLight | AppColors.success | Custom checkmark circle |
| VERIFIED | AppColors.secondaryLight | AppColors.secondaryDark | Custom shield check |
| REWARD | AppColors.rewardLight | AppColors.reward | Custom star/coin |

### 6.7 Chip / Filter

```dart
// Inactive: AppColors.card background, AppColors.border border
// Active: AppColors.primary background, white text
// Transition: 200ms sage motion
// Shape: StadiumBorder (pill), 32px height
// Text: Plus Jakarta Sans, 12sp, 500 weight
```

---

## 7. Icon System: From Generic to Owned

### 7.1 The Problem

Phosphor Icons are fantastic as a base library, but they don't give PawFinder an identity. Every app uses them. The app needs its own visual language.

### 7.2 Custom Icon Set

Six custom icons that define PawFinder's visual identity:

| Icon | Name | Usage | Description |
|------|------|-------|-------------|
| 🐾 | pawfinder_logo | App icon, splash, watermark | Stylized paw print with location pin integration |
| 🏠 | nav_home | Bottom nav (active) | House with paw-print doormat detail |
| 🔍 | nav_search | Bottom nav | Magnifying glass with paw print in lens |
| 📋 | nav_report | Bottom nav (center) | Clipboard with paw print |
| 💬 | nav_messages | Bottom nav | Speech bubble with dog-ear corner |
| 👤 | nav_profile | Bottom nav | Person silhouette with pet beside them |

These are rendered as `CustomPaint` widgets using SVG paths. The Phosphor icon library remains for all other icons (back arrows, close buttons, settings, etc.).

### 7.3 App Icon Evolution

The app icon should be a paw print integrated with a location pin — visually communicating "find lost pets by location" in a single mark:

- Background: Clay gradient (top-left `#E8612D` → bottom-right `#C94E1F`)
- Foreground: White paw print where the center pad is shaped like a map pin
- Shape: Squircle (iOS) + adaptive (Android)

---

## 8. Dark Mode: Cozy, Not Cold

### 8.1 The Problem

The current dark mode uses `#12121E` — a cold blue-black that feels like a code editor. PawFinder's dark mode should feel like checking a community notice board under warm street lamps at night.

### 8.2 Dark Mode Palette

```
Surface hierarchy:
--paper-dark:   #1A1815    ← Main background (warm charcoal)
--card-dark:    #24211D    ← Elevated surfaces
--overlay-dark: #2D2925    ← Modals, bottom sheets

Text in dark mode:
--ink900-dark:  #F5F0E8    ← Primary text (warm off-white)
--ink700-dark:  #B8AFA5    ← Secondary text
--ink500-dark:  #7A726A    ← Tertiary text

Accents (slightly brightened for dark mode visibility):
--primary-dark: #F0733D    ← Brighter clay for dark backgrounds
--secondary-dark: #6BAFA0  ← Brighter sage
```

### 8.3 Dark Mode Texture

The noise texture becomes slightly more visible in dark mode (opacity 0.02 instead of 0.015) — giving screens a subtle velvet quality, like a high-end dark chocolate wrapper.

---

## 9. Typography-Driven Screen Layouts

### 9.1 Home Screen (Redesigned)

```
┌──────────────────────────────────────────┐
│  ☰  PawFinder                    🔔     │  ← App bar: transparent bg, Outfit 18sp
├──────────────────────────────────────────┤
│                                          │
│  ┌──────────────────────────────────┐   │
│  │  ⚠ 3 pets missing near you      │   │  ← Warning banner: dangerLight bg
│  │    Tap to view and help          │   │     warm border, no harsh red
│  └──────────────────────────────────┘   │
│                                          │
│  ╔══════════════════════════════════╗   │
│  ║                                  ║   │
│  ║        [MAP VIEWPORT]            ║   │  ← Map with custom markers
│  ║    📍 custom paw markers         ║   │
│  ║                                  ║   │
│  ║        [📍 My Location]          ║   │
│  ╚══════════════════════════════════╝   │
│                                          │
│  ────── NEARBY ALERTS ──────            │  ← Outfit h2, centered
│                                          │
│  ┌──────────────────────────────────┐   │
│  │ ● MISSING · 2h ago              │   │  ← Alert card (see §6.1)
│  │ [🐕] Max · Golden Retriever      │   │
│  │ 📍 0.5 km · 🏆 $100 reward      │   │
│  │ "Friendly but scared..."        │   │
│  └──────────────────────────────────┘   │
│                                          │
│  ┌──────────────────────────────────┐   │
│  │ ● MISSING · 30m ago             │   │
│  │ [🐈] Luna · Tabby Cat           │   │
│  │ 📍 1.2 km                       │   │
│  └──────────────────────────────────┘   │
│                                          │
│           ┌──────────────┐              │
│           │  + Report    │              │  ← Clay FAB: 64px, 16px radius
│           │  Missing Pet │              │     White paw icon, Outfit label
│           └──────────────┘              │
│                                          │
├──────────────────────────────────────────┤
│  🏠      🔍     [+🐾]      💬     👤   │  ← Bottom nav: custom icons
│  Home   Search  Report   Messages  You  │
└──────────────────────────────────────────┘
```

### 9.2 Alert Detail (Redesigned)

```
┌──────────────────────────────────────────┐
│  ←                         ⋮           │  ← Minimal app bar, transparent
├──────────────────────────────────────────┤
│  ┌──────────────────────────────────┐   │
│  │                                  │   │
│  │      [Pet Photo Carousel]        │   │  ← 240px, soft rounded corners
│  │       🐕 Max                     │   │
│  │                                  │   │
│  └──────────────────────────────────┘   │
│                                          │
│  ┌──────────────────────────────────┐   │
│  │  🔒 Your info stays private     │   │  ← Privacy banner: sageLight bg
│  │     Only you can start chats     │   │
│  └──────────────────────────────────┘   │
│                                          │
│  ● MISSING — 2 hours ago               │
│                                          │
│  Max                                    │  ← Outfit displayLarge (32sp)
│  Golden Retriever · Male · 3 years     │  ← Plus Jakarta Sans body (14sp)
│                                          │
│  ──────────────────────────────────     │
│                                          │
│  Last Seen                              │  ← Outfit h3
│  Oak Street Park, near the playground   │  ← Plus Jakarta Sans body
│  Seattle, WA · 2.3 km from you         │  ← ink500 caption
│                                          │
│  Description                            │
│  Max is very friendly but may be scared │
│  near loud noises. He has a blue collar │
│  with a silver tag and responds to      │
│  treats. Please don't chase him.        │
│                                          │
│  ┌──────────────────────────────────┐   │
│  │ ⚠ Never send money directly.    │   │  ← Safety warning
│  │   All rewards handled in-app.    │   │
│  └──────────────────────────────────┘   │
│                                          │
│  ┌──────────────────────────────────┐   │
│  │  🏆  $100 reward                │   │  ← Reward card: rewardLight bg
│  │      Guaranteed by PawFinder     │   │
│  └──────────────────────────────────┘   │
│                                          │
│  📸 Recent Sightings (2)               │  ← Outfit h3
│  ┌──────────────────────────────────┐   │
│  │  👤 Sarah M. · 30 min ago       │   │
│  │  "Saw a similar dog near the    │   │
│  │   library on 5th Street..."     │   │
│  └──────────────────────────────────┘   │
│                                          │
│  ═══════════════════════════════════    │
│                                          │
│  ┌──────────────────────────────────┐   │
│  │      📸  I SAW THIS PET          │   │  ← Success button: sage green
│  └──────────────────────────────────┘   │
│                                          │
│  ┌──────────────────────────────────┐   │
│  │      💬  Message Owner           │   │  ← Secondary: outlined, warm border
│  └──────────────────────────────────┘   │
│                                          │
└──────────────────────────────────────────┘
```

---

## 10. Flutter Theme Implementation

### 10.1 Updated Theme Config

```dart
// lib/core/theme/app_theme.dart (UPDATED)

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    final typography = AppTypography.textTheme;
    
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      
      // Color scheme derived from clay primary
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.light,
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        error: AppColors.danger,
        surface: AppColors.card,
      ),
      
      // Warm paper, not clinical white
      scaffoldBackgroundColor: AppColors.paper,
      
      textTheme: typography,
      fontFamily: AppTypography.fontBody, // Default body font
      
      // App bar: clean, transparent by default
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0.5,
        backgroundColor: AppColors.paper,
        foregroundColor: AppColors.ink900,
        titleTextStyle: typography.headlineSmall,
        centerTitle: false, // Always left-aligned for readability
      ),
      
      // Bottom nav: warm, custom styling
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.ink500,
        backgroundColor: AppColors.paper,
        elevation: 0,
        selectedLabelStyle: GoogleFonts.outfit(
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.outfit(
          fontSize: 11,
          fontWeight: FontWeight.w400,
        ),
      ),
      
      // Cards: warm, soft, paper-like
      cardTheme: CardThemeData(
        elevation: 0, // No Material elevation — use custom shadows
        color: AppColors.card,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: AppColors.border, width: 0.5),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      ),
      
      // Primary button: clay
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          disabledBackgroundColor: AppColors.ink500.withOpacity(0.3),
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: GoogleFonts.outfit(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
          elevation: 0,
        ),
      ),
      
      // Secondary button: outlined warm
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.ink900,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          side: const BorderSide(color: AppColors.border, width: 1.5),
          textStyle: GoogleFonts.outfit(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      // Input fields: paper background, warm borders
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.paper,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.danger),
        ),
        labelStyle: typography.bodyMedium?.copyWith(color: AppColors.ink700),
        hintStyle: typography.bodyMedium?.copyWith(color: AppColors.ink500),
      ),
      
      // FAB: clay, no default Material styling
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      
      // Snackbar: warm dark, not cold
      snackBarTheme: SnackBarThemeData(
        backgroundColor: const Color(0xFF2D241F), // ink900
        contentTextStyle: typography.bodyMedium?.copyWith(
          color: const Color(0xFFFFFBF5),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        behavior: SnackBarBehavior.floating,
      ),
      
      // Dialog: warm overlay, not cold white
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.overlay,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 0,
      ),
      
      // Chips: warm
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.card,
        selectedColor: AppColors.primary,
        labelStyle: GoogleFonts.plusJakartaSans(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: AppColors.ink700,
        ),
        secondaryLabelStyle: GoogleFonts.plusJakartaSans(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
        shape: const StadiumBorder(),
        side: const BorderSide(color: AppColors.border),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
      
      // Dividers: warm, subtle
      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
        space: 0,
      ),

      // Page transitions
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }

  static ThemeData get darkTheme {
    final typography = AppTypography.textTheme;
    
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.dark,
        primary: const Color(0xFFF0733D), // Brighter clay for dark
        secondary: const Color(0xFF6BAFA0), // Brighter sage for dark
        error: AppColors.danger,
        surface: AppColors.cardDark,
      ),
      
      scaffoldBackgroundColor: AppColors.paperDark,
      
      textTheme: typography.apply(
        bodyColor: const Color(0xFFF5F0E8),
        displayColor: const Color(0xFFF5F0E8),
      ),
      
      fontFamily: AppTypography.fontBody,
      
      appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: AppColors.paperDark,
        foregroundColor: Color(0xFFF5F0E8),
      ),
      
      cardTheme: CardThemeData(
        elevation: 0,
        color: AppColors.cardDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(
            color: Color(0xFF302B26),
            width: 0.5,
          ),
        ),
      ),
      
      // ... (additional dark theme overrides follow same warm pattern)
    );
  }
}
```

### 10.2 Updated main.dart

```dart
void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: AppColors.paper,
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
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const SplashPage(),
    );
  }
}
```

---

## 11. Implementation Priority

### Phase 1: Foundation (visual identity overhaul)
- [x] Update `app_colors.dart` — warm paper palette
- [x] Update `app_typography.dart` — Outfit + Plus Jakarta Sans
- [x] Add `google_fonts` dependency to pubspec.yaml
- [x] Update `app_theme.dart` — warm Material theme
- [x] Create `TexturedBackground` widget
- [x] Apply `TexturedBackground` to app shell

### Phase 2: Components (widget glow-up)
- [ ] Redesign `AlertCard` — custom silhouette, status pill, warm styling
- [ ] Redesign `AppButton` — clay styling, Outfit text, 14px radius
- [ ] Redesign `StatusBadge` — proper pills, no emojis
- [ ] Redesign `StatCard` — warm paper styling
- [ ] Redesign `InfoBanner` — warm borders, semantic colors
- [ ] Redesign `AppBottomNav` — custom paw icons, raised center

### Phase 3: Identity (signature elements)
- [ ] Create `PawPrint` custom painter widget
- [ ] Create `PawPrintLoader` animation
- [ ] Create custom bottom nav icons set
- [ ] Create empty state illustrations (5 variants)
- [ ] Design and export new app icon

### Phase 4: Motion (animation personality)
- [ ] Implement card entry stagger (clay motion)
- [ ] Implement reunion celebration sequence
- [ ] Implement paw-print loading indicator
- [ ] Implement tab bar elastic indicator
- [ ] Add `flutter_animate` declarations to key widgets

### Phase 5: Polish (dark mode + edge cases)
- [ ] Complete dark theme (warm, not cold)
- [ ] Dark mode texture adjustment
- [ ] Reduced motion media query
- [ ] All loading states → skeleton screens or paw loader
- [ ] All error states → warm, informative, actionable

---

## 12. Anti-Patterns: Explicitly Avoided

| Anti-Pattern | Why It's Bad | What We Do Instead |
|-------------|--------------|-------------------|
| **Inter font** | Most overused AI font. Zero personality. | Outfit (display) + Plus Jakarta Sans (body) |
| **Pure white backgrounds** (`#FFFFFF`) | Clinical, cold, high glare | Warm paper (`#FFFBF5`) with subtle grain |
| **Material elevation shadows** | Generic, default-looking | Custom warm directional shadows |
| **Emojis for pet/status icons** | Amateurish, inconsistent across platforms | Custom SVG/CustomPaint illustrations |
| **Cold blue-black dark mode** | Doesn't match the brand warmth | Warm charcoal (`#1A1815`) |
| **Bright teal secondary** | Harsh, tech-y, not calming | Sage green — natural, trustworthy |
| **Standard Material FAB** | Generic, overused | Custom paw-print raised button with label |
| **Pure black text** (`#000000`) | Harsh contrast, eye strain | Warm brown-black (`#2D241F`) |
| **Equal animation durations everywhere** | No personality in motion | Purpose-driven motion language (clay/sage/paw/alert) |
| **Generic empty states** | Missing opportunity for warmth | Custom illustrations with paw-print motifs |
| **Default Material border radius everywhere** | Cookie-cutter look | Slightly varied: 14px for buttons, 16px for cards, 20px for dialogs |
| **No texture** | Flat, lifeless, no atmosphere | Subtle noise grain, paper-like card backgrounds |

---

## 13. Summary: v1.0 vs v2.0

| Aspect | v1.0 ("Vibecoded") | v2.0 ("The Warm Signal") |
|--------|-------------------|--------------------------|
| **Font** | Inter (generic, cold) | Outfit + Plus Jakarta Sans (warm, distinctive) |
| **Background** | `#FFFFFF` white | `#FFFBF5` warm paper with grain |
| **Primary color** | `#FF6B35` bright orange | `#E8612D` rich clay |
| **Secondary color** | `#4ECDC4` bright teal | `#5B9A8B` calming sage |
| **Dark mode** | `#12121E` cold blue-black | `#1A1815` warm charcoal |
| **Cards** | Material elevation shadows | Warm directional shadows + hairline border |
| **Text color** | `#1A1A2E` cold navy-black | `#2D241F` warm brown-black |
| **Icons** | Phosphor only | Custom paw-print identity + Phosphor |
| **Illustrations** | Emojis (`🐕`, `🐈`, `🎉`) | Custom vector illustrations |
| **Loading state** | CircularProgressIndicator | Paw-print walking animation |
| **Atmosphere** | Flat, no texture | Subtle noise grain, paper feel |
| **Motion** | "300ms ease-out" for everything | Clay/Sage/Paw/Alert motion language |
| **Identity** | Generic Material Design 3 app | Distinctive community warmth app |
| **Emotional impact** | Functional but forgettable | Warm, human, memorable |

---

*Built by Claw — your J.A.R.V.I.S to your Tony Stark.* 🤖
