public with sharing class CLL_GetReservation {

    @InvocableMethod(
        label='CLL Get Reservation'
        description='Verifies a reservation by membership, last name and reservation ID, and returns its details.'
    )
    public static List<Result> execute(List<Request> requests) {
        List<Result> results = new List<Result>();
        for (Request req : requests) {
            results.add(lookup(req));
        }
        return results;
    }

    private static Result lookup(Request req) {
        Result r = new Result();
        Integer prior = req.priorFailedAttempts == null ? 0 : req.priorFailedAttempts.intValue();
        r.failedAttempts = prior;
        r.found = false;
        r.reservationId = '';

        Contact diner = CLL_DinerService.findDiner(req.membershipId);
        Boolean lastNameMatches = diner != null
            && String.isNotBlank(req.lastName)
            && diner.LastName.equalsIgnoreCase(req.lastName.trim());
        Reservation__c reservation = lastNameMatches
            ? CLL_DinerService.findOwnedReservation(req.membershipId, req.reservationId)
            : null;

        if (reservation == null) {
            // Generic message: never reveal which of the details did not match.
            r.failedAttempts = prior + 1;
            r.message = 'No reservation matches that last name and reservation ID for this account.';
            return r;
        }

        r.found = true;
        r.reservationId = reservation.Reservation_ID__c;
        r.restaurantId = reservation.Restaurant_ID__c;
        r.restaurantName = CLL_DinerService.restaurantName(reservation.Restaurant_ID__c);
        r.partySize = reservation.Party_Size__c == null ? null : reservation.Party_Size__c.intValue();
        r.reservationTime = CLL_DinerService.formatTime(reservation.Reservation_Time__c);
        r.status = reservation.Status__c;
        r.message = 'Reservation ' + r.reservationId + ' at ' + r.restaurantName + ' for ' + r.partySize
            + ' guests on ' + r.reservationTime + ' (status: ' + r.status + ').';
        return r;
    }

    public class Request {
        @InvocableVariable(label='Membership ID' description='Diner membership number from the app session' required=true)
        public String membershipId;

        @InvocableVariable(label='Last Name' description='Diner last name as given by the diner' required=true)
        public String lastName;

        @InvocableVariable(label='Reservation ID' description='Reservation ID, for example RES-001' required=true)
        public String reservationId;

        @InvocableVariable(label='Prior Failed Attempts' description='Failed lookups so far in this conversation')
        public Decimal priorFailedAttempts;
    }

    public class Result {
        @InvocableVariable(label='Found' description='True when the reservation is verified for this diner')
        public Boolean found;

        @InvocableVariable(label='Reservation ID' description='Verified reservation ID')
        public String reservationId;

        @InvocableVariable(label='Restaurant ID' description='Restaurant code of the reservation')
        public String restaurantId;

        @InvocableVariable(label='Restaurant Name' description='Restaurant name of the reservation')
        public String restaurantName;

        @InvocableVariable(label='Party Size' description='Number of guests')
        public Integer partySize;

        @InvocableVariable(label='Reservation Time' description='Formatted reservation date and time')
        public String reservationTime;

        @InvocableVariable(label='Status' description='Active, Completed or Canceled')
        public String status;

        @InvocableVariable(label='Failed Attempts' description='Updated failed lookup count')
        public Decimal failedAttempts;

        @InvocableVariable(label='Message' description='Result summary for the agent')
        public String message;
    }
}