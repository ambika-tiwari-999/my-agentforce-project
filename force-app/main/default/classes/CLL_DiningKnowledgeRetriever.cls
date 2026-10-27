/**
 * Fake retriever for the Dining Info subagent. It builds labeled passages
 * from the Restaurant__c record so the answer prompt template can ground
 * on them. The request/response contract (restaurantId + question in,
 * passages out) is kept so it can be replaced later by the Data Library
 * retriever without changing the prompt template.
 */
public with sharing class CLL_DiningKnowledgeRetriever {

    @InvocableMethod(
        label='CLL Dining Knowledge Retriever'
        description='Returns labeled source passages about a restaurant (cuisine, hours, phone, location, menu, parking).'
    )
    public static List<Result> execute(List<Request> requests) {
        List<Result> results = new List<Result>();
        for (Request req : requests) {
            results.add(retrieve(req.restaurantId));
        }
        return results;
    }

    private static Result retrieve(String restaurantId) {
        Result r = new Result();
        Restaurant__c restaurant = CLL_DinerService.findRestaurantByCode(restaurantId);
        List<String> passages = new List<String>();
        if (restaurant != null) {
            addPassage(passages, 'Restaurant__c.Name', 'Restaurant name', CLL_DinerService.displayName(restaurant));
            addPassage(passages, 'Restaurant__c.Cuisine__c', 'Cuisine', restaurant.Cuisine__c);
            addPassage(passages, 'Restaurant__c.Phone_Number__c', 'Phone number', restaurant.Phone_Number__c);
            addPassage(passages, 'Restaurant__c.City__c', 'City', restaurant.City__c);
            addPassage(passages, 'Restaurant__c.Zip_Code__c', 'Zip code', restaurant.Zip_Code__c);
            addPassage(passages, 'Restaurant__c.Operating_Hours__c', 'Operating hours', restaurant.Operating_Hours__c);
            addPassage(passages, 'Restaurant__c.Menu_Details__c', 'Menu details', restaurant.Menu_Details__c);
            addPassage(passages, 'Restaurant__c.Parking_Policy__c', 'Parking policy', restaurant.Parking_Policy__c);
        }
        r.hasSource = !passages.isEmpty();
        r.passages = String.join(passages, '\n');
        return r;
    }

    private static void addPassage(List<String> passages, String source, String label, String value) {
        if (String.isNotBlank(value)) {
            passages.add('[SOURCE: ' + source + '] ' + label + ': ' + value.trim());
        }
    }

    public class Request {
        @InvocableVariable(label='Restaurant ID' description='Restaurant code, for example REST-ATX-01' required=true)
        public String restaurantId;

        @InvocableVariable(label='Question' description='Diner question; unused by the fake retriever, kept for the real retriever contract')
        public String question;
    }

    public class Result {
        @InvocableVariable(label='Has Source' description='True when at least one passage was found')
        public Boolean hasSource;

        @InvocableVariable(label='Passages' description='Labeled source passages, one per line')
        public String passages;
    }
}