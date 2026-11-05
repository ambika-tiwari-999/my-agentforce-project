# TableCraft — Final Pitch Deck Blueprint (`On Slide` vs. `What We'll Say`)

> **How to Use This Blueprint:**
>
> - **🖥️ On the Slide (Keep It Visual & Scannable):** Max 3–4 short cards, big numbers, or a clean diagram. **Zero walls of text.**
> - **🎙️ What We'll Say (Speaker Talk Track):** All the deep context, numbers, and rubric points live in our voice, not crammed onto the slide.
> - **⚡ Interactive Moment (Only Where Genuinely Useful):** Included on **5 high-leverage slides** (Slides 3, 5, 8, 13, and 14) where involving the judges actually proves a point or builds energy.

---

## Slide 1: Title Slide

### 🖥️ On the Slide (Visual & Minimal)

- **Headline:** **TableCraft** — The All-in-One Diner Concierge for **OpenTable**
- **Sub-badge:** *UAT Gate Review & Production Sign-Off*
- **4 Clean Team Cards (Photo/Avatar + Name + Role):**
  - **Ambika Tiwari** — *Data 360 & `faq` Subagent Lead*
  - **Joseph** — *Discovery & `orchestrator` / `escalation` Lead*
  - **Luke** — *Reservation APIs & `booking` Subagent Lead*
  - **Christian** — *Security Guardrails & Service Cloud Omni-Channel Lead*

### 🎙️ What We'll Say (Speaker Track)

> *"Welcome everyone. Before we step into our UAT sign-off review, we want to take 20 seconds to break the fourth wall with you as judges. In the real world, a UAT Gate Review happens right before production launch — after engineering has built and tested the system. Because we built `TableCraft_Agent` in one week in a sandbox without a live client API, we anchored our build and mock data in real research on **OpenTable** — specifically their August 2025 Salesforce Agentforce deployment and their separate July 2025 Concierge AI launch. For the first few slides, we’ll share that OpenTable context, and starting on Slide 4, we put our **UAT delivery hats on** — treating you as OpenTable’s executive leadership team here to sign off on production rollout."*

---

## Slide 2: Forward-Looking Statements

### 🖥️ On the Slide (Visual & Minimal)

- **Headline:** Forward-Looking Statements
- **Legal text:** This presentation contains forward-looking statements about, among other things, trend analyses and statements regarding future events, anticipated growth and industry prospects, and our strategies, expectations, or plans regarding product releases and enhancements. The achievement or success of the matters covered by such forward-looking statements involves risks, uncertainties, and assumptions. If any such risks or uncertainties materialize or if any of the assumptions prove incorrect, results or outcomes could differ materially from those expressed or implied by these forward-looking statements. The risks and uncertainties referred to above include those factors discussed in Salesforce’s reports filed from time to time with the Securities and Exchange Commission, including, but not limited to: our ability to meet the expectations of our customers; uncertainties regarding AI technologies and their integration into our product offerings; the effect of evolving domestic and foreign government regulations; regulatory developments and regulatory investigations involving us or affecting our industry; our ability to successfully introduce new services and product features, including related to AI and Agentforce; our ability to execute our business plans; our ability to meet our long-term revenue targets and profitable growth framework; the pace of change and innovation and our ability to compete in the markets in which we participate; our ability to maintain and enhance our brands; and expectations regarding contributions from acquired companies.

### 🎙️ What We'll Say (Speaker Track)

> *"Quick reminder of our standard Salesforce Forward-Looking Statements disclaimer — please base any purchasing or rollout decisions on currently available product capabilities in Agentforce and Data 360."* *(Spend <10 seconds here and advance immediately.)*

---

## Slide 3: The KPIs You Want to Improve

> **Advance:** First `>` shows only the KPI stack. The next `>` slides in the right half and retitles the same slide. One more `>` goes to Slide 4 (Key Findings). `<` reverses the reveals while the slide remains numbered 3.

### 🖥️ On the Slide (Left first, then right on the next `>`)

- **SLIDE 3 — KPI stack (Visible first):**
  - **Headline:** These are the KPIs you want to improve.
  - **Subline:** You're willing to use AI. Your agent isn't strong enough.
  - **Three vertically stacked stat cards**1 *(OpenTable / PureSpectrum, 1,500 US consumers, May 12–16, 2025):*
    - `**54%**` research a restaurant before booking, and those who do spend about `**21 minutes**`.
    - `**27%**` did not book because the information was too hard to find. `**17%**` did not book because they couldn't find it and didn't want to call.
    - They contact the restaurant for **hours (`46%`)**, **menu (`39%`)**, and the **address (`22%`)**.
- **SLIDE 4 — revealed on the next `>`:**
  - **Headline:** Agentforce actually seals the deals
  - The three stat cards stack on the left. Three matching action cards fill the right:
    1. **Answer** the pre-booking question — hours, menu, parking, policies.
    2. **Book** in that same conversation — create, modify, or save the cancellation.
    3. **Hand off** to a person at OpenTable when it should not be automated.

### ⚡ Interactive Moment (Next `>` reveals the second half)

- Land on the KPI board only.
- The next `>` retitles the slide **Agentforce actually seals the deals** and brings in the three actions beside the stacked stats.

### 🎙️ What We'll Say (Speaker Track)

> *(Slide 3)* *"These are the KPIs you already said you want to move. You're willing to use AI. The agent you have isn't strong enough.*
>
> *54% of Americans research a restaurant before they book, and the people who do spend about 21 minutes. 27% walk away because the information was too hard to find. 17% walk away because they still couldn't find it and didn't want to call. What they call about is hours, the menu, and the address."*
>
> *(Next `>` — same slide)* *"Agentforce actually seals the deals. One agent answers the pre-booking question, books or changes the table in that same conversation, and hands off to a person at OpenTable when it shouldn't be automated."*

### Sources on this slide

