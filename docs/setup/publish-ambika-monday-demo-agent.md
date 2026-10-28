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

## More detail

- [ambika-monday-demo-faq-pipeline.md](../ambika-monday-demo-faq-pipeline.md)
- [pull-from-org.md](./pull-from-org.md)

