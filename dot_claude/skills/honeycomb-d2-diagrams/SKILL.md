---
name: honeycomb-d2-diagrams
description: >-
  Make Honeycomb-branded diagrams with d2 — and pick the right KIND of diagram
  for the question (sequence, data-flow, component/architecture, state,
  flowchart) instead of defaulting to boxes-and-arrows. Rendered in Honeycomb's
  Lattice visual language (real Lattice tokens, rounded cards, cylinders for
  datastores) and kept deliberately lean and self-contained (structure, not
  spec). Use whenever the user wants to visualize how systems / services / data
  / requests relate or flow: "architecture diagram", "sequence diagram of…",
  "data flow diagram", "diagram this system", "show the order of calls", "draw
  the service relationships", "turn this design doc into a diagram", "make a d2
  diagram", or restyle a diagram to look like Honeycomb / on-brand. Also for
  synthesizing a diagram from a Linear project or Notion design docs. Do NOT use
  for plotting telemetry or time-series data (that's synthesize-graph / doodle),
  or for building Honeycomb queries, boards, or SLOs.
---

# Honeycomb diagrams with d2

Produces Honeycomb-branded diagrams with [d2](https://d2lang.com) (`d2` is on
PATH). The conventions here were tuned by hand; the point is to land a clean,
on-brand, *legible* diagram in one or two passes.

Two principles drive everything below. Read them first — they matter more than
any styling detail.

## Principle 1 — pick the right kind of diagram for the question

A diagram answers **one** question. The most common failure is reflexively
drawing a component box-and-arrow diagram for a question that wanted something
else. Match the kind to the question:

| Kind | Answers | Reach for it when… |
|------|---------|--------------------|
| **Sequence** | "In what order do these talk?" | tracing one request/turn's lifecycle; the point is *time / ordering* of calls between a few participants |
| **Data-flow** | "Where does the data come from, what transforms it, where does it land?" | following data through processes and stores (ingest pipelines, ETL, event flow) |
| **Component / architecture** | "What are the pieces and how do they relate / who owns what?" | the *static structure* of a system — the default only when the question really is "how is X built" |
| **State** | "What states does X move through, and what triggers transitions?" | lifecycles (an investigation, a job, a deployment) |
| **Flowchart** | "What's the branch/decision logic of this process?" | algorithms, decision trees, runbooks with conditionals |

If the right kind isn't obvious from the request, **ask — don't guess.** Use
`AskUserQuestion` with a short "Diagram kind" question offering the 2–3 most
plausible kinds, each with a one-line "use this if…". Example:

```
AskUserQuestion(questions=[{
  header: "Diagram kind",
  question: "What should this diagram emphasize?",
  options: [
    {label: "Sequence", description: "The order of calls in one request/turn over time"},
    {label: "Component", description: "The static pieces and how they connect / who owns what"},
    {label: "Data-flow", description: "Where data originates, gets transformed, and lands"}
  ]
}])
```

Picking the right kind is also the cure for overload (Principle 2): a sequence
diagram answers "what's the order" without needing every component's internals.

See `references/diagram-kinds.md` for each kind's d2 recipe and which template to
start from. The Lattice styling and Principle 2 apply to **all** kinds.

## Principle 2 — the diagram must stand on its own

The other failure mode is overload: cramming every responsibility, endpoint,
identifier, middleware, and invariant into the picture so only someone who
already read the design doc can parse it. **The diagram carries structure; the
prose around it carries detail.** Someone who has *not* read the source material
should grasp the shape — the pieces and how they relate — from the diagram alone.

- **One question per diagram.** Decide the single thing it answers. If you're
  showing the request path *and* the stream path *and* data ownership *and* the
  auth invariants, that's four diagrams. Split them.
- **Nodes carry identity, not spec.** A box says what it *is* and, if the name
  isn't self-evident, a ≤6-word role — not a bullet list of endpoints, fields,
  middlewares, or internal mechanics. If a box needs a paragraph to be
  understood, the diagram is doing the doc's job.
- **No insider jargon on the canvas.** Identifiers that only mean something if
  you read the doc (`investigation_key`, internal table names, HCIDs, specific
  endpoint paths, TTLs) belong in the writeup, not the diagram. Use plain words a
  new teammate or a partner team would understand.
- **Cut the invariants block.** "Never does X", safety rules, design invariants —
  that's doc-context. The diagram keeps at most a tiny color key for line types.
- **Fewer edges.** Draw the spine of the interaction, not every call. Two
  diagrams each showing one clean flow beat one diagram showing all of them
  crossed.

When in doubt, take something out. A diagram people can read at a glance and ask
a question about beats a complete one nobody can parse.

## Workflow

1. **Gather the architecture.** Sources in order of authority: the user's own
   description → the codebase → a design doc. Design docs often live in **Notion**
   or **Linear** — use the `linear` MCP (`get_project`, `get_issue`) and `notion`
   MCP (`notion-search`, `notion-fetch`). Watch for superseding versions ("v3
   supersedes v2") and scope-change notes; diagram the current state and say which
   you chose. If a relationship is ambiguous, ask — a confidently wrong arrow is
   worse than no arrow.
2. **Pick the kind** (Principle 1). `AskUserQuestion` if it isn't obvious.
3. **Scope it down** (Principle 2). Name the one question; list only the nodes/
   messages that serve it.
4. **Draft from that kind's template** — `assets/template-component.d2`,
   `assets/template-sequence.d2`, or the recipe in `references/diagram-kinds.md`.
   Leave the styling intact; change the content.
5. **Render — and actually look at it.**
   ```bash
   d2 --layout dagre --pad 40 diagram.d2 diagram.png
   d2 --layout dagre --pad 40 diagram.d2 diagram.svg
   ```
   Then **Read the PNG** (or `open` it) and inspect with your eyes — label
   collisions, awkward routing, a node folded to the wrong side, and illegible or
   overloaded text only show up visually. This step is the whole game. For a
   crowded region, crop at full resolution:
   ```bash
   sips -c <H> <W> --cropOffset <Y> <X> diagram.png --out /tmp/crop.png
   sips -Z 1500 /tmp/crop.png --out /tmp/crop_small.png
   ```
6. **Iterate, then hand off.** Fix issues, re-render, re-look. When it's clean,
   `open diagram.png` and summarize the choices (kind, what each color means).

## The Honeycomb look (Lattice styling) — applies to every kind

Full token table in `references/lattice-palette.md`. Essentials:

- **Canvas** `#f5f7fa` (Lattice page surface). **Cards/participants** rounded
  (`border-radius: 8`), filled with the soft Lattice *banner tint* for the node's
  category, a 2px border in the category's bold color, title in its foreground
  color.
- **Category = meaning**, not decoration: honey/Warning for the focal or new
  thing, blue/Informational for boundary/API, green/Success for runtime/compute,
  neutral for external, red/Critical for legacy/error. Honey is the brand
  signature — spend it on the one node the diagram is about. If nothing is clearly
  focal, leave everything cool rather than painting an arbitrary card honey.
- **Datastores are cylinders.** Conventional shapes win; no hexagons/"honeypots".
  The honeycomb motif is the *palette*, not literal hexagons.
- **Restraint reads as polished.** Subtle tints + meaningful color beat saturated
  fills and decorative flourishes.

## d2 conventions & gotchas (the hard-won ones)

- **Prefer `dagre`** for component/data-flow request-response layouts — it ranks
  a clean left→right spine and curves return edges back. `elk` tends to float a
  node to the wrong side. (Sequence diagrams ignore layout — d2 lays them out
  top-down by message order.)
- **Terse edge labels (1–3 words).** Verbose labels on anti-parallel edges
  collide into an unreadable cluster. With Principle 2, the detail isn't going in
  the diagram at all — so this is easy.
- **Group related components into a labeled boundary container** when several
  nodes form one logical unit — a collector, a deployment, a runtime tier, an
  "island". In d2 a container is a node with children (`group` class): dashed
  neutral border + a label, recolored honey if the group *is* the focal island.
  Readers parse "these are one subsystem" instantly. Often the single biggest
  legibility win. (Watch the render; deeply nested containers can crowd dagre.)
- **Legend = a grid container** (`grid-rows`/`grid-columns`, small `grid-gap`).
  Never space legend items with invisible `opacity: 0` edges — that injects big
  rank gaps. Keep it to the color key; no invariants block (Principle 2).
- **No decorative Unicode glyphs** (⬡, ◆) — d2 renders missing glyphs as
  tofu/rings. Carry motif through shape and color.
- **Pre-blend alpha tints to solid hex** — 8-digit `#rrggbbaa` fills are finicky;
  the palette gives pre-blended solids.

## Files

- `assets/template-component.d2` — component/architecture & data-flow starter.
- `assets/template-sequence.d2` — sequence-diagram starter (d2 `sequence_diagram`).
- `references/diagram-kinds.md` — when to use each kind + its d2 recipe (incl.
  data-flow, state, flowchart).
- `references/lattice-palette.md` — authoritative token hexes + refresh command.
