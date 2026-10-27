public with sharing class CLL_GetDinerContext {

    @InvocableMethod(
        label='CLL Get Diner Context'
        description='Returns the first name of the logged-in diner identified by membership number.'
    )
    public static List<Result> execute(List<Request> requests) {
        List<Result> results = new List<Result>();
        for (Request req : requests) {
            Result r = new Result();
            Contact diner = CLL_DinerService.findDiner(req.membershipId);
            r.found = diner != null;
            r.firstName = diner == null ? '' : diner.FirstName;
            results.add(r);
        }
        return results;
    }

    public class Request {
        @InvocableVariable(label='Membership ID' description='Diner membership number from the app session' required=true)
        public String membershipId;
    }

    public class Result {
        @InvocableVariable(label='Found' description='True when the diner exists')
        public Boolean found;

        @InvocableVariable(label='First Name' description='Diner first name for the greeting')
        public String firstName;
    }
}