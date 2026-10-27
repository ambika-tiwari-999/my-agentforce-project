public with sharing class CLL_EscalateToHuman {

    private static final Set<String> HIGH_PRIORITY_REASONS = new Set<String>{
        'allerg', 'medical', 'safety', 'legal', 'sick', 'illness', 'food poisoning', 'injur', 'health', 'hospital'
    };

    @InvocableMethod(
        label='CLL Escalate To Human'
        description='Creates an escalated Case with a conversation summary so a support agent can take over.'
    )
    public static List<Result> execute(List<Request> requests) {
        List<Result> results = new List<Result>();
        for (Request req : requests) {
            results.add(escalate(req));
        }
        return results;
    }

    private static Result escalate(Request req) {
        Result r = new Result();
        r.success = false;
        r.caseNumber = '';

        Contact diner = CLL_DinerService.findDiner(req.membershipId);
        String restaurant = String.isBlank(req.restaurantId)
            ? 'not identified'
            : CLL_DinerService.restaurantName(req.restaurantId) + ' (' + req.restaurantId + ')';
        String callbackPhone = String.isNotBlank(req.callbackPhone)
            ? req.callbackPhone.trim()
            : (diner == null ? null : diner.Phone);
        String intent = String.isBlank(req.intent) ? 'general' : req.intent.trim();

        Case escalation = new Case(
            ContactId = diner == null ? null : diner.Id,
            Subject = ('Diner escalation: ' + intent).left(255),
            Description = 'Reason: ' + nvl(req.reason)
                + '\nRestaurant: ' + restaurant
                + '\nMembership: ' + nvl(req.membershipId)
                + '\nCallback phone: ' + nvl(callbackPhone)
                + '\n\nSummary:\n' + nvl(req.conversationSummary),
            SuppliedPhone = callbackPhone,
            Origin = 'Web',
            Status = 'Escalated',
            Priority = priorityFor(req.reason)
        );
        insert as user escalation;

        Case created = [SELECT CaseNumber FROM Case WHERE Id = :escalation.Id WITH USER_MODE LIMIT 1];
        r.success = true;
        r.caseNumber = created.CaseNumber;
        r.message = 'Case ' + created.CaseNumber + ' was created and a support agent will follow up'
            + (String.isBlank(callbackPhone) ? '.' : ' at ' + callbackPhone + '.');
        return r;
    }

    private static String priorityFor(String reason) {
        String normalized = reason == null ? '' : reason.toLowerCase();
        for (String keyword : HIGH_PRIORITY_REASONS) {
            if (normalized.contains(keyword)) {
                return 'High';
            }
        }
        return 'Medium';
    }

    private static String nvl(String value) {
        return String.isBlank(value) ? 'n/a' : value;
    }

    public class Request {
        @InvocableVariable(label='Membership ID' description='Diner membership number from the app session' required=true)
        public String membershipId;

        @InvocableVariable(label='Restaurant ID' description='Restaurant code, if identified')
        public String restaurantId;

        @InvocableVariable(label='Intent' description='What the diner was trying to do')
        public String intent;

        @InvocableVariable(label='Callback Phone' description='Phone number the diner gave for a callback')
        public String callbackPhone;

        @InvocableVariable(label='Reason' description='Why the conversation is escalated, for example allergy, refund request, asked for a human' required=true)
        public String reason;

        @InvocableVariable(label='Conversation Summary' description='Short summary of the conversation and what was already tried' required=true)
        public String conversationSummary;
    }

    public class Result {
        @InvocableVariable(label='Success' description='True when the Case was created')
        public Boolean success;

        @InvocableVariable(label='Case Number' description='Number of the escalation Case')
        public String caseNumber;

        @InvocableVariable(label='Message' description='Result summary for the agent')
        public String message;
    }
}