# TableCraft — The All-in-One Dream for OpenTable

---

## 0. Level-Set with the Judges (Breaking the 4th Wall — Slides 1–4)

> *"Before we step into our UAT sign-off review, we want to take 20 seconds to break the fourth wall with you as judges.*
>
> *In the real world, a **UAT Gate Review** happens right before production rollout — long after the initial sales pitch, once the engineering team has already built and tested the system. Because we built this in one week in a sandbox without a live client API, we anchored our build and mock data in real research on **OpenTable**.*
>
> *So in these first four slides, we’ll briefly show you as judges:*
>
> 1. *Our research into OpenTable’s B2B2C platform — including their live Salesforce Agentforce deployment AND the separate competitor AI stack (Concierge AI) they launched in 2025,*
> 2. *Why consolidating those two stacks is the business case behind this build, and how we used OpenTable’s B2B Restaurant Partner Portal to shape our mock CRM and Data 360 schemas.*
> 3. *Then on Slide 5, we put our **UAT delivery hats on** — presenting the completed agent, architecture, security/testing results, and phased production rollout to OpenTable stakeholders for UAT sign-off."*

---



## 1. What Is OpenTable?

OpenTable is a two-sided B2B2C restaurant marketplace connecting **60,000+ restaurants** with **1.9 billion diners per year**:

