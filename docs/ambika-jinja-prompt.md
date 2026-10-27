# What is a Jinja prompt? (Ambika FAQ context)

In **Prompt Builder**, a **Jinja prompt** is a template whose body is rendered with the **Jinja** templating language. Static instructions and guardrails stay fixed; **inputs**, **retriever results**, and other merge fields are substituted at runtime into one final string that is sent to the LLM.

Ambika’s FAQ template uses Jinja. Placement in the agent flow: [ambika-monday-demo-faq-pipeline.md](./ambika-monday-demo-faq-pipeline.md) (Step 8 — Prompt template body + LLM).

---

## What Jinja does here

1. **Data providers run first** (e.g. Einstein retriever — Step 7 in the pipeline).
2. **Jinja renders** `templateVersions.content` — merge fields become real text (question, restaurant context, retrieved passages).
3. **LLM runs** on the rendered prompt (`DefaultGPT5Mini` for Ambika).

Jinja is the **assembly step** between retrieval and generation. It does not search Data 360 and does not replace guardrails; it **formats** what retrieval and inputs already produced.

---

## Syntax you see in Ambika’s template

Prompt Builder exposes a **Jinja-oriented subset** (not every Python-Jinja feature). Ambika’s FAQ prompt mainly uses **variable insertion**:

| Merge field | Source |
|-------------|--------|
| `{{Input.question}}` | Action input from transcript (via agent) |
| `{{Input.restaurant_id}}` | Agent variable |
| `{{Input.escalation_phone_number}}` | Agent variable |
| `{{EinsteinSearch.File_Diner_Restaurant_FAQ_and_Policies_1Cx_8Ec8b60f20d.results}}` | Retriever data provider output |

Fuller Jinja supports `{% if %}`, loops, and filters; use those only where Prompt Builder documents support for them. Ambika Phase 1 keeps the body mostly plain prose plus `{{ … }}` merges.

**Metadata:** `templateFormat` is `Jinja` on [Ambika_TableCraft_FAQ_Prompt.genAiPromptTemplate-meta.xml](../force-app/main/default/genAiPromptTemplates/Ambika_TableCraft_FAQ_Prompt.genAiPromptTemplate-meta.xml).

---

## What it is not

| Concept | Role |
|--------|------|
| **Agent Script** (`.agent`) | Routing, variables, when to call the prompt action — not Jinja. |
| **Einstein retriever** | Search over the FAQ index; results are **injected** via Jinja merge fields. |
| **Guardrails** | Written **inside** the template text (and checklist in [ambika-faq-prompt-guardrails.md](./ambika-faq-prompt-guardrails.md)); Jinja does not enforce them programmatically — the LLM is instructed to follow them. |
| **Trust Layer** | Org policy on generative calls before/after the LLM — separate from templating. |

---

## Why Salesforce uses Jinja (or templating) on prompts

- **One template, many turns** — same structure; different question, context IDs, and passages each invocation.
- **Grounding layout** — explicit sections (context, passages, question, rules) so the model sees a stable shape.
- **Deployable metadata** — prompt body lives in `GenAiPromptTemplate` XML and syncs with Prompt Builder.

---

## Related

- [ambika-monday-demo-faq-pipeline.md](./ambika-monday-demo-faq-pipeline.md) — full FAQ pipeline
- [ambika-einstein-retriever.md](./ambika-einstein-retriever.md) — where `{{EinsteinSearch....results}}` comes from
- [ambika-faq-prompt-guardrails.md](./ambika-faq-prompt-guardrails.md) — rules inside the Jinja body
