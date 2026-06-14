# Honeycomb Lattice palette for diagrams

These are the real Lattice design-system token values, pulled from
`cmd/poodle/lattice/Tokens/dist/_resolved/tokens.ts` in the `hound` repo.
Use them so a diagram reads as genuinely Honeycomb-branded instead of an
approximation. If Lattice ever rebrands, refresh from that file (see bottom).

## Surfaces

| Use | Token | Hex |
|-----|-------|-----|
| Diagram canvas / page | `LatColorPageSecondary` | `#f5f7fa` |
| White card / cylinder fill | `LatColorPagePrimary` | `#ffffff` |

## Category cards (banner pattern)

Lattice's banner backgrounds are the category color at ~30% alpha
(`...4d`) over the page surface — soft tints, **not** saturated fills.
The "tint (solid)" column is that 30% banner color pre-blended over
`#f5f7fa`, which renders predictably (8-digit `#rrggbbaa` fills can be
finicky in d2). Border = the category's bold border token; title = its
foreground token.

| Category | Meaning to reach for | Tint (solid) | Border | Title fg |
|----------|----------------------|--------------|--------|----------|
| Warning / honey   | focal / new / "hero" node      | `#f8ecc6` | `#a94a04` | `#7a3302` |
| Informational/blue| boundary / API / gateway       | `#c8e3f7` | `#00489c` | `#00489c` |
| Success / green   | runtime / compute / worker     | `#dcefcf` | `#007000` | `#005700` |
| Neutral / gray    | external / third-party         | `#e8ecf2` | `#717a89` | `#33383f` |
| Critical / red    | legacy / deprecated / error    | `#ecd3d6` | `#85322e` | `#85322e` |

Honey is the Honeycomb signature — spend it on the one thing the diagram is
about, and let the rest stay cool so it pops. Color should encode a node's
*kind*; resist rainbow-ing every box a different hue for variety's sake.

Source banner tokens (if you'd rather use alpha fills directly):
`Warning #ffd14d4d` · `Informational #60b5f04d` · `Success #a1db6a4d` ·
`Neutral #c9d1df4d` · `Critical #d781844d`.

## Edges / lines

| Kind | Token | Hex | Style |
|------|-------|-----|-------|
| Primary / request | `LatColorBackgroundInteractiveDefault` | `#0077cc` | solid, label fg `#00489c` |
| Response / stream | `LatColorBorderSuccessDefault` | `#007000` | dashed (`stroke-dash: 4`), label fg `#005700` |
| Callback / async (3rd class) | dataviz purple (`lat-ref-color-dataviz-28`) | `#8659b4` | solid, label fg `#5e3a8c` |

Keep to ~3 edge kinds. If you need a 4th distinct hue, pull from the dataviz
ramp rather than inventing one: `#73ca0d` (lime, dataviz-2), `#ffbc04`
(gold, dataviz-3), `#60b5f0` (sky, dataviz-5), `#b96b90` (mauve, dataviz-11).

## Text / borders

| Use | Hex |
|-----|-----|
| Body / default text | `#33383f` (neutral subtle) or `#59606d` (neutral default) |
| Neutral border (cylinders, legend, external) | `#717a89` |

## Refreshing from source

```bash
grep -iE 'PageSecondary|CompBannerBackground.*Default|Border(Warning|Informational|Success|Critical)Default|Foreground(Warning|Informational|Success)Default|BackgroundInteractiveDefault' \
  cmd/poodle/lattice/Tokens/dist/_resolved/tokens.ts
```

To re-blend a banner tint to a solid hex: `out = fg*0.30 + #f5f7fa*0.70`
per channel (0x4d = 77/255 ≈ 0.302 alpha).