- **B2B ("OpenTable for Restaurants" / GuestCenter):** Restaurants pay OpenTable to manage their table inventory, reservations, and **Restaurant Profile** — filling out structured basic info (hours, phone, address, cuisine) and uploading unstructured details (PDF menus, parking instructions, dress code, dietary policies, and private dining rules) ([OpenTable Profile & Menu Upload Docs](https://support.opentable.com/s/article/Updating-your-restaurant-profile-in-GuestCenter)).
- **B2C (The OpenTable Diner App):** Diners discover restaurants, research menus/policies, and book, modify, or cancel reservations.

---



## 2. How Is OpenTable Currently Integrated with Salesforce?

OpenTable already runs its core customer and partner support on the Salesforce Platform (**Agentforce, Data 360, Service Cloud, Marketing Cloud, Tableau, and Slack**):

- In **August 2025**, OpenTable launched two **Agentforce** support agents (one for restaurants, one for diners) grounded in **1,500+ Service Cloud knowledge articles harmonized in Data 360**.
- Those Agentforce agents handle **11,000+ support conversations per week** (resolving 73% of inquiries autonomously — a 40% improvement over their legacy chatbot) for account issues, reward points, no-show disputes, and live Service Cloud human escalation.
- *Sources:* [Salesforce OpenTable Customer Story (Aug 2025)](https://www.salesforce.com/customer-stories/opentable/) | [OpenTable Agentforce Implementation Deep Dive](https://www.salesforce.com/customer-stories/opentable-agentforce-implementation/)

---



## 3. Where Can They Do More?

Right now, OpenTable is maintaining **two separate AI stacks** that split the diner journey in half:

- **Stack 1 — Pre-Booking Restaurant Q&A ("Concierge AI"):** Launched in July 2025 on restaurant profile pages, built outside Salesforce using **OpenAI and Perplexity APIs** ([OpenTable Concierge Launch](https://www.opentable.com/blog/press/page/ai-concierge/)). It answers diner questions about menus, parking, dress code, and dietary options from the restaurant's profile — **but it cannot book, modify, or cancel a reservation, and it cannot escalate to a Service Cloud human rep**.
- **Stack 2 — Post-Booking & Account Support (Salesforce Agentforce):** Connected to CRM reservations and Service Cloud Omni-Channel — **but only grounded in general OpenTable corporate help articles, not individual restaurant menus and policies**.
- **The consolidation opportunity:** OpenTable already runs Agentforce and Data 360, and already manages its 60,000+ restaurant partners in Salesforce. Consolidating Concierge AI into their existing Agentforce + Data 360 stack eliminates the split-brain experience between researching a restaurant and booking it.

---



## 4. Our Pitch

OpenTable knows diners need menu, parking, hours, and dietary answers before they commit to a table — **but the deal isn't sealed until that reservation is actually booked.**

Instead of stranding diners in a read-only Q&A widget that can't touch reservations or customer support, make it seamless for diners to take that final step in **one single Agentforce agent** that:

1. **Answers restaurant-specific FAQ, menu, hours, and parking questions** (`subagent faq`, grounded in CRM + Data 360),
2. **Books, modifies, or cancels the reservation in the exact same conversation** (`subagent booking`), and
3. **Creates a Service Cloud case / transfers to a live human rep** (`subagent escalation`, already integrated with Service Cloud Omni-Channel) when an edge case, severe allergy, or large-party request comes up.

---



## 5. How We Mocked the Data from OpenTable → Stepping Into the UAT Roleplay

To make our 1-week sandbox build behave like OpenTable's real environment, we modeled our mock data directly after the two sections of OpenTable's B2B Restaurant Partner Portal:

1. **OpenTable "Basic Information" Tab → Mocked as Salesforce CRM Objects (**`Restaurant__c` **&** `Reservation__c`**):**
  - Contains the structured fields every restaurant fills out (`Restaurant_ID__c`, `Operating_Hours__c`, `Phone_Number__c`, `Cuisine__c`, `City__c`, `Zip_Code__c`), plus 30 mock `Reservation__c` rows across 5 demo restaurants.
2. **OpenTable "Menus & Details" Tab → Mocked in Data 360 (**`ADL_Diner_Restauran`**):**
  - Contains the unstructured PDF menus, parking/valet rules, dress codes, and house policies that restaurants upload under their `restaurant_id`.

**From here on, we put our UAT delivery hats on** — presenting the live demo, our Agentforce & Data 360 architecture, security/testing results, and the phased production rollout (10% → 50% → 100%) to OpenTable stakeholders for **UAT sign-off**.

---



## 6. Slide 6: UAT Sign-Off Agenda *(Data → Solution → Testing → Rollout)*

1. **Diner Journey & Business Value (Persona: Sofia's Evening)**
2. **Data Architecture (**`CRM` **+** `Data 360` **Integration & Digital Wallet Optimization)**
3. **Solution Design & Live Walkthrough (**`New Agent Builder` **+** `Agent Script` **+ Design Patterns)**
4. **Layered Security & Comprehensive Testing Suite (Trust Layer, Testing Center & Trace Debugging)**
5. **ROI, Consumption Economics & Phased UAT Rollout (**`10% → 50% → 100%` **+ The Ask)**

> **Rubric Covered — Criterion 6 (Strategic Presentation & Communication):**
>
> - **Level 3:** *"Well-structured, clear, and confident presentation. Each team member has a distinct, equal role. Communicates both technical and business concepts effectively. Solution’s value framed appropriately for a senior audience."*
> - **Level 4:** *"Highly engaging and persuasive presentation. Expertly fields Q&A and proactively addresses senior stakeholder objections (ROI, security, scalability, consumption). Tailors messaging to resonate with stakeholder priorities. Communicates transformative business impact with authority."*

---



## 7. Slide 7: Persona Journey & Quantifiable Business Value

- **Persona & Journey Map ("Sofia's Evening"):** Sofia's table is 2 hours away and plans change — comparing today's 18-minute queue / disconnected Concierge widget vs. 2-turn resolution in one unified agent.
- **Target KPIs:** `-25%` response time, `>80%` first-contact resolution, higher booking conversion, and `10%` cancel-save rate.

> **Rubric Covered — Criterion 1 (Use Case Identification & Relevance):**
>
> - **Level 3:** *"Clearly defines a relevant, real-world business challenge. Explains how the agent addresses the challenge and provides measurable business value. Customer persona and pain points are evident."*
> - **Level 4:** *"Identifies a high-impact, strategic business challenge. Compellingly articulates quantifiable business value with clear ROI framing. Uses persona-focused storytelling and journey mapping. Positions the solution with market and competitive context."*

---



## 8. Slide 8: Data Architecture (`CRM` + `Data 360`)

- **Structured CRM (**`Restaurant__c`**,** `Reservation__c`**):** Deterministic `before_reasoning` hook (`validate_restaurant_context`) loads `operating_hours`, `escalation_phone_number`, and `current_date_time` in 1 SOQL query (`WITH USER_MODE`), answering routine hours/phone questions in 1 hop with **zero RAG or extra LLM overhead**.
- **Unstructured Data 360 (**`ADL_Diner_Restauran`**):** Restaurant PDFs chunked (`_chunk__dlm`), vectorized (`_index__dlm`), and queried on-demand via Apex (`CLL_DiningKnowledgeRetriever.cls`) scoped by `restaurant_id` — returning grounded chunks directly to `subagent faq` without a separate Prompt Builder LLM hop.

> **Rubric Covered — Criterion 2 (Solution Design & Walkthrough) & Criterion 5 (Business Impact & Consultative Readiness):**
>
> - **Criterion 2 (Level 3):** *"Data 360 integration demonstrated or clearly explained."*
> - **Criterion 5 (Level 4):** *"Consumption-aware architecture: architectural tradeoffs explicitly connected to Digital Wallet impact."*

---



## 9. Slide 9: Solution Design & Agentic Patterns (`Agent Script`)

- **Agent Archetype:** Multi-topic hub-and-spoke (`orchestrator` → `faq`, `booking`, `escalation`) built in **New Agent Builder with Agent Script** (`TableCraft_Agent.agent`)
- **Agentic Design Patterns Applied:**
  1. *Deterministic Pre-Check Gate (*`before_reasoning`*):* Validates `restaurant_id` and hydrates CRM context before planner reasoning.
  2. *Two-Step Save-Offer Gate (*`available when`*):* `cancel_reservation` is locked until `offer_alternative` (`cancel_offer_made == True`) runs.
  3. *Grounded RAG with Explicit Abstention:* Answers strictly from CRM/Data 360 sources or provides the restaurant's phone number + human handoff.
  4. *Context-Preserving Escalation:* Creates a `Case` with an AI summary and routes via Omni-Channel (`flow://Route_CLL_Escalations`).
- **AIforce & Omni-Channel / Surface-Agnostic Strategy:** Deployed on MIAW (Messaging for In-App and Web), web, and mobile-ready; explicit justification of AIforce applicability and stateless Apex action scalability.

> **Rubric Covered — Criterion 2 (Solution Design & Walkthrough):**
>
> - **Level 3:** *"Functional New Agent Builder with Agent Script agent demonstrated. Agent archetype appropriate and well-explained. Guided Design principles evident and applied. Architecture outlined including key API integrations and deployment considerations. AIforce explicitly addressed — either demonstrated or justified as not applicable. At least one Salesforce Agentic Design Pattern referenced, applied, or explained as inapplicable. Data 360 integration demonstrated or clearly explained."*
> - **Level 4:** *"Robust, well-architected New Agent Builder with Agent Script agent with advanced API integrations (can be mocked; team must speak to production scalability). AIforce demonstrated with surface-agnostic deployment strategy. Multiple agentic design patterns applied with strategic justification. Sophisticated deployment and change management plan articulated. Omni-channel deployment demonstrated or fully explained (MIAW, voice, or web). Walkthrough is polished, persuasive, and demonstrates strategic mastery."*

---



## 10. Slide 10: Live Demo Walkthrough

- **4 Live End-to-End Moments in Dev Org:**
  1. Restaurant discovery (`orchestrator`) + grounded hours/parking/policy Q&A (`faq`)
  2. Reservation modification + two-step cancellation save-offer (`booking`)
  3. Plain dietary note (saved on booking) vs. severe allergy guarantee (routed to `escalation` + Service Cloud Case)
  4. Adversarial test (requesting another diner's reservation / prompt injection attempt)

> **Rubric Covered — Criterion 2 (Solution Design & Walkthrough):**
>
> - **Level 3:** *"Functional New Agent Builder with Agent Script agent demonstrated."*
> - **Level 4:** *"Walkthrough is polished, persuasive, and demonstrates strategic mastery."*

---



## 11. Slide 11: Layered Security Measures

- **6 Defense-in-Depth Layers:**
  1. **Identity & Session Scoping:** Signed-in `membership_id` + Last Name + Reservation ID verification.
  2. **Einstein Trust Layer / Salesforce Guardian:** Prompt injection defense, toxicity detection, PII data masking, and zero data retention.
  3. **Least-Privilege Access:** Dedicated agent user, permission sets, FLS, and `WITH USER_MODE` Apex SOQL.
  4. **Deterministic Action Boundaries:** `before_reasoning` and `available when` guards in Agent Script.
  5. **Strict Grounding & Abstention:** Zero invented links or ungrounded facts.
  6. **Human Backstop & Audit Trail:** Reachable from every subagent with Case summary logging.

> **Rubric Covered — Criterion 4 (Security Measures):**
>
> - **Level 3:** *"Key security controls demonstrated: role-based access, permission sets, and input/output filtering. Trust Layer / Salesforce Guardian controls explicitly applied and explained. Proactively explains how controls mitigate common failure types (prompt leakage, policy bypass, unauthorized data access). Security design connected to the use case’s specific risk profile."*
> - **Level 4:** *"Advanced layered security design: platform-native safeguards plus custom controls appropriate to the JTBD. If external MCPs or APIs are used, security assessment articulated (publisher trust, data access scope, action boundaries). Proactive mitigation strategies for complex and compound vulnerabilities. Security design is anticipatory, not just compliant."*

---



## 12. Slide 12: Comprehensive Testing Suite & Trace Debugging

- **Testing Center Suite:** Functional, Guardrail (`100%`), Edge cases, Multi-turn context retention, Perturbation (typos/paraphrase), and Adversarial (`100%`).
- **Trace / Splunk Debugging & Optimization Evidence:**
  - Show the live execution trace proving `faq` answers hours/phone with `GROUNDED` evaluation and 0 redundant RAG action calls.
  - Highlight 3 real bugs caught and fixed by testing: timezone offset conversion, `orchestrator` resolving `restaurant_id` so `faq` never asks the diner for an internal code, and separating plain dietary notes from severe-allergy escalations.

> **Rubric Covered — Criterion 3 (Testing Suite):**
>
> - **Level 3:** *"Functional, edge, and unit testing demonstrated and tied to key business scenarios. Multi-turn context testing demonstrated (agent maintains state across turns). At least one T&S test dimension applied: perturbation, bias, or guardrail regression."*
> - **Level 4:** *"Comprehensive test suite: functional, edge, regression, multi-turn, perturbation, and bias. Splunk trace referenced as part of debugging and optimization evidence. Testing approach demonstrates strong confidence in production resilience."*

---



## 13. Slide 13: ROI, Consumption Model & Phased UAT Rollout (The Ask)

- **Quantifiable ROI (Conservative / Base / Upside):** Support hours returned, cost per contact (`$5.00` human vs. `$0.40` agent), cancel-save revenue, and payback period.
- **Consumption Model Fit (Flex Credits → Outcome-Based):** Why **Flex Credits** fit UAT and initial launch (shared Digital Wallet pool across Agent actions and Data 360 with 75%/90% budget alerts), plus how our `before_reasoning` optimization cuts Flex Credit burn per conversation.
- **Phased Deployment, Change Management & Roadmap:** `10%` UAT pilot in one market with kill switch → `50%` → `100%` with weekly regression loop; MVP+ roadmap (Waitlist, Loyalty subagent, Voice concierge).

> **Rubric Covered — Criterion 5 (Business Impact & Consultative Readiness):**
>
> - **Level 3:** *"Clearly links business value to relevant KPIs, summarized in an effective Business Value Statement or Brief. Consultative approach builds customer confidence. Deployment considerations clearly articulated. Consumption model identified (Flex Credits, outcome-based, or AELA) with a rationale for why it fits the use case. Basic roadmap (MVP+) with performance tracking strategy outlined."*
> - **Level 4:** *"Strong, quantifiable business case with deep industry insight in an executive-ready Brief. Advanced consultative framing for senior stakeholders. Consumption-aware architecture: architectural tradeoffs explicitly connected to Digital Wallet impact. Robust deployment planning including change management. Strategic multi-phase roadmap with optimization strategy. Team confidently handles ROI, cost, and consumption objections."*

---



## Rubric Coverage Matrix (Criteria 1–6 Across Slides)


| Criterion 1: Use Case Identification & Relevance                                                           | Criterion 2: Solution Design & Walkthrough                                                                                                                                             | Criterion 3: Testing Suite                                                                                                 | Criterion 4: Security Measures                                                                                                   | Criterion 5: Business Impact & Consultative Readiness                                                                                                             | Criterion 6: Strategic Presentation & Communication                                                                                          |
| ---------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------- |
| **Slides 1–4** (OpenTable market & competitive context) **Slide 7** (Persona journey & quantifiable value) | **Slide 5** (CRM & Data 360 mock schema) **Slide 8** (CRM + Data 360 integration) **Slide 9** (Agent Script, archetype, patterns, AIforce & MIAW) **Slide 10** (Live demo walkthrough) | **Slide 12** (Testing Center suite: functional, edge, regression, multi-turn, perturbation, adversarial + trace debugging) | **Slide 11** (6-layer security: Identity, Trust Layer / Guardian, Least Privilege, Action Boundaries, Grounding, Human Backstop) | **Slide 8** (Consumption-aware Digital Wallet architecture) **Slide 13** (Executive ROI, Flex Credits vs. Outcome-based, 10%→50%→100% UAT rollout & MVP+ roadmap) | **Slide 0 & Slide 6** (Judge level-set, UAT sign-off agenda, clear team roles) **Slide 13** (The Ask & stakeholder objection handling / Q&A) |


