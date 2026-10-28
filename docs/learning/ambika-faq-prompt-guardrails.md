# Ambika FAQ — prompt guardrails (source of truth)

**Template:** `Ambika_TableCraft_FAQ_Prompt`  
**Metadata:** `force-app/main/default/genAiPromptTemplates/Ambika_TableCraft_FAQ_Prompt.genAiPromptTemplate-meta.xml`  
**Agent action:** `Answer_TableCraft_FAQ` → `generatePromptResponse://Ambika_TableCraft_FAQ_Prompt`

Joe’s `Joe_FAQ_Prompt` remains in the org for other agents; Ambika’s bundle uses **this** template so guardrails live in one owned prompt.

## Checklist (prompt layer)

| # | Guardrail | Enforced in prompt |
|---|-----------|-------------------|
| 1 | FAQ passages only — no hallucination | Rules 1–2 |
| 2 | Unknown answer + escalation phone copy | Rules 3–4 |
| 3 | Allergen / medical handoff | Rule 5 |
| 4 | No bookings in FAQ step | Rule 6 |
| 5 | No meta (“sources”, “rules”) | Rule 7 |
| 6 | Brevity (≤3 sentences) | Rule 8 |

## Prompt inputs (passed from agent variables)

| Input | From agent variable |
|-------|---------------------|
| `Input.question` | User utterance (transcript) |
| `Input.restaurant_id` | `@variables.restaurant_id` |
| `Input.escalation_phone_number` | `@variables.escalation_phone_number` (set from CRM **`Phone_Number__c`** in pipeline **step 1**, not user input) |

Retriever still uses **`searchText = question`** only; `restaurant_id` is context + copy until retriever filter is added.

## Deploy

```bash
sf project deploy start \
  --metadata GenAiPromptTemplate:Ambika_TableCraft_FAQ_Prompt \
  --metadata AiAuthoringBundle:Ambika_Monday_Demo_Agent \
  --target-org agentforce-org
```

Publish/activate the prompt version in **Prompt Builder** if the org requires it after first deploy.

## Related

- [ambika-monday-demo-faq-pipeline.md](../ambika-monday-demo-faq-pipeline.md) — full input→output checklist with Trust Layer, RAG, and file locations
