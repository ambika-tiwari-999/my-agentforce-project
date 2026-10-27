# Publish Ambika Monday Demo Agent (git → org)

## Goal: mirror repo code in Agent Builder and use **Preview**

Agentforce Builder does **not** read your laptop files directly. It shows whatever **agent version** exists in the org. To test in **Preview** the same logic as git:

```text
Edit files in repo  →  sf agent publish  →  sf agent activate (new version)  →  refresh Builder  →  Preview
```

| You edit in repo | Builder / Preview uses |
|------------------|-------------------------|
| `aiAuthoringBundles/.../Ambika_Monday_Demo_Agent.agent` | After **publish + activate** — topics, router, subagents, actions |
| `genAiPromptTemplates/Ambika_TableCraft_FAQ_Prompt...` | After **deploy** prompt — FAQ guardrails + retriever (action calls this at runtime) |

**Do not use** Compare → Accept/Decline for CLI/git work — that flow is only for edits made **inside** the Builder UI.

**After each publish:** open the **version** dropdown → pick the **newest** version (e.g. v3, v4) → **Activate** → confirm header shows that version **Active** → then **Preview**.

Use this doc when FAQ topics are missing or Builder still shows an old template (v1 Messaging vars, Escalation / Off Topic / Ambiguous only).

**Why:** The UI reads the **published agent version** (`AiAgentDefinitionVersion` + agent script), not git alone. You must **`sf agent publish authoring-bundle`**, then **activate** the new version.

**Org alias:** `agentforce-org` (see `.sf/config.json`).

**Repo root:**

```bash
cd /Users/ambika.tiwari/Documents/salesforce_onboarding_notes/my-agentforce-project
```

---

## 1. Push code to GitHub

`main` may be branch-protected; push a feature branch and open a PR.

```bash
git status
git add force-app/main/default/aiAuthoringBundles/Ambika_Monday_Demo_Agent/ \
  force-app/main/default/genAiPromptTemplates/Ambika_TableCraft_FAQ_Prompt.genAiPromptTemplate-meta.xml \
  docs/
git commit -m "Your message"
git push -u origin HEAD:faq-subagent-pipeline-built
```

PR link (replace if your branch name differs):

https://github.com/ambika-tiwari-999/my-agentforce-project/pull/new/faq-subagent-pipeline-built

---

## 2. Validate Agent Script (local compile)

Must pass before publish. Router must **not** use `@utils.setVariables` on `DefaultEinsteinHyperClassifier` — use **`faq_context_setup`** for `set_faq_context`.

```bash
sf agent validate authoring-bundle \
  --api-name Ambika_Monday_Demo_Agent \
  --target-org agentforce-org
```

Expect **Status: COMPLETED**, **Errors: 0**.

---

## 3. Deploy the FAQ prompt (required before publish)

Publish wires **`Answer_TableCraft_FAQ`** → **`Ambika_TableCraft_FAQ_Prompt`**. The prompt metadata should include **`activeVersionIdentifier`** (retrieve from org once if publish fails on “must specify at least one input”).

```bash
sf project deploy start \
  --metadata GenAiPromptTemplate:Ambika_TableCraft_FAQ_Prompt \
  --target-org agentforce-org \
  --wait 15
```

Optional — refresh prompt version IDs from org into git:

```bash
sf project retrieve start \
  --metadata GenAiPromptTemplate:Ambika_TableCraft_FAQ_Prompt \
  --target-org agentforce-org \
  --wait 10
```

In **Setup → Prompt Builder → Ambika TableCraft FAQ Prompt**, confirm **Published**.

---

## 4. Publish the agent (this updates Agent Builder topics)

**Do not rely on** `sf project deploy --metadata AiAuthoringBundle:Ambika_Monday_Demo_Agent` alone after a bundle version is published — org may reject edits to a published bundle.

**Use:**

```bash
sf agent publish authoring-bundle \
  --api-name Ambika_Monday_Demo_Agent \
  --target-org agentforce-org
```

Success looks like: **Validate Bundle ✔ → Publish Agent ✔ → Retrieve Metadata ✔ → Deploy Metadata ✔**.

Publish creates a **new agent version** (e.g. **v2**). It retrieves version metadata into `force-app/main/default/aiAgentDefinitionVersions/Ambika_Monday_Demo_Agent#2/`.

---

## 5. Activate the new version

Builder shows topics for the **active** version only.

```bash
sf agent activate \
  --api-name Ambika_Monday_Demo_Agent \
  --version 2 \
  --target-org agentforce-org
```

