Level
Name
Definition
1
Entry 
(Non-Compliant)
Foundational gaps prevent independent execution. Solution is non-functional or fails core minimum requirements.
2
Developing 
(Baseline — passing threshold)
Reliably applies the skill in standard scenarios with minimal support. Solution is functional and meets all core minimum criteria.
3
Intermediate 
(Practical Application)
Applies the skill consistently and effectively without assistance. Solution drives measurable customer or business value.
4
Advanced 
(Applied Theory)
Leads complex workstreams strategically. Solution demonstrates mastery, strategic insight, and production-grade quality.

Assessment Area
1 
Entry
2 
Developing
3 
Intermediate
4
Advanced

1. Use Case Identification & Relevance

Clearly identify a real-world business challenge and connect the Agentforce solution to quantifiable business value.
Fails to define a clear, real-world business challenge. Business value is absent or incoherent.
Use case is identified but strategic relevance or business value is only partially explained. Connection to a real customer problem is underdeveloped.
Clearly defines a relevant, real-world business challenge. Explains how the agent addresses the challenge and provides measurable business value. Customer persona and pain points are evident.
Identifies a high-impact, strategic business challenge. Compellingly articulates quantifiable business value with clear ROI framing. Uses persona-focused storytelling and journey mapping. Positions the solution with market and competitive context.
2. Solution Design & Walkthrough

Demonstrate a functional, well-designed agent built with New Agent Builder with Agent Script, explaining the agent archetype, Guided Design patterns, and solution architecture. Explicitly address AIforce applicability. Reference at least one agentic design pattern.

Minimum build requirement: New Agent Builder with Agent Script configuration with at least one topic, action, and prompt template. Custom Apex or Flow actions are valid additions — they do not replace Script Builder as the primary build tool.
Agent is non-functional or incomplete. New Agent Builder with Agent Script not used or misconfigured. Design principles absent or misapplied.
Basic New Agent Builder with Agent Script agent is functional. Agent archetype identified but design choices not fully explained. Guided Design principles present but surface-level. AIforce not addressed. Architecture only partially outlined.
Functional New Agent Builder with Agent Script agent demonstrated. Agent archetype appropriate and well-explained. Guided Design principles evident and applied. Architecture outlined including key API integrations and deployment considerations. AIforce explicitly addressed — either demonstrated or justified as not applicable. At least one Salesforce Agentic Design Pattern referenced, applied, or explained as inapplicable. Data 360 integration demonstrated or clearly explained.
Robust, well-architected New Agent Builder with Agent Script agent with advanced API integrations (can be mocked; team must speak to production scalability). AIforce demonstrated with surface-agnostic deployment strategy. Multiple agentic design patterns applied with strategic justification. Sophisticated deployment and change management plan articulated. Omni-channel deployment demonstrated or fully explained (MIAW, voice, or web). Walkthrough is polished, persuasive, and demonstrates strategic mastery.
3. Testing Suite 

Demonstrate a comprehensive testing approach covering functional, guardrail, edge, regression, and adversarial scenarios. Align tests with real-world use case needs.
No testing demonstrated. Cannot validate agent behavior. No evidence of quality process.
Basic functional testing demonstrated: agent responds correctly to expected prompts. Guardrail fires when expected. Basic unit tests present. Edge or regression testing absent or incomplete. 
Functional, edge, and unit testing demonstrated and tied to key business scenarios. Multi-turn context testing demonstrated (agent maintains state across turns). At least one T&S test dimension applied: perturbation, bias, or guardrail regression. 
Comprehensive test suite: functional, edge, regression, multi-turn, perturbation, and bias. Splunk trace referenced as part of debugging and optimization evidence. Testing approach demonstrates strong confidence in production resilience.
4. Security Measures 

Implement and explain effective security controls. Demonstrate design aligned with Salesforce security best practices including Trust Layer / Salesforce Guardian.
Security measures absent. Significant vulnerabilities apparent. Einstein Trust Layer not referenced.
Basic security measures mentioned but not clearly demonstrated. Trust Layer / Salesforce Guardian controls acknowledged. Effectiveness not explained.
Key security controls demonstrated: role-based access, permission sets, and input/output filtering. Trust Layer / Salesforce Guardian controls explicitly applied and explained. Proactively explains how controls mitigate common failure types (prompt leakage, policy bypass, unauthorized data access). Security design connected to the use case’s specific risk profile.
Advanced layered security design: platform-native safeguards plus custom controls appropriate to the JTBD. If external MCPs or APIs are used, security assessment articulated (publisher trust, data access scope, action boundaries). Proactive mitigation strategies for complex and compound vulnerabilities. Security design is anticipatory, not just compliant.
5. Business Impact & Consultative Readiness

Articulate business value in a Business Value Statement or Executive Brief. Demonstrate consultative readiness by addressing consumption model fit, deployment strategy, performance tracking, and strategic roadmap.
Little to no articulation of business value, KPIs, or industry context. Consultative framing, deployment strategies, consumption model, and roadmap are absent.
Weak connection between business value, KPIs, and industry context. Consultative framing minimal. Deployment strategies only partially considered. Consumption model not addressed or incorrectly identified. Roadmap thinking basic or unclear.
Clearly links business value to relevant KPIs, summarized in an effective Business Value Statement or Brief. Consultative approach builds customer confidence. Deployment considerations clearly articulated. Consumption model identified (Flex Credits, outcome-based, or AELA) with a rationale for why it fits the use case. Basic roadmap (MVP+) with performance tracking strategy outlined.
Strong, quantifiable business case with deep industry insight in an executive-ready Brief. Advanced consultative framing for senior stakeholders. Consumption-aware architecture: architectural tradeoffs explicitly connected to Digital Wallet impact. Robust deployment planning including change management. Strategic multi-phase roadmap with optimization strategy. Team confidently handles ROI, cost, and consumption objections.
6. Strategic Presentation & Communication

Deliver a professional, clear, and strategically persuasive presentation tailored to a senior customer audience. Each team member has a clear role. Effectively communicate both technical decisions and business impact.
Presentation is unclear, disorganized, or lacks confidence. Significant difficulty communicating concepts.
Presentation has structure and clarity but lacks polish or consistent confidence. Adequate but not engaging or persuasive for senior stakeholders.
Well-structured, clear, and confident presentation. Each team member has a distinct, equal role. Communicates both technical and business concepts effectively. Solution’s value framed appropriately for a senior audience.
Highly engaging and persuasive presentation. Expertly fields Q&A and proactively addresses senior stakeholder objections (ROI, security, scalability, consumption). Tailors messaging to resonate with stakeholder priorities. Communicates transformative business impact with authority.