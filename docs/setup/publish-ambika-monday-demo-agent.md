# Publish Ambika Monday Demo Agent

Push local git → org so **Agentforce Builder** shows your changes. Test with **Preview** on the new **Committed** version (no activate required). Use org alias `**agentforce-org`**.

---

## Terminal (run in order)

```bash
cd /Users/ambika.tiwari/Documents/salesforce_onboarding_notes/my-agentforce-project

# 1 - Optional but recommended before publish
sf agent validate authoring-bundle \
  --api-name Ambika_Monday_Demo_Agent \
  --target-org agentforce-org

# 2 - Run when you changed the FAQ prompt file
sf project deploy start \
  --metadata GenAiPromptTemplate:Ambika_TableCraft_FAQ_Prompt \
  --target-org agentforce-org \
  --wait 15

# 3 - Creates new Committed version (v2, v3, v4, …)
sf agent publish authoring-bundle \
  --api-name Ambika_Monday_Demo_Agent \
  --target-org agentforce-org
```

**Version number:** after publish, check `force-app/main/default/aiAgentDefinitionVersions/Ambika_Monday_Demo_Agent#N/` — use that `N` in Builder.

---

## Agentforce Builder

1. **Setup → Agentforce → Agents → Ambika Monday Demo Agent**
2. Version dropdown → **newest Committed** version (not necessarily Active)
3. Hard refresh (Cmd+Shift+R) if the graph is stale
4. **Preview** — test an FAQ question

Expected topics: **Agent Router**, **FAQ Context Setup**, **FAQ Subagent**.

---

## Optional — make a version live (Messaging / production)

Only when Preview looks good and you want this version **Active**:

```bash
sf agent activate \
  --api-name Ambika_Monday_Demo_Agent \
  --version N \
  --target-org agentforce-org
```

Replace `N` with your version, or omit `--version` to pick from a list.

---

## When you change code again

Same as terminal block above: deploy prompt if it changed → validate (optional) → publish → select new Committed version in Builder → Preview.

**Do not** deploy old `aiAgentDefinitionVersions/Ambika_Monday_Demo_Agent#1` to update the graph — use `**sf agent publish authoring-bundle`**.

---

## Preview: “Sorry, it looks like something has gone wrong.”

That text is the agent **`system.messages.error`** line — Preview hit a runtime failure (CLI shows **`ACTION_FAILED`**), not a generic Salesforce outage.

**Likely cause (confirmed on committed v7):** **Agent Router** was **`DefaultEinsteinLlm`** instead of **`DefaultEinsteinHyperClassifier`**. This bundle’s router is **transition-only** (`go_to_faq_context_setup`, `go_to_faq_subagent`). That pattern expects the **hyperclassifier**; the first Preview turn then fails and surfaces the error message.

**Source of truth:** `force-app/.../aiAuthoringBundles/Ambika_Monday_Demo_Agent/Ambika_Monday_Demo_Agent.agent` — router must stay:

```text
model: "model://sfdc_ai__DefaultEinsteinHyperClassifier"
```

**Do not** switch Agent Router to Einstein LLM in Builder. Variable writes stay on **`faq_context_setup`** (`set_faq_context`), not on the router.

**Fix:** publish from git (step 3 above), hard refresh Builder, Preview the **newest Committed** version (e.g. v8+). Avoid Preview on **v7** unless you revert the router model in that version.

**After routing works:** set `restaurant_id` and `escalation_phone_number` (or complete `faq_context_setup`) before expecting grounded FAQ answers.

---

## More detail

- [ambika-monday-demo-faq-pipeline.md](../ambika-monday-demo-faq-pipeline.md)
- [pull-from-org.md](./pull-from-org.md)

