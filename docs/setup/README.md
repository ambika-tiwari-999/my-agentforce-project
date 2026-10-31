# Setup

Default org alias: **`agentforce-org`** (see `.sf/config.json`).

This repo tracks **`TableCraft_Agent`** only (authoring bundle, definition versions, CLL Apex, FAQ/dining prompts, Omni routing flows).

## Retrieve from org

```bash
cd /Users/ambika.tiwari/Documents/salesforce_onboarding_notes/my-agentforce-project

sf project retrieve start --target-org agentforce-org \
  --metadata AiAuthoringBundle:TableCraft_Agent \
  --metadata AiAgentDefinition:TableCraft_Agent \
  --metadata Agent:TableCraft_Agent \
  --metadata ApexClass:CLL_DinerService \
  --metadata ApexClass:CLL_DiningKnowledgeRetriever \
  --metadata ApexClass:CLL_FindRestaurant \
  --metadata ApexClass:CLL_GetDinerContext \
  --metadata ApexClass:CLL_GetReservation \
  --metadata ApexClass:CLL_CreateReservation \
  --metadata ApexClass:CLL_ModifyReservation \
  --metadata ApexClass:CLL_CancelReservation \
  --metadata ApexClass:CLL_EscalateToHuman \
  --metadata GenAiPromptTemplate:Ambika_TableCraft_FAQ_Prompt \
  --metadata GenAiPromptTemplate:CLL_Answer_Dining_Question \
  --metadata Flow:Route_CLL_Escalations \
  --metadata Flow:Route_To_TableCraft_Agent \
  --metadata CustomObject:Restaurant__c \
  --metadata CustomObject:Reservation__c
```
