# TableCraft — Final Pitch Deck Blueprint (`On Slide` vs. `What We'll Say`)

> **How to Use This Blueprint:**
>
> - **🖥️ On the Slide (Keep It Visual & Scannable):** Max 3–4 short cards, big numbers, or a clean diagram. **Zero walls of text.**
> - **🎙️ What We'll Say (Speaker Talk Track):** All the deep context, numbers, and rubric points live in our voice, not crammed onto the slide.
> - **⚡ Interactive Moment (Only Where Genuinely Useful):** Included on **5 high-leverage slides** (Slides 3, 5, 7, 12, and 13) where involving the judges actually proves a point or builds energy.

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

> *"Welcome everyone. Before we step into our UAT sign-off review, we want to take 20 seconds to break the fourth wall with you as judges. In the real world, a UAT Gate Review happens right before production launch — after engineering has built and tested the system. Because we built `TableCraft_Agent` in one week in a sandbox without a live client API, we anchored our build and mock data in real research on **OpenTable** — specifically their August 2025 Salesforce Agentforce deployment and their separate July 2025 Concierge AI launch. For the first few slides, we’ll share that OpenTable context, and starting on Slide 5, we put our **UAT delivery hats on** — treating you as OpenTable’s executive leadership team here to sign off on production rollout."*

---

## Slide 2: Forward-Looking Statements

### 🖥️ On the Slide (Visual & Minimal)

- **Headline:** Forward-Looking Statements
- **Legal text:** This presentation contains forward-looking statements about, among other things, trend analyses and statements regarding future events, anticipated growth and industry prospects, and our strategies, expectations, or plans regarding product releases and enhancements. The achievement or success of the matters covered by such forward-looking statements involves risks, uncertainties, and assumptions. If any such risks or uncertainties materialize or if any of the assumptions prove incorrect, results or outcomes could differ materially from those expressed or implied by these forward-looking statements. The risks and uncertainties referred to above include those factors discussed in Salesforce’s reports filed from time to time with the Securities and Exchange Commission, including, but not limited to: our ability to meet the expectations of our customers; uncertainties regarding AI technologies and their integration into our product offerings; the effect of evolving domestic and foreign government regulations; regulatory developments and regulatory investigations involving us or affecting our industry; our ability to successfully introduce new services and product features, including related to AI and Agentforce; our ability to execute our business plans; our ability to meet our long-term revenue targets and profitable growth framework; the pace of change and innovation and our ability to compete in the markets in which we participate; our ability to maintain and enhance our brands; and expectations regarding contributions from acquired companies.

### 🎙️ What We'll Say (Speaker Track)

> *"Quick reminder of our standard Salesforce Forward-Looking Statements disclaimer — please base any purchasing or rollout decisions on currently available product capabilities in Agentforce and Data 360."* *(Spend <10 seconds here and advance immediately.)*

---

## Slide 3: The KPIs You Want to Improve

> **Advance:** First `>` shows only the KPI stack. The next `>` slides in the right half and retitles the slide as **Slide 4**. One more `>` goes to Slide 5 (Key Findings). `<` slides the right half away and returns to Slide 3.

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

### ⚡ Interactive Moment (Next `>` reveals Slide 4)

- Land on the KPI board only.
- The next `>` retitles the slide **Agentforce actually seals the deals** and brings in the three actions beside the stacked stats.

### 🎙️ What We'll Say (Speaker Track)

> *(Slide 3)* *"These are the KPIs you already said you want to move. You're willing to use AI. The agent you have isn't strong enough.*
>
> *54% of Americans research a restaurant before they book, and the people who do spend about 21 minutes. 27% walk away because the information was too hard to find. 17% walk away because they still couldn't find it and didn't want to call. What they call about is hours, the menu, and the address."*
>
> *(Next `>` — Slide 4)* *"Agentforce actually seals the deals. One agent answers the pre-booking question, books or changes the table in that same conversation, and hands off to a person at OpenTable when it shouldn't be automated."*

### Sources on this slide

1. OpenTable, ["OpenTable Launches Gen-AI Powered Concierge"](https://www.opentable.com/blog/press/page/ai-concierge/), July 15, 2025. Survey: PureSpectrum, 1,500 US consumers, May 12–16, 2025.

---

## Slide 5: Key Findings (Beta KPIs, then the Business Impact)

> **Advance:** First `>` shows only the beta KPI stack. The next `>` slides in the business-impact half. One more `>` goes to Slide 6 (Assumptions). `<` slides the impact half away before leaving the slide.

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

## Slide 6: Breaking The 4th Wall - Sandbox Assumptions

> **Advance:** First `>` shows the three OpenTable surfaces as a vertical stack. The next `>` slides in the matching sandbox stand-ins. One more `>` goes to Slide 7. `<` reverses the reveal.

### 🖥️ On the Slide (Stacked Source-to-Mock Reveal)

- **LEFT — OpenTable platform (visible first):**
  - Intro: **First, the three OpenTable surfaces represented in our beta.**
  1. **B2B — GuestCenter profile:** Restaurants manage their profile, structured details, menus, parking information, and house rules.1
  2. **B2C — Diner web and app:** Diners research a restaurant, book a table, and later change or cancel the reservation.23
  3. **Support — Service Cloud handoff:** Agentforce creates a case and transfers the conversation to a live representative when needed.3
- **RIGHT — our sandbox stand-ins (slides in on the next `>`):**
  1. **B2B mock — `Restaurant__c` + Data 360:** Five demo restaurants, with profile fields and restaurant-scoped knowledge chunks.
  2. **B2C mock — `Contact` + `Reservation__c`:** One signed-in diner and 30 reservations available to create, retrieve, modify, or cancel.
  3. **Support mock — `Case` + routing flow:** The same context-rich handoff, with the restaurant and reservation attached.

### 🎙️ What We'll Say (Speaker Track)

> *(Left stack)* *"Before the architecture, we modeled three surfaces OpenTable already runs: GuestCenter for restaurants, the diner web and app, and Service Cloud for support handoffs.*
>
> *(Next `>` — sandbox stack slides in)* *"Because we did not have a live GuestCenter API, we mirrored those shapes in the sandbox: `Restaurant__c` and Data 360 for B2B content, a signed-in `Contact` and 30 `Reservation__c` records for the diner journey, and a context-rich Case routing flow for support.*
>
> *The restaurants and the diner are fictional. The shapes are theirs. UAT hats stay on from here."*

### Sources on this slide

1. OpenTable, [GuestCenter restaurant profiles](https://support.opentable.com/s/article/Updating-your-restaurant-profile-in-GuestCenter).
2. OpenTable, [Concierge launch](https://www.opentable.com/blog/press/page/ai-concierge/), July 15, 2025.
3. Salesforce, [OpenTable customer story](https://www.salesforce.com/customer-stories/opentable/), August 7, 2025.

---

## Slide 7: Agent Architecture

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
                         │      └── CRM + Data 360 RAG → Grounded answer
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
> *The **FAQ subagent** has read-only access. It uses structured CRM facts and restaurant-scoped Data 360 RAG. If an approved source does not contain the answer, it does not guess — it gives the restaurant phone path.*
>
> *The pink routes are intentional human boundaries. A direct request for a person, an allergen guarantee, another safety concern, an exception, or a verification lockout creates a context-rich Case and transfers through Salesforce Omni-Channel. A request for someone else’s reservation is declined without exposing any data.*
>
> *Choose any request on the left and we can trace exactly which components run, what outcome the user gets, and where the guardrail is enforced."*

---

## Slide 8: Design Decisions and Tradeoffs

### 🖥️ On the Slide (Decision Table)

- **Headline:** Every design decision has a cost.
- **Subline:** What we chose, why we chose it, and what we intentionally deferred.


| **Design decision**                          | **Core concept**                                                                                                                                                      | **Why we chose this**                                                                                                                                                               | **What we sacrifice / defer**                                                                                                                                                         |
| -------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **1. Web access first**                      | **Deployment method:** MIAW embedded on OpenTable restaurant profile pages.                                                                                           | Meets diners where restaurant research and booking already happen. Web supports a controlled `10% → 50% → 100%` rollout.                                                            | No mobile app or voice at launch. Those channels wait until web proves FCR, conversion, security, and consumption targets.                                                            |
| **2. Logged-in users only**                  | **Security and identity:** MIAW user verification supplies the diner’s `membership_id` before the agent exposes reservation tools.                                    | Gives OpenTable API operations a verified customer identity and protects reservation retrieval, modification, and cancellation from unauthorized access.                            | Guest users cannot access the agent at launch, including its FAQ experience. A separate anonymous experience is deferred.                                                             |
| **3. OpenTable API for reservation CRUD**    | **Transactional integration:** create, retrieve, update, and cancel directly against the OpenTable API through Apex and MuleSoft Omni-Gateway.                        | Keeps OpenTable as the reservation system of record and returns real-time availability and operation status. It avoids creating a second production booking database in Salesforce. | Availability, latency, authentication, rate limits, and outages of the OpenTable API become production dependencies that require monitoring and failure handling.                     |
| **4. Salesforce Knowledge Articles for RAG** | **Knowledge grounding:** menus, parking, policies, and FAQs are stored as Salesforce Knowledge Articles and indexed in Data 360, filtered by restaurant and category. | Native Salesforce content governance, chunking, retrieval, citations, and permissions make Knowledge Articles the strongest fit for grounded RAG.                                   | More integration and content-sync work is required to connect 60,000 OpenTable restaurant profiles and keep profile changes reflected in Salesforce Knowledge.                        |
| **5. Flex Credits consumption model**        | **Consumption model:** Agentforce usage is funded through Flex Credits and monitored in Digital Wallet.                                                               | Fits variable diner demand better than fixed capacity. OpenTable can track consumption by action and channel, with alerts at 75% and 90% before expanding traffic.                  | Spend varies with conversation volume, reasoning, and actions. It requires active monitoring, forecasting, and optimization; unrestricted rollout could create consumption surprises. |
| **6. OpenTable-owned human escalation**      | **Human-in-the-loop ownership:** Omni-Channel routes agent failures and exceptions to OpenTable support, which owns triage and coordinates with restaurants as needed. | Restaurants do not inherit agent-failure workload or need new support operations. This lowers opt-in friction and gives OpenTable consistent oversight of quality and recovery.     | OpenTable assumes the support capacity, routing, training, and SLA responsibility. Restaurant-specific resolutions may require an additional handoff.                                 |


- **Bottom callout:** **Our bias:** verified identity, bounded actions, and measurable rollout over maximum reach and autonomy.

### 🎙️ What We'll Say (Speaker Track)

> *"Before deployment, we want to be explicit about six concrete product decisions and their costs.*
>
> *First, we chose **web access through MIAW** as the initial deployment method. It puts the agent on the OpenTable restaurant pages where research and booking already happen and gives us a controlled traffic ramp. The tradeoff is channel reach: mobile and voice are not part of launch.*
>
> *Second, the agent is available to **logged-in users only**. MIAW user verification supplies the membership identity before reservation tools become available. That protects reservation access and gives every API operation a verified customer. The sacrifice is guest reach, including anonymous FAQ access.*
>
> *Third, production reservation CRUD goes to the **OpenTable API** through Apex and MuleSoft. OpenTable remains the source of truth, so availability and status are real time rather than copied into another booking database. The tradeoff is dependency on OpenTable API authentication, rate limits, latency, and uptime, which require production monitoring and resilient failure handling.*
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
- **Security Measures:** Connects authenticated web access to diner identity, identifies API authentication and external-service dependencies, and defines a human recovery path.
- **Business Impact & Consultative Readiness:** Names Flex Credits as the consumption model, explains why it fits variable demand, and connects Digital Wallet thresholds to phased deployment.
- **Use Case, Testing, and Presentation:** Supported elsewhere in the deck by Slides 3–5, 12, and the speaker ownership plan; they should not be forced into this tradeoff table.

---

## Slide 9: Responsible AI

### 🖥️ On the Slide (Visual & Minimal)

- **2x2 Consequence Scanning Grid (Short Bullet Badges Only):**


| **Intended Positive ✅**                                                          | **Intended Negative (Managed Friction) ⚖️**                                                                                                                                                              |
| -------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| • Instant 24/7 FAQ + Booking in 1 chat • Saves tables & deflects host calls      | • 1 extra turn required to cancel (Save Gate) • 3-factor match required for lookup                                                                                                                       |
| **Unintended Positive 💡**                                                       | **Unintended Negative (Risks Mitigated) 🚨**                                                                                                                                                             |
| • Unanswered FAQ logs reveal missing restaurant profile info for Partner Success | • *Risk:* Allergy liability $\rightarrow$ **Auto-escalate to human** • *Risk:* Restaurant data bleed $\rightarrow$ **Hard `Restaurant_ID` filter** • *Risk:* Snooping $\rightarrow$ **2-strike lockout** |


### 🎙️ What We'll Say (Speaker Track)

> *"We ran a formal Consequence Scanning analysis across four quadrants:*
>
> - *Our **intended positives** are faster answers and saved covers.*
> - *Our **intended negatives** are deliberate friction where it protects the business: adding one confirmation turn before canceling a reservation, and requiring 3-factor verification before looking up a booking.*
> - *An **unintended positive** we discovered is that logging 'I don't have that in our FAQ' tells OpenTable Partner Success exactly which restaurants are missing parking or patio details on their GuestCenter profile.*
> - *Most importantly, for **unintended negative risks**, we built three hard safeguards: (1) we never guarantee a kitchen is allergen-free — plain dietary notes save to the booking, while severe allergy guarantees immediately escalate to a human; (2) we enforce strict `Restaurant_ID__c` filtering so Restaurant A's menu never leaks into Restaurant B; and (3) we lock reservation lookup after 2 failed tries."*

---

## Slide 10: Data and Integration

### 🖥️ On the Slide (Visual & Minimal)

- **Clean 3-Tier Data Flow Visual:**
  - **Tier 1: Salesforce CRM (System of Record)**
    - `Contact` *(Diner Identity)* | `Restaurant__c` *(Hours, Phone, Timezone)* | `Reservation__c` *(Bookings)* | `Case` *(Support)*
  - **Tier 2: Data 360 & Knowledge (System of Intelligence)**
    - `Knowledge__kav` $\rightarrow$ `KA_TableCraft_FAQ_Knowledge_index__dlm` *(Chunked Menus, Parking & Policies filtered by `Restaurant_ID__c` + `Category__c`)*
  - **Tier 3: Stateless Integration Layer (`CLL_ReservationPlatformClient`)**
    - *Today (UAT Sandbox):* Bulkified Apex `@InvocableMethod` $\rightarrow$ CRM & Data 360
    - *Production Cutover:* Drop-in swap to **MuleSoft / OpenTable GuestCenter REST APIs** & **AWS S3 Ingestion** *(0 Agent Script changes)*

### 🎙️ What We'll Say (Speaker Track)

> *"Here is how data flows into `TableCraft_Agent`. Internally, Salesforce CRM serves as our System of Record across `Contact`, `Restaurant__c`, `Reservation__c`, and Service Cloud `Case`.*
>
> *For unstructured knowledge, restaurant menus, parking directions, and house policies are chunked and indexed in **Data 360** (`KA_TableCraft_FAQ_Knowledge_index__dlm`), partitioned by `Restaurant_ID__c` and `Category__c` (`Menu`, `Parking_And_Access`, `Policies`).*
>
> *To make this production-ready for 60,000 restaurants, every Agent Script action talks through a decoupled, bulkified Apex service layer (`CLL_ReservationPlatformClient`). When we cut over to live **MuleSoft Named Credential callouts** to OpenTable's GuestCenter reservation API, we don't have to change a single line of our `.agent` script."*

---

## Slide 11: Security and Trust

### 🖥️ On the Slide (Visual & Minimal)

- **3 Layered Shield Cards:**
  1. 🔐 **Layer 1: Platform Access Controls**
    - Dedicated Agent User + Minimal Permission Sets (`TableCraft_Agent_KB_Runtime_Read`)
    - `WITH USER_MODE` SOQL + Restriction Rules (`TableCraft_Agent_Reservation_Access`)
    - 3-Factor Ownership Check (`Reservation_ID` + `LastName` + `membership_id`)
  2. ⚙️ **Layer 2: Agentforce Deterministic Guardrails**
    - `available when @variables.failed_attempts < 2` *(Blocks ID brute-forcing)*
    - `available when @variables.cancel_offer_made == True` *(Enforces save-offer)*
    - Zero internal ID leakage (`REST-ATX-02`, `MEM-1001` hidden)
  3. 🛡️ **Layer 3: Einstein Trust Layer & Guardian**
    - Dynamic Grounding | PII Masking | Prompt Injection & Toxicity Defense | **Zero Data Retention (ZDR)**

### 🎙️ What We'll Say (Speaker Track)

> *"Security is enforced in three defense-in-depth layers:*
>
> 1. **Platform Access Controls:** The agent runs under least-privilege permission sets, `WITH USER_MODE` Apex queries, and a custom Restriction Rule on `Reservation__c`. Even if prompted, it cannot modify a reservation without a 3-factor match across Reservation ID, Last Name, and signed-in Membership ID.
> 2. **Deterministic Agentforce Guardrails:** We don't trust prompt instructions alone for security. In Agent Script, `available when @variables.failed_attempts < 2` removes the lookup tool from the planner after two wrong tries, stopping enumeration attacks cold.
> 3. **Einstein Trust Layer:** Every turn passes through PII masking, toxicity and prompt-injection scanning, strict grounding in Data 360 chunks, and **Zero Data Retention** so diner data never trains external models."*

---

## Slide 12: Testing Approach

### 🖥️ On the Slide (Visual & Minimal)

- **Top Scoreboard Matrix (`sf agent test run` + Apex Unit Tests — `100% Pass`):**
  - ✅ **Functional (`12/12`):** `1a` Hours/Phone (`0` RAG calls, `~5.1s`) | `1b` Menu | `1c` Parking | `1d` Policies (`~8.1s`)
  - ✅ **Guardrails & T&S (`7/7`):** Severe Allergy $\rightarrow$ `Escalate` | Unanswerable $\rightarrow$ Phone Fallback | `REST-ATX-01` vs `02` Tenant Isolation | `911` Emergency
  - ✅ **Multi-Turn & Transitions (`3/3`):** Compound `FAQ + Book` in 1 turn | `faq` $\rightarrow$ `booking` | `faq` $\rightarrow$ `orchestrator` (Austin $\rightarrow$ NYC)
  - ✅ **Adversarial & Edge (`100%`):** 2x wrong Reservation ID lockout | Party of 15 escalation | Prompt injection
- **Bottom Card — 3 Real Bugs Caught & Fixed via Trace Debugging & AI Code Review:**
  1. 🕒 **5-Hour Timezone Drift** $\rightarrow$ Fixed with restaurant local timezone converter
  2. 🥗 **Dietary Note Over-Escalation** $\rightarrow$ Split plain dietary note (save on booking) vs. severe allergy (escalate)
  3. 🔑 **Internal ID Prompt Leak** $\rightarrow$ Fixed via `orchestrator` name resolution + `before_reasoning`

### ⚡ Interactive Moment (Spot the Tenant Leak Test)

- **Ask the Judges:** *"In Test 2c, we asked the agent if **Comal Heritage Cantina** serves the **16-Hour Smoked Prime Brisket** — which is actually on **Post Oak Smokehouse's** menu in the same Austin database. Did it take the bait? Zero leaked chunks — it immediately gave Comal's phone number."*

### 🎙️ What We'll Say (Speaker Track)

> *"We didn't just click around in preview — we built **8 automated `AiTestingDefinition` suites** in YAML and ran them via CLI (`sf agent test run`) alongside Apex unit tests.*
>
> *Across Functional, Guardrail, Multi-Turn, Perturbation, and Adversarial suites, we verified 100% pass rates — proving that hours/phone questions make **zero RAG calls** (`~5.1s` latency) while menu, parking, and policy questions ground strictly in Data 360 chunks.*
>
> *More importantly, trace debugging and AI-assisted code review caught three real bugs during development: a 5-hour UTC timezone offset on bookings, over-escalating when a diner simply said 'I'm vegetarian', and asking diners for internal `REST-ATX` IDs. All three were fixed and locked in with regression tests."*

---

## Slide 13: Live Demo

### 🖥️ On the Slide (Visual & Minimal)

- **Minimal Live Demo Roadsign (4 Checkpoints on Screen While Switching to Org):**
  1. 🔍 **Discover & Ask FAQ:** Post Oak Smokehouse Hours *(CRM Fast Path)* + Parking, Dogs & Brisket *(Data 360 RAG)*
  2. 📅 **Book & Save a Cover:** Transition `faq` $\rightarrow$ `booking` + Trigger the **2-Step Cancellation Save Gate**
  3. 🚨 **Safety Boundary:** Plain Dietary Note *(Saved)* vs. Severe Peanut Allergy Guarantee *(Live Escalation)*
  4. 🛡️ **Security Gate:** Cross-Restaurant Isolation / 2-Strike Verification Lockout

### ⚡ Interactive Moment (Let a Judge Pick a Question or Time)

- **During Demo Checkpoint 1 or 2:** Invite a judge to pick which menu/policy question to ask Post Oak Smokehouse (e.g., *spicy food, craft beer, dress code, or parking*) or pick the new time when modifying the reservation.

### 🎙️ What We'll Say (Speaker Track)

> *"Let’s switch over to our live org (`agentforce-org`) and walk through `TableCraft_Agent` in real time across these four checkpoints..."* *(Run live demo.)*

---

## Slide 14: Recommendations and Next Steps

### 🖥️ On the Slide (Visual & Minimal)

- **Left Side — 3 Strategic Recommendations:**
  1. **Consolidate Stacks:** Retire standalone Concierge AI $\rightarrow$ Capture `**$4.18M/yr`** in unified Agentforce value.
  2. **Scale Hybrid RAG:** Keep Hours/Phone in `before_reasoning` CRM + ingest 60,000 restaurant PDFs into Data 360.
  3. **Gate Risk in Code:** Enforce `available when` state gates for cancellations, lockouts, and allergy escalations.
- **Right Side — Immediate Next Steps (The UAT Ask):**
  - ✅ **Today:** Sign off on **Phase 1 Stage 1 (`10%` Web Pilot in Austin)**
  - 🔧 **Thursday:** Joint MuleSoft API + Digital Wallet Alert Workshop
  - 📊 **Tuesday, Nov 17 (Next Meeting):** **2-Week Pilot Readout & `50%` Go/No-Go Gate**

### 🎙️ What We'll Say (Speaker Track)

> *"To close, we leave OpenTable with three strategic recommendations:*
>
> 1. **Consolidate onto one Agentforce brain** so diners can ask FAQ questions, book reservations, and reach a human at OpenTable in one place — unlocking $4.18M in annual value.
> 2. **Scale our Hybrid CRM + Data 360 pattern** across all 60,000 restaurants to keep latency and Flex Credit consumption low at peak dinner hours.
> 3. **Enforce revenue and safety rules deterministically in Agent Script** rather than relying on prompts alone.*
>
> *Our ask today is your **UAT sign-off to launch our 10% Web pilot in Austin**, followed by our Thursday technical workshop with the MuleSoft team, and our **next executive readout on Tuesday, November 17** to review our first two weeks of FCR and booking conversion data before ramping to 50%. Thank you — we’d love to open the floor for your questions."*