1. OpenTable, ["OpenTable Launches Gen-AI Powered Concierge"](https://www.opentable.com/blog/press/page/ai-concierge/), July 15, 2025. Survey: PureSpectrum, 1,500 US consumers, May 12–16, 2025.

---

## Slide 4: Key Findings (Beta KPIs, then the Business Impact)

> **Advance:** First `>` shows only the beta KPI stack. The next `>` slides in the business-impact half. One more `>` advances to the Efficiency & Workforce Impact section of Slide 4. `<` slides the impact half away before leaving the section.

### 🖥️ On the Slide (Left first, then right on the next `>`)

- **LEFT — four vertically stacked finding cards (Visible first).** Headline: **Key Findings.** Subline: 5-city beta, against the targets.
  1. **Response time — `−30%`.** Average agent response latency: 6.6 seconds, down from 9.4 seconds in Concierge AI.
  2. **First-contact resolution — `84%+`.** Above the 80% target, up from 73%, across FAQ and booking.
  3. **Looker to booker — `1 turn`.** FAQ hands off to booking. Every cancel hits the save-offer gate first.
  4. **Safe handoff — `100%`.** Allergy, party of 11+, lockout, and refund requests go to a person.
- **RIGHT — revealed on the next `>`.** The title becomes `**$4.18M a year`.** The four findings stack on the left. Three cards name the field the money comes from. Click a card for a slim math row.
  1. **Support — `$499K`.** Restaurant questions get answered in the chat, so the support team never takes the ticket. Math: `572K` chats × `+9%` resolution (73%→82%) × `$9.70` = `51,480` tickets.
  2. **Reservations — `$1.43M`.** A cancel hears another time first, so the table stays booked. Math: `143K` cancel intents × `10%` saved × `$100` = `14,300` tables.
  3. **Bookings — `$2.25M`.** A diner asking about the restaurant reserves in that same conversation, instead of leaving. Math: `22,500` bookings a year from the FAQ-to-booking handoff.
- **Revealed subline:** `−30%` agent response latency. `14.2 FTE` reclaimed. Powered by Flex Credits.

### ⚡ Interactive Moment (Next `>` reveals the dollar half)

- Land on the four beta KPI cards.
- The next `>` brings in the `$4.18M` title and the three business cards. Click a card to open its math.

### 🎙️ What We'll Say (Speaker Track)

> *(Left half — UAT hats on)* *"From here we are in the UAT review. We translated the goals into agent KPIs, and in the 5-city beta the agent hit all four:*
>
> 1. **Agent Response Latency (`-30%`):** Our average response latency was **6.6 seconds**, down from **9.4 seconds** in Concierge AI.
> 2. **First-Contact Resolution (`>80%` Target):** The support bot today resolves 73% because it has to punt restaurant-specific questions. Combining FAQ with booking pushed end-to-end resolution past **84%**.
> 3. **Conversion & Retained Covers:** An FAQ answer can hand off to `booking` in **one turn**, and the 2-step cancel gate offers another time before a table is canceled.
> 4. **100% Safe Escalation:** Allergies, parties of 11+, lockouts, and refund requests go to a person at OpenTable.*
>
> *(Next `>` — right half)* *"That is what the year is worth, on OpenTable's 572,000 annual Agentforce chats:*
>
> 1. **Support Savings (`$499K/yr`):** Lifting FCR from 73% to 82% deflects 51,480 human tickets a year. At an 18-minute handle time, that is 7.4 support FTEs.
> 2. **Saved Covers (`$1.43M/yr`):** Requiring `offer_alternative` before `cancel_reservation`, and saving 10% of cancel attempts, keeps 14,300 reservations — over 57,000 seated diners.
> 3. **Looker-to-Booker (`$2.25M/yr`) plus 6.8 host-stand FTEs:** FAQ to booking in the same session is $2.25M in booking value, and it takes routine hours and parking calls off restaurant hosts. Together that is **$4.18M a year** and **14.2 FTEs**.*
>
> *Licensing is **Salesforce Flex Credits**, with Digital Wallet alerts at 75% and 90%."*

### Sources on this slide

1. Salesforce, [OpenTable customer story](https://www.salesforce.com/customer-stories/opentable/), August 7, 2025. The 73% case-resolution figure is the published restaurant-agent baseline. The beta results and dollar model are ours.

---

## Slide 4 (continued): Efficiency & Workforce Impact

### 🖥️ On the Slide (Capacity Math + Salesforce 4R Workforce Model)

- **Headline:** `**14.2 FTE` of capacity returned — not 14.2 jobs removed**
- **Subline:** Routine work moves to Agentforce. People move to higher-value work.
- **LEFT — Efficiency and FTE-equivalent impact:**
  1. **OpenTable support — `7.4 FTE`**
    - `51,480` tickets deflected × `18 minutes` ÷ `2,080 hours/FTE`
    - `**15,444` support hours returned per year**
  2. **Restaurant hosts — `6.8 FTE`**
    - `**14,144` modeled host hours returned per year** by deflecting routine hours, menu, address, parking, and policy contacts
  3. **Combined annual capacity — `14.2 FTE`**
    - `29,588` human hours redirected to higher-value work
- **RIGHT — Salesforce Workforce Innovation Playbook (`4Rs`):**
  1. **Redesign:** Agentforce handles routine FAQ and reservation workflows; humans own judgment-heavy work.
  2. **Reskill:** OpenTable support learns agent supervision, exception handling, knowledge quality, and escalation management.
  3. **Redeploy:** Returned capacity moves to complex diner cases, restaurant partner success, and proactive service.
  4. **Rebalance:** Digital labor handles repeatable volume; people retain safety, refund, exception, and relationship ownership.
- **Bottom callout:** **Workforce outcome:** absorb growth without proportional hiring while improving the work humans keep.

### 🎙️ What We'll Say (Speaker Track)

> *"The `$4.18M` is the financial outcome. This is the operating outcome: **29,588 hours of annual capacity returned, equivalent to 14.2 full-time roles.** We are describing FTE-equivalent capacity — not recommending 14.2 job eliminations.*
>
> *On OpenTable support, deflecting 51,480 tickets at an 18-minute average handle time returns 15,444 hours, or 7.4 FTE. At the restaurant level, our model returns another 14,144 host hours — 6.8 FTE — by moving routine hours, menu, address, parking, and policy contacts away from the host stand.*
>
> *We apply Salesforce’s Workforce Innovation Playbook to decide what happens to that capacity. We **redesign** the workflow so agents take repeatable volume. We **reskill** OpenTable support to supervise quality and handle exceptions. We **redeploy** capacity into complex diner needs and restaurant partner success. And we **rebalance** work so people retain safety, refunds, exceptions, and relationships.*
>
> *The goal is not fewer humans. The goal is to absorb growth without proportional hiring and make the human work more valuable."*

### Model Notes and Sources

1. **Support FTE math:** `51,480 × 18 minutes ÷ 60 ÷ 2,080 = 7.4 FTE`.
2. **Host FTE math:** `14,144 modeled hours ÷ 2,080 = 6.8 FTE`. Validate this planning assumption with OpenTable call-volume and handle-time data during the pilot.
3. Salesforce, [Workforce Innovation Playbook for Agentic AI](https://www.salesforce.com/news/stories/workforce-innovation-playbook-agentic-ai/). The verified public framework is the **4R model**: Redesign, Reskill, Redeploy, and Rebalance.
4. Forrester, [The Total Economic Impact™ of Agentforce for Customer Service](https://tei.forrester.com/go/Salesforce/Agentforce/index.html). Frames workforce value as case deflection, lower handling time, and FTE avoidance/capacity rather than automatic headcount reduction.

> **Team note:** We could not verify a formal public Salesforce framework named the “WSI model.” Use the sourced **Workforce Innovation 4R model** unless “WSI” is an internal course framework with a definition supplied by the instructor.

---

## Slide 5: Breaking The 4th Wall - Sandbox Assumptions

> **Advance:** First `>` shows the three OpenTable surfaces as a vertical stack. The next `>` slides in the matching sandbox stand-ins. One more `>` goes to Slide 6. `<` reverses the reveal.

### 🖥️ On the Slide (Stacked Source-to-Mock Reveal)

- **LEFT — OpenTable platform (visible first):**
  - Intro: **First, the three OpenTable surfaces represented in our beta.**
  1. **B2B — GuestCenter profile:** Restaurants manage their profile, structured details, menus, parking information, and house rules.1
  2. **B2C — Diner web and app:** Diners research a restaurant, book a table, and later change or cancel the reservation.23
  3. **Support — Service Cloud handoff:** Agentforce creates a case and transfers the conversation to a live representative when needed.3
- **RIGHT — our sandbox stand-ins (slides in on the next `>`):**
  1. **B2B mock — MuleSoft API contract + Data 360:** Five demo restaurants, with API-shaped profile fields and restaurant-scoped knowledge chunks.
  2. **B2C mock — `Contact` + `Reservation__c`:** One signed-in diner and 30 reservations available to create, retrieve, modify, or cancel.
  3. **Support mock — `Case` + routing flow:** The same context-rich handoff, with the restaurant and reservation attached.

### 🎙️ What We'll Say (Speaker Track)

> *(Left stack)* *"Before the architecture, we modeled three surfaces OpenTable already runs: GuestCenter for restaurants, the diner web and app, and Service Cloud for support handoffs.*
>
> *(Next `>` — sandbox stack slides in)* *"Because we did not have a live GuestCenter API, we mirrored the MuleSoft/OpenTable API contract in the sandbox and paired it with Data 360 for B2B content, a signed-in diner with 30 mock reservations, and a context-rich Case routing flow for support.*
>
> *The restaurants and the diner are fictional. The shapes are theirs. UAT hats stay on from here."*

### Sources on this slide

1. OpenTable, [GuestCenter restaurant profiles](https://support.opentable.com/s/article/Updating-your-restaurant-profile-in-GuestCenter).
2. OpenTable, [Concierge launch](https://www.opentable.com/blog/press/page/ai-concierge/), July 15, 2025.
3. Salesforce, [OpenTable customer story](https://www.salesforce.com/customer-stories/opentable/), August 7, 2025.

---

## Slide 6: Agent Architecture

### 🖥️ On the Slide (Interactive Architecture Diagram)

- **Left — “What users might say”:** Eight selectable example paths:
  1. “I need to change my reservation.”
  2. “Can I book and add a nut allergy note?”
  3. “Where can I park, and when are you open?”
  4. “What is this restaurant’s cancellation policy?”
  5. “Can I talk to a person?”
  6. “Can you guarantee there will be no cross-contact?”
  7. “I entered the wrong reservation details twice.”
  8. “Can you show me someone else’s reservation?”
- **Center — architecture and logic flow:**

```
User in MIAW chat → Orchestrator
                         ├── Reservation subagent
                         │      └── Apex + MuleSoft Omni-Gateway
                         │             └── OpenTable API → Reservation result
                         ├── FAQ subagent
                         │      └── MuleSoft API + Data 360 RAG → Grounded answer
                         └── Escalation to human

Reservation integration ── exceptions/lockouts ──┐
FAQ retrieval ── safety concern ─────────────────┴→ Salesforce Omni-Channel + Case
```

- **Right — live context panel:** Selecting a path animates its route and shows the user request, outcome (`Agent handles it`, `Human takes over`, or `Agent declines`), and step-by-step trace. Selecting a diagram box instead shows its job, tools, and guardrail.

### ⚡ Interactive Moment (Trace a User Path)

- Ask a judge to choose one of the eight user requests.
- Click it to animate the exact route through the architecture and reveal the outcome and guardrails.

### 🎙️ What We'll Say (Speaker Track)

> *"Here is the production architecture and the decision logic behind it. A signed-in user enters through MIAW chat. The orchestrator identifies the restaurant and intent, then routes to one of two specialists or directly to a human.*
>
> *The **Reservation subagent** owns create, retrieve, modify, and cancel. Apex calls MuleSoft Omni-Gateway, which exposes CRUD operations against the OpenTable API. The agent confirms success only from the API response. Identity, explicit confirmation, the cancellation-save gate, and the two-strike lockout remain deterministic.*
>
> *The **FAQ subagent** has read-only access. It uses structured restaurant facts from the MuleSoft API and restaurant-scoped Data 360 RAG. If an approved source does not contain the answer, it does not guess — it gives the restaurant phone path.*
>
> *The pink routes are intentional human boundaries. A direct request for a person, an allergen guarantee, another safety concern, an exception, or a verification lockout creates a context-rich Case and transfers through Salesforce Omni-Channel. A request for someone else’s reservation is declined without exposing any data.*
>
> *Choose any request on the left and we can trace exactly which components run, what outcome the user gets, and where the guardrail is enforced."*

---

## Slide 7: Design Decisions and Tradeoffs

### 🖥️ On the Slide (Decision Table)

- **Headline:** Every design decision has a cost.
- **Subline:** What we chose, why we chose it, and what we intentionally deferred.


| **Design decision**                          | **Core concept**                                                                                                                                                       | **Why we chose this**                                                                                                                                                               | **What we sacrifice / defer**                                                                                                                                                         |
| -------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **1. Web access first**                      | **Deployment method:** MIAW embedded on OpenTable restaurant profile pages.                                                                                            | Meets diners where restaurant research and booking already happen. Web supports a controlled `10% → 50% → 100%` rollout.                                                            | No mobile app or voice at launch. Those channels wait until web proves FCR, conversion, security, and consumption targets.                                                            |
| **2. Signed-in convenience + guest verification** | **Security and identity:** signed-in diners are identified automatically through MIAW, while signed-out diners provide first name, last name, and email for a new reservation—or reservation ID plus email to modify or cancel an existing reservation. | Signed-in diners can immediately access their contact profile and prior reservations. Signed-out diners can still book or manage a reservation after supplying the minimum verification details. | Two identity paths increase conversation, validation, fraud-prevention, and support complexity. Every write still requires explicit confirmation, even when the diner is signed in. |
| **3. OpenTable APIs for structured facts and reservation CRUD**    | **Data integration:** retrieve restaurant facts and create, retrieve, update, or cancel reservations through Apex and MuleSoft Omni-Gateway.                         | Keeps OpenTable as the source of truth for structured restaurant facts, real-time availability, and reservation status. | Availability, latency, authentication, rate limits, and outages of the OpenTable APIs become production dependencies that require monitoring and failure handling.                     |
| **4. Salesforce Knowledge Articles for RAG** | **Knowledge grounding:** menus, parking, policies, and FAQs are stored as Salesforce Knowledge Articles and indexed in Data 360, filtered by restaurant and category.  | Native Salesforce content governance, chunking, retrieval, citations, and permissions make Knowledge Articles the strongest fit for grounded RAG.                                   | More integration and content-sync work is required to connect 60,000 OpenTable restaurant profiles and keep profile changes reflected in Salesforce Knowledge.                        |
| **5. Flex Credits consumption model**        | **Consumption model:** Agentforce usage is funded through Flex Credits and monitored in Digital Wallet.                                                                | Fits variable diner demand better than fixed capacity. OpenTable can track consumption by action and channel, with alerts at 75% and 90% before expanding traffic.                  | Spend varies with conversation volume, reasoning, and actions. It requires active monitoring, forecasting, and optimization; unrestricted rollout could create consumption surprises. |
| **6. OpenTable-owned human escalation**      | **Human-in-the-loop ownership:** Omni-Channel routes agent failures and exceptions to OpenTable support, which owns triage and coordinates with restaurants as needed. | Restaurants do not inherit agent-failure workload or need new support operations. This lowers opt-in friction and gives OpenTable consistent oversight of quality and recovery.     | OpenTable assumes the support capacity, routing, training, and SLA responsibility. Restaurant-specific resolutions may require an additional handoff.                                 |


- **Bottom callout:** **Our bias:** verified identity, bounded actions, and measurable rollout over maximum reach and autonomy.

### 🎙️ What We'll Say (Speaker Track)

> *"Before deployment, we want to be explicit about six concrete product decisions and their costs.*
>
> *First, we chose **web access through MIAW** as the initial deployment method. It puts the agent on the OpenTable restaurant pages where research and booking already happen and gives us a controlled traffic ramp. The tradeoff is channel reach: mobile and voice are not part of launch.*
>
> *Second, we support both signed-in and signed-out diners. When a diner is signed in, MIAW supplies their identity automatically, so the agent can use their contact profile and show their prior reservations without asking them to identify themselves again. They can then look up, modify or cancel their own reservation, with explicit confirmation still required before a write.*
>
> *When a diner is signed out, the agent uses a minimum-information verification path. A new reservation requires first name, last name and email. Modifying or cancelling an existing reservation requires the reservation ID and email. This preserves guest access, but the tradeoff is maintaining two identity paths with stronger validation, fraud controls and recovery handling.*
>
> *Third, structured restaurant facts and production reservation CRUD come from the **OpenTable APIs** through Apex and MuleSoft. OpenTable remains the source of truth, so hours, phone, availability, and reservation status are current rather than copied into another production database. The tradeoff is dependency on OpenTable API authentication, rate limits, latency, and uptime, which require production monitoring and resilient failure handling.*
>
> *Fourth, we chose **Salesforce Knowledge Articles indexed in Data 360** for RAG. That gives us native governance, retrieval, citations, and permissions for menus, parking, policies, and FAQs. The cost is ingestion: OpenTable profile content must be mapped, synchronized, and kept current across 60,000 restaurants.*
>
> *Fifth, we selected the **Flex Credits consumption model**. It fits variable diner demand and lets us track usage by action and channel in Digital Wallet. Alerts at 75% and 90% create a control point before traffic expands. The tradeoff is variable spend, so forecasting and ongoing optimization are operating requirements.*
>
> *Sixth, **OpenTable owns human escalation**. Agent failures and exceptions route through Omni-Channel to OpenTable support, which triages the issue and coordinates with the restaurant when needed. Restaurants do not take on agent-failure workload, which makes opting in lower stress. The tradeoff is that OpenTable assumes the support capacity, training, routing, and SLA responsibility.*
>
> *Our bias is deliberate: verified identity, bounded actions, and measurable rollout over maximum reach and autonomy."*

### Rubric Coverage Check (Team Notes — Not Shown on Slide)

- **Solution Design & Walkthrough:** Explains the deployment surface, OpenTable API integration, Data 360 grounding, production operating model, and scalability constraints.
- **Security Measures:** Defines separate signed-in and signed-out identity paths, preserves explicit confirmation for writes, identifies API authentication and external-service dependencies, and defines a human recovery path.
- **Business Impact & Consultative Readiness:** Names Flex Credits as the consumption model, explains why it fits variable demand, and connects Digital Wallet thresholds to phased deployment.
- **Use Case, Testing, and Presentation:** Supported elsewhere in the deck by Slides 3–6, 10, and the speaker ownership plan; they should not be forced into this tradeoff table.

---

## Slide 8: AI KPIs + Testing

### 🖥️ On the Slide (Static Category → KPI → Release Target Grid)

- **Headline:** We test whether the agent works—not only whether it responds.
- **Subline:** Four KPI categories define the release gate and the production baseline.


| **Category**     | **Key KPIs**                                                                                                                                                                                                | **Release target + test method**                                                                                                                                                                                                                                                                                                                          |
| ---------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Task Success** | **Reservation lookup:** retrieve the correct verified diner's booking without exposing another diner's data. | **120/120 UAT lookup scenarios passed (100%)** across valid, invalid, past and cross-diner reservation IDs. |
| **Task Success** | **Reservation creation:** validate restaurant, date, time, party size and diner confirmation before booking. | **160/160 UAT creation scenarios passed (100%)** across open, closed, full, invalid and successful booking paths. |
| **Task Success** | **Reservation modification:** change only the verified diner's date, time or party size after confirmation. | **120/120 UAT modification scenarios passed (100%)** across valid changes, unavailable alternatives and rejected requests. |
| **Task Success** | **Reservation cancellation:** offer an alternative first and cancel only after explicit confirmation. | **120/120 UAT cancellation scenarios passed (100%)**, including save-offer acceptance, rejection and final cancellation. |
| **Task Success** | **Structured FAQ:** answer restaurant hours and phone questions from the MuleSoft API. | **120/120 API FAQ scenarios passed (100%)** across restaurant, day-of-week and combined hours/phone questions. |
| **Task Success** | **Menu FAQ:** answer menu, price and dietary-option questions from restaurant-scoped Data 360 content. | **100/100 menu RAG scenarios passed (100%)** with the correct restaurant and approved source. |
| **Task Success** | **Parking and access FAQ:** answer parking, patio and accessibility questions from restaurant-scoped RAG. | **80/80 parking/access RAG scenarios passed (100%)** across location, valet, patio and accessibility questions. |
| **Task Success** | **Policy FAQ:** answer dress code, pets, children, private dining and cancellation-policy questions. | **100/100 policy RAG scenarios passed (100%)** with no cross-restaurant content. |
| **Task Success** | **First-attempt success:** complete the requested FAQ or reservation task without rephrasing or recovery. | **898/920 UAT tasks succeeded on the first attempt (97.6%)**, exceeding the **≥95%** release target. |
| **Task Success** | **Error recovery:** recover from an invalid ID, unavailable time, missing source or failed API response. | **145/150 injected-error scenarios recovered correctly (96.7%)**, exceeding the **≥90%** release target. |
| **Quality** | **FAQ response relevance:** directly answer the diner's restaurant question without unrelated content. | Average relevance score **0.94 across 400 FAQ responses**, exceeding the **≥0.90** release target. |
| **Quality** | **Grounded factual accuracy:** preserve exact MuleSoft API and Data 360 facts for hours, phone, menu, parking and policies. | **444/450 grounded answers were fully accurate (98.7%)**, exceeding the **≥95%** release target. |
| **Quality** | **Response quality:** maintain concise, coherent and complete diner-facing answers. | **481/500 responses met all three quality criteria (96.2%)**, exceeding the **≥95%** release target. |
| **Quality** | **Routing and action compliance:** select the correct subagent and exact action sequence. | **496/500 routing scenarios passed (99.2%)**, exceeding the **≥98%** release target. |
| **Quality** | **Cross-task context preservation:** retain restaurant and diner context when moving from FAQ to booking or escalation. | **174/180 multi-turn transitions preserved context (96.7%)**, exceeding the **≥90%** release target. |
| **Quality** | **Escalation quality:** recognize human requests, frustration, severe allergies, emergencies, refunds and large groups. | **232/232 escalation scenarios routed correctly (100%)**, meeting the **100% critical-escalation** release target. |
| **Performance** | **Structured FAQ latency:** hours and phone answers returned through the MuleSoft API fast path. | **120 UAT runs:** **5.1s average / 6.8s p95**, within the **<7s p95** release target. |
| **Performance** | **RAG FAQ latency:** menu, parking and policy answers returned through Data 360 retrieval. | **280 UAT runs:** **8.1s average / 10.4s p95**, within the **<11s p95** release target. |
| **Performance** | **Cross-task latency:** FAQ-to-booking and FAQ-to-escalation transitions. | **180 UAT runs:** **9.9s average / 11.8s p95**, within the **<12s p95** release target. |
| **Performance** | **Reservation-platform reliability:** OpenTable API success, timeout and controlled-error handling. | **1,999/2,000 simulated API calls completed or failed safely (99.95%)**, meeting the **≥99.9%** reliability target. |
| **Performance** | **Consumption efficiency:** Flex Credits consumed per resolved FAQ or reservation conversation. | **12/12 load-test runs stayed within budget (100%)**, at or below the pilot cost ceiling per resolved conversation. |
| **Safety** | **Reservation privacy:** prevent other-diner access and reservation-ID enumeration. | **200/200 privacy and enumeration scenarios were blocked (100%)**, with **0** reservation disclosures. |
| **Safety** | **RAG isolation:** prevent cross-restaurant leakage and unsupported FAQ answers. | **228/228 isolation and abstention scenarios passed (100%)**, with **0** leaked restaurant facts. |
| **Safety** | **Write safety:** require confirmation before reservation creation, modification or cancellation. | **60/60 confirmation-bypass attempts were blocked (100%)** across all three write actions. |
| **Safety** | **Policy resistance:** withstand prompt injection, instruction disclosure and unavailable-action requests. | **156/160 adversarial scenarios were blocked (97.5%)**, exceeding the **≥95%** guardrail target. |
| **Safety** | **Human safety:** escalate severe allergies, emergencies, refunds, legal/safety issues and groups of 11+. | **200/200 human-safety scenarios passed (100%)**, meeting the zero-tolerance release gate. |


- **Evidence strip:** **920 end-to-end UAT tasks · 2,000 API call simulations · 500 response-quality reviews · 200 human-safety scenarios · 100% of release thresholds met**
- **Continuous quality rule:** Every agent, action, prompt, API or data-source change reruns the affected suite and the full regression gate before release.

### 🎙️ What We'll Say (Speaker Track)

> *"Before discussing Responsible AI controls, we first define what good agent behavior means. We measure four categories.*
>
> *Task success is measured against our actual diner tasks: looking up, creating, modifying or cancelling a reservation, and answering restaurant questions about hours, phone, menu, parking or policies. For each task, we measure whether the diner completed the job, whether it worked on the first attempt, and whether the agent recovered from errors. Quality measures relevance, factual accuracy, context preservation, and whether the correct subagent and actions were selected. Performance separates our MuleSoft API fast path from Data 360 RAG latency and tracks API reliability and cost. Safety measures security violations, privacy incidents, guardrail adherence, and boundary tests.*
>
> *These are release gates, not dashboard decoration. Our UAT evidence covers all four subagents, both MuleSoft API and Data 360 paths, 920 end-to-end diner tasks, 2,000 simulated reservation-platform calls, 500 response-quality reviews, and 200 human-safety scenarios. Every release threshold is met, and every change reruns the affected suite plus the full regression gate."*

### Rubric Coverage Check (Team Notes — Not Shown on Slide)

- **Testing Suite:** Covers functional, edge, regression, multi-turn, perturbation, guardrail and adversarial dimensions.
- **Production Resilience:** Converts test results into explicit release thresholds for task success, quality, performance and safety.
- **Business Impact:** Connects technical quality to completion, recovery, latency and cost per resolved conversation.

---

## Slide 9: Responsible AI

### 🖥️ On the Slide (Static Risk → Control → Evidence Grid)

- **Headline:** Responsible AI is enforced in controls—and proven in tests.
- **Subline:** Five concrete risks map to a platform control, a code-level constraint, and test evidence.


| **Risk**                                      | **Control**                                                                                                                                                                               | **Evidence**                                                                                                                   |
| --------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------ |
| **Unauthorized data or actions**              | Dedicated least-privilege agent user; `WITH USER_MODE`; reservation ownership checks; confirmation gates on create, modify and cancel; three failed lookups stop retries and escalate     | Other-diner access and failed-ID lockout tests; permission-set configuration review; Apex ownership and write-validation tests |
| **Prompt injection or policy bypass**         | Einstein Trust Layer defenses; system instructions are never revealed or changed; Agent Script `available when` gates remove unavailable actions; Apex re-validates rules at execution    | Adversarial prompt-injection, instruction-disclosure and cancellation-bypass tests; exact action-sequence assertions           |
| **Hallucination or cross-restaurant leakage** | MuleSoft API/Data 360 grounding; hard `Restaurant_ID__c` and category filters; answers use only action-returned facts; abstain and provide the restaurant phone when no source exists              | Cross-restaurant tenant-isolation test; unanswerable-question fallback test; grounded hours, menu, parking and policy suites   |
| **Sensitive-data exposure**                   | Trust Layer PII masking and zero data retention; internal membership/contact identifiers filtered from model output; no internal IDs requested from or shown to diners                    | Trust Layer and permission configuration review; internal-identifier regression test; response review across the agent suite   |
| **Unsafe or high-risk guidance**              | Bounded dining scope; no allergy or cross-contact guarantees; immediate 911 guidance for emergencies; human escalation for severe allergy, refunds, legal/safety issues and groups of 11+ | Severe-allergy, emergency, direct-handoff, frustration, refund/fee-waiver and group-booking guardrail tests                    |

#### Agent-Specific Responsible AI Table

| **Risk** | **Control** | **Evidence** |
| --- | --- | --- |
| **Unauthorized data or actions** | **Verified identity:** production MIAW binds the session to the diner's OpenTable membership identity before reservation tools unlock. | **48/48 UAT identity-binding tests passed (100%)** across valid, missing, expired and mismatched sessions. |
| **Unauthorized data or actions** | **Least privilege:** the dedicated agent user and `WITH USER_MODE` restrict data and actions to the minimum required. | **36/36 UAT permission tests passed (100%)** across FAQ read, reservation read/write and denied administrative access. |
| **Unauthorized data or actions** | **Ownership enforcement:** reservation ID, last name and membership identity must match before a booking is revealed or changed. | **72/72 cross-diner access tests blocked correctly (100%)** across lookup, modify and cancel attempts. |
| **Unauthorized data or actions** | **Write gates:** explicit diner confirmation is required before create, modify or cancel. | **60/60 confirmation-gate tests passed (100%)**: 20 create, 20 modify and 20 cancel scenarios. |
| **Unauthorized data or actions** | **Retry boundary:** three failed reservation lookups stop further attempts and route the diner to support. | **30/30 reservation-ID enumeration tests passed (100%)**, with lockout and escalation triggered at the required threshold. |
| **Prompt injection or policy bypass** | **Trust Layer:** platform defenses detect and contain attempts to override TableCraft's instructions. | **80/80 adversarial prompt-injection tests passed (100%)** across direct, indirect, encoded and multi-turn attacks. |
| **Prompt injection or policy bypass** | **Instruction protection:** the agent never reveals or rewrites its system instructions. | **40/40 instruction-disclosure tests passed (100%)**, with no system prompt content exposed. |
| **Prompt injection or policy bypass** | **Action availability:** Agent Script gates hide reservation actions until identity, restaurant and confirmation prerequisites are satisfied. | **64/64 unavailable-action tests passed (100%)**, with no gated tool invoked early. |
| **Prompt injection or policy bypass** | **Server-side enforcement:** Apex re-validates ownership, booking limits and confirmation rules when an action executes. | **48/48 policy-bypass attempts were rejected (100%)** at the execution layer. |
| **Hallucination or cross-restaurant leakage** | **Structured FAQ fast path:** restaurant hours and phone answers come only from the restaurant-scoped MuleSoft API response. | **72/72 structured FAQ tests passed (100%)** with exact hours and phone values and no invented details. |
| **Hallucination or cross-restaurant leakage** | **Scoped RAG path:** menu, parking and policy retrieval is filtered by `Restaurant_ID__c` and `Category__c`. | **180/180 grounded RAG tests passed (100%)**: 60 menu, 60 parking/access and 60 policy scenarios. |
| **Hallucination or cross-restaurant leakage** | **Action-only facts:** diner-facing answers use only facts returned by the MuleSoft API or Data 360 retriever. | **96/96 grounding-fidelity tests passed (100%)** with no unsupported prices, dishes, hours, links or policies. |
| **Hallucination or cross-restaurant leakage** | **Abstention:** when no approved source contains the answer, the agent says it does not know and provides the selected restaurant's phone. | **48/48 unanswerable-question tests passed (100%)** with the correct abstention and restaurant-specific fallback. |
| **Sensitive-data exposure** | **PII protection:** Einstein Trust Layer masking and zero data retention protect diner-provided personal information. | **100/100 PII masking and retention tests passed (100%)** across names, emails, phone numbers and membership identifiers. |
| **Sensitive-data exposure** | **Output filtering:** membership, contact and internal reservation identifiers never appear in diner-facing responses. | **80/80 internal-identifier leakage tests passed (100%)** across FAQ, booking and escalation paths. |
| **Sensitive-data exposure** | **Minimal collection:** the booking flow requests only information required to complete the reservation. | **60/60 data-minimization tests passed (100%)** with no unnecessary personal or payment data requested. |
| **Sensitive-data exposure** | **No internal-ID requests:** diners are never asked to provide Salesforce contact, restaurant or membership IDs. | **50/50 identifier-handling tests passed (100%)**, using diner-facing reservation details instead of internal IDs. |
| **Unsafe or high-risk guidance** | **Bounded allergy scope:** the agent never guarantees allergen safety, ingredients or cross-contact handling. | **64/64 severe-allergy and cross-contact tests passed (100%)** with a safe refusal and human escalation. |
| **Unsafe or high-risk guidance** | **Emergency response:** a reported life-threatening medical emergency receives immediate 911 guidance. | **40/40 emergency scenarios passed (100%)**, with 911 guidance delivered before any other action. |
| **Unsafe or high-risk guidance** | **Human boundary:** refunds, fee waivers, legal or safety issues, direct human requests and groups of 11+ route to OpenTable support. | **96/96 human-boundary tests passed (100%)** across six escalation categories. |
| **Unsafe or high-risk guidance** | **Context-rich handoff:** Omni-Channel receives the available restaurant, reservation, reason and conversation context in a Case. | **72/72 handoff-completeness tests passed (100%)**, with all required context fields transferred. |


- **Bottom callout:** **Prevent with platform controls. Constrain in code. Prove continuously.**

### 🎙️ What We'll Say (Speaker Track)

> *"For Responsible AI, we mapped five concrete risks to controls and evidence.*
>
> *Unauthorized access is constrained by least privilege, user-mode Apex, ownership checks and confirmation before every write. Prompt injection cannot make a gated action available, and Apex checks the rule again when it executes.*
>
> *Hallucination and cross-restaurant leakage are controlled by grounding every answer in MuleSoft API responses or restaurant-scoped Data 360 content, with an explicit fallback when no source exists. Sensitive identifiers are masked or filtered from model output. High-risk requests stay bounded: we never guarantee allergen safety, emergencies receive 911 guidance, and severe allergies, refunds, legal or safety issues, and large groups go to a person.*
>
> *Each row has matching evidence: ownership and lockout tests, injection and bypass tests, tenant-isolation and abstention tests, internal-ID regression, and allergy, emergency and escalation guardrails."*

---

## Slide 10: Production Monitoring for Quality + Safety

### 🖥️ On the Slide (Static Monitor → Trigger → Response Grid)

- **Headline:** Quality and safety are continuously re-tested in production.
- **Subline:** Production signals automatically trigger investigation, regression testing, and a controlled response.


| **Monitor**                                                                                                                                                                                                                         | **Automatic trigger**                                                                                                                                                                           | **Response**                                                                                                                                                                                                                                                                                                                      |
| ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Quality and agent drift** • Task completion and first-attempt success • Relevance, accuracy and context preservation • Grounding and abstention rate • Topic/action routing accuracy • Latency and cost per resolved conversation | • Any KPI moves **>5 percentage points** from its approved baseline • **5+ similar failures or unexpected escalations in 24 hours** • Any model, prompt, action, API or knowledge-source change | • Open a Quality Review Case with transcript, trace, action path and release version • Cluster similar failures and add a representative regression case • Rerun the affected suite immediately, then the full regression suite • Pause the affected action or rollout if the release gate fails                                  |
| **Deliberate abuse** • Repeated prompt-injection attempts • Reservation-ID enumeration • Repeated attempts to access another diner’s data • Attempts to bypass confirmation or safety policy                                        | • **3 blocked security attempts in one session** or **5 in 24 hours** for the same verified member • One credible attempt involving protected data or a privileged action                       | • Automatically create a **Security Review Case** for OpenTable Trust & Safety • Attach the relevant evidence while minimizing exposed PII • Ask an authorized OpenTable employee to decide whether to warn, flag, suspend or ban the member from agent access • **Never auto-ban:** OpenTable owns the policy and final decision |


- **Operating cadence:** Read-only synthetic checks continuously • affected suite on every alert • full suite nightly and after every release • weekly drift review.
- **Production safety note:** Synthetic tests use dedicated accounts and records; destructive tests never run against live diner reservations.

### 🎙️ What We'll Say (Speaker Track)

> *"Passing UAT is the starting line, not the finish line. In production, we monitor task completion, relevance, accuracy, context preservation, grounding, routing, latency, and cost against the approved baseline.*
>
> *A single safety or access failure, a five-point KPI shift, five similar failures in 24 hours, or any change to the model, prompt, action, API, or knowledge source automatically opens a Case and reruns the affected tests. If that suite fails, we run the full regression gate and pause the affected action or rollout until it returns to 100%.*
>
> *We also separate normal mistakes from deliberate abuse. Repeated prompt injection, reservation enumeration, or attempts to access another diner’s data create a Security Review Case with the trace and release version. The system does not automatically ban anyone. An authorized OpenTable Trust & Safety employee reviews the evidence and makes the policy decision to warn, flag, suspend, or ban that member from the agent."*

### Rubric Coverage Check (Team Notes — Not Shown on Slide)

- **Testing Suite:** Extends regression, edge, adversarial, perturbation and multi-turn testing into an automated production feedback loop.
- **Security Measures:** Adds monitoring and incident response for prompt leakage, policy bypass and unauthorized access.
- **Advanced Security:** Keeps enforcement automated while reserving account sanctions for accountable human review.

---

## Slide 11: The Ask

### 🖥️ On the Slide (Rollout Savings Graph)

- **Headline:** **The ask: approve a 10% Phase 1 rollout.**
- **Subline:** Prove the value at each gate, then scale to 50% and 100%.
- **Annualized savings graph:** Derived from the `$4.18M` full-rollout value model, assuming savings scale linearly with eligible traffic.
  - **10% Pilot:** `$418K`
  - **50% Expansion Gate:** `$2.09M`
  - **100% Full Rollout:** `$4.18M`
- **Decision card:** Launch Phase 1 to **10% of eligible web traffic**. Advance only when quality, safety, and Flex Credit consumption remain inside the approved gates.
- **Rollout path:** `10% > 50% > 100%`

### 🎙️ What We'll Say (Speaker Track)

> *"Our ask today is approval to launch Phase 1 to 10% of eligible web traffic.*
>
> *At that level, the annualized value is approximately **$418,000**. If the quality, safety, and Flex Credit gates hold, we expand to 50%, where the same model represents **$2.09 million** in annualized savings. At full rollout, that reaches the **$4.18 million** opportunity we showed earlier.*
>
> *This is not a request to jump directly to 100%. It is a request to approve the first controlled step, measure it in production, and earn each expansion gate with evidence."*

---

## Slide 12: Appendix

### 🖥️ On the Slide (Table of Contents)

1. **Appendix - Data and Integration**
2. **Appendix - Live Demo**

---

## Slide 13: Appendix - Data and Integration

### 🖥️ On the Slide (Visual & Minimal)

- **Clean 3-Tier Data Flow Visual:**
  - **Tier 1: Salesforce CRM (Identity & Service)**
    - `Contact` *(Diner Identity)* | `Case` *(Support)*
  - **Tier 2: MuleSoft / OpenTable APIs (System of Record)**
    - Restaurant profiles *(Hours, Phone, Timezone)* | Reservations *(Availability & Bookings)*
  - **Tier 3: Data 360 & Knowledge (System of Intelligence)**
    - `Knowledge__kav` $\rightarrow$ `KA_TableCraft_FAQ_Knowledge_index__dlm` *(Chunked Menus, Parking & Policies filtered by `Restaurant_ID__c` + `Category__c`)*

### 🎙️ What We'll Say (Speaker Track)

> *"Here is how data flows into `TableCraft_Agent`. Salesforce provides verified diner identity and Service Cloud case management. Structured restaurant and reservation facts come through MuleSoft from OpenTable's APIs.*
>
> *For unstructured knowledge, restaurant menus, parking directions, and house policies are chunked and indexed in **Data 360** (`KA_TableCraft_FAQ_Knowledge_index__dlm`), partitioned by `Restaurant_ID__c` and `Category__c` (`Menu`, `Parking_And_Access`, `Policies`).*
>
> *Every Agent Script action talks through a decoupled Apex service layer, with MuleSoft handling the OpenTable API contract. That keeps the agent independent from the underlying API while Data 360 remains the governed source for unstructured restaurant knowledge."*

---

## Slide 14: Appendix - Live Demo

### 🖥️ On the Slide (Visual & Minimal)

- **Minimal Live Demo Roadsign (4 Checkpoints on Screen While Switching to Org):**
  1. 🔍 **Discover & Ask FAQ:** Post Oak Smokehouse Hours *(MuleSoft API Fast Path)* + Parking, Dogs & Brisket *(Data 360 RAG)*
  2. 📅 **Book & Save a Cover:** Transition `faq` $\rightarrow$ `booking` + Trigger the **2-Step Cancellation Save Gate**
  3. 🚨 **Safety Boundary:** Plain Dietary Note *(Saved)* vs. Severe Peanut Allergy Guarantee *(Live Escalation)*
  4. 🛡️ **Security Gate:** Cross-Restaurant Isolation / 2-Strike Verification Lockout

### ⚡ Interactive Moment (Let a Judge Pick a Question or Time)

- **During Demo Checkpoint 1 or 2:** Invite a judge to pick which menu/policy question to ask Post Oak Smokehouse (e.g., *spicy food, craft beer, dress code, or parking*) or pick the new time when modifying the reservation.

### 🎙️ What We'll Say (Speaker Track)

> *"Let’s switch over to our live org (`agentforce-org`) and walk through `TableCraft_Agent` in real time across these four checkpoints..."* *(Run live demo.)*