If publish created **v3**, use `--version 3`. To list versions, open the agent in **Agentforce** and check the version dropdown, or inspect `force-app/main/default/aiAgentDefinitionVersions/` folder names (`#2`, `#3`, …).

---

## 6. Confirm in the org UI

1. **Setup → Agentforce → Agents → Ambika Monday Demo Agent**
2. Version selector: **v2** (or latest) and status **Active**
3. Topics / graph should include (FAQ-only — no escalation / off-topic / ambiguous):
   - **Agent Router**
   - **FAQ Context Setup**
   - **FAQ Subagent**
   - Action **Answer TableCraft FAQ** → prompt **Ambika TableCraft FAQ Prompt**
4. Hard refresh the browser if the graph is cached

---

## Repeat loop (every time you change `.agent` and want Preview)

```bash
cd /Users/ambika.tiwari/Documents/salesforce_onboarding_notes/my-agentforce-project

# 1) Optional: if you changed the FAQ prompt template
sf project deploy start \
  --metadata GenAiPromptTemplate:Ambika_TableCraft_FAQ_Prompt \
  --target-org agentforce-org \
  --wait 15

# 2) Push agent script from git into org (creates new version N+1)
sf agent validate authoring-bundle \
  --api-name Ambika_Monday_Demo_Agent \
  --target-org agentforce-org

sf agent publish authoring-bundle \
  --api-name Ambika_Monday_Demo_Agent \
  --target-org agentforce-org

# 3) Make that version live for Preview (replace N with newest from publish / UI dropdown)
sf agent activate \
  --api-name Ambika_Monday_Demo_Agent \
  --version 3 \
  --target-org agentforce-org
```

Then in **Agentforce Builder**: hard refresh → version header = **Active** version you activated → **Preview**.

Publish also **retrieves** version metadata into `force-app/main/default/aiAgentDefinitionVersions/Ambika_Monday_Demo_Agent#N/` so git stays aligned with org.

---

## Full one-shot (after git is committed)

Run from repo root when script + prompt in git are ready:

```bash
cd /Users/ambika.tiwari/Documents/salesforce_onboarding_notes/my-agentforce-project

sf agent validate authoring-bundle \
  --api-name Ambika_Monday_Demo_Agent \
  --target-org agentforce-org

sf project deploy start \
  --metadata GenAiPromptTemplate:Ambika_TableCraft_FAQ_Prompt \
  --target-org agentforce-org \
  --wait 15

sf agent publish authoring-bundle \
  --api-name Ambika_Monday_Demo_Agent \
  --target-org agentforce-org

sf agent activate \
  --api-name Ambika_Monday_Demo_Agent \
  --version 2 \
  --target-org agentforce-org
```

Adjust `--version` to match the version publish just created.

---

## What **not** to use for FAQ graph updates

| Command | Problem |
|--------|---------|
| `sf project deploy` on `aiAgentDefinitionVersions/Ambika_Monday_Demo_Agent#1` only | Overwrites org with **old v1 script** (no FAQ topics) if that folder is stale |
| `sf project deploy --metadata Bot:Ambika_Monday_Demo_Agent` on API 68 | Einstein service agents use **AiAgentDefinition** / **AiAgentDefinitionVersion**, not Bot deploy |
| Deploy **data/** CSVs | Not metadata; does not add subagents |

---

## Troubleshooting

| Symptom | Fix |
|--------|-----|
| `CompileAgentScriptError` … `set_faq_context` on router | Use git bundle with **`faq_context_setup`**; validate again |
| Publish: `Answer_TableCraft_FAQ` … must specify input/output | Deploy prompt; ensure **`activeVersionIdentifier`** on [Ambika_TableCraft_FAQ_Prompt](../../force-app/main/default/genAiPromptTemplates/Ambika_TableCraft_FAQ_Prompt.genAiPromptTemplate-meta.xml); retrieve from org if needed |
| Builder still shows 4 topics | Wrong version — **activate** latest; select **v2+** in UI |
| `content cannot be changed once the bundle version is published` | Use **`sf agent publish authoring-bundle`**, not bundle-only metadata deploy |

---

## Related

- [ambika-monday-demo-faq-pipeline.md](../ambika-monday-demo-faq-pipeline.md) — FAQ runtime steps
- [ambika-faq-prompt-guardrails.md](../ambika-faq-prompt-guardrails.md) — prompt checklist
- [pull-from-org.md](./pull-from-org.md) — retrieve other org metadata
