public with sharing class CLL_CancelReservation {

    @InvocableMethod(
        label='CLL Cancel Reservation'
        description='Cancels an Active reservation owned by the diner.'
    )
    public static List<Result> execute(List<Request> requests) {
        List<Result> results = new List<Result>();
        for (Request req : requests) {
            results.add(cancel(req));
        }
        return results;
    }

    private static Result cancel(Request req) {
        Result r = new Result();
        r.success = false;

        Reservation__c reservation = CLL_DinerService.findOwnedReservation(req.membershipId, req.reservationId);
        if (reservation == null) {
            r.message = 'The reservation could not be found for this account.';
            return r;
        }
        if (reservation.Status__c != CLL_DinerService.STATUS_ACTIVE) {
            r.message = 'Only Active reservations can be canceled. This one is ' + reservation.Status__c + '.';
            return r;
        }
        reservation.Status__c = CLL_DinerService.STATUS_CANCELED;
        update as user reservation;

        r.success = true;
        r.message = 'Reservation ' + reservation.Reservation_ID__c + ' has been canceled.';
        return r;
    }

    public class Request {
        @InvocableVariable(label='Membership ID' description='Diner membership number from the app session' required=true)
        public String membershipId;

        @InvocableVariable(label='Reservation ID' description='Verified reservation ID' required=true)
        public String reservationId;
    }

    public class Result {
        @InvocableVariable(label='Success' description='True when the reservation was canceled')
        public Boolean success;

        @InvocableVariable(label='Message' description='Result summary for the agent')
        public String message;
    }
}