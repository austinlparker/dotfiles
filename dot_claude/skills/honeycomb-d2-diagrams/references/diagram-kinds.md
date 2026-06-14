# Choosing and building the right diagram kind

A diagram answers **one** question. Pick the kind that matches the question
before you draw — and when it isn't obvious, `AskUserQuestion` (see SKILL.md
Principle 1). The Lattice palette (`references/lattice-palette.md`) and the
"stand on its own" rule (SKILL.md Principle 2) apply to every kind below.

## Quick picker

| Question shape | Kind | Start from |
|----------------|------|------------|
| "In what order do A, B, C talk during one request/turn?" | **Sequence** | `assets/template-sequence.d2` |
| "Where does the data come from → get transformed → land?" | **Data-flow** | `assets/template-component.d2` (see below) |
| "What are the pieces and how do they relate / who owns what?" | **Component** | `assets/template-component.d2` |
| "What states does X move through and what triggers each?" | **State** | recipe below |
| "What's the branch/decision logic of this process?" | **Flowchart** | recipe below |

If two kinds both seem plausible (common for "how does X work"), that's the
signal to ask. A frequent split: *sequence* (the order of calls) vs *component*
(the static structure) — they answer different questions about the same system.

---

## Sequence

The point is **time/order** between a few participants. Use d2's
`shape: sequence_diagram` (see `assets/template-sequence.d2`). Participant
declaration order = left-to-right; messages read top-to-bottom. Bracket a
repeated/optional stretch in a labeled group. Keep messages to terse verbs
("invoke", "stream events") — no payloads, headers, or TTLs.

Best for: a single request's lifecycle, an auth handshake, "what calls what and
when". Naturally lean — it can't show component internals, which is a feature.

## Data-flow

Reuse `assets/template-component.d2` with these emphases: left→right `dagre`;
**stores are prominent** (cylinders for sources and sinks); the `data` (purple)
edge class carries what's moving ("spans", "events", "parquet"); processes are
the `runtime` class. The nouns on the edges are the story — keep node bodies to
a name. Group stages that belong to one stage/collector with the `group` class.

Best for: ingest pipelines, ETL, event flow. Don't also draw control/RPC edges —
if you need those, that's a second (component) diagram.

## Component / architecture

The static structure: services/components and how they relate. The default
*only* when the question is genuinely "how is this built / who owns what". Use
`assets/template-component.d2` as-is. The biggest wins are **grouping** related
nodes into labeled boundaries and **resisting** the urge to annotate every box.

## State

Nodes are **states**, edges are **transitions** labeled with their trigger.
There's no dedicated d2 shape — use plain nodes + edges, mark the start, and
style states with the `runtime`/`island` classes. Recipe:

```d2
style.fill: "#f5f7fa"
classes: {
  state: { style: { fill: "#dcefcf"; stroke: "#007000"; stroke-width: 2; font-color: "#005700"; border-radius: 8 } }
  start: { shape: circle; style: { fill: "#33383f"; stroke: "#33383f" } }
  done:  { style: { fill: "#f8ecc6"; stroke: "#a94a04"; stroke-width: 2; font-color: "#7a3302"; border-radius: 8 } }
  t:     { style: { stroke: "#0077cc"; stroke-width: 2; font-color: "#00489c" } }
}
begin: "" { class: start }
created: created { class: state }
running: running { class: state }
done:    done    { class: done }
begin -> created
created -> running: "start" { class: t }
running -> done: "finished" { class: t }
running -> created: "retry" { class: t }
```

Best for: lifecycles (an investigation, a job, a deployment).

## Flowchart

Decision/branch logic. Decisions are diamonds (`shape: diamond`); branch edges
are labeled "yes"/"no". Keep it `direction: down`. Recipe:

```d2
direction: down
style.fill: "#f5f7fa"
classes: {
  step:    { style: { fill: "#c8e3f7"; stroke: "#00489c"; stroke-width: 2; font-color: "#00489c"; border-radius: 8 } }
  decide:  { shape: diamond; style: { fill: "#f8ecc6"; stroke: "#a94a04"; stroke-width: 2; font-color: "#7a3302" } }
  e:       { style: { stroke: "#0077cc"; stroke-width: 2; font-color: "#00489c" } }
}
start: "request arrives" { class: step }
check: "authorized?" { class: decide }
do:    "handle it" { class: step }
deny:  "reject" { class: step }
start -> check { class: e }
check -> do: "yes" { class: e }
check -> deny: "no" { class: e }
```

Best for: runbooks with conditionals, validation logic, decision trees.
