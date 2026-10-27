public with sharing class CLL_CreateReservation {

    @InvocableMethod(
        label='CLL Create Reservation'
        description='Creates an Active reservation for the diner at the selected restaurant.'
    )
    public static List<Result> execute(List<Request> requests) {
        List<Result> results = new List<Result>();
        for (Request req : requests) {
            results.add(create(req));
        }
        return results;
    }

    private static Result create(Request req) {
        Result r = new Result();
        r.success = false;
        r.reservationId = '';

        Decimal membershipNumber = CLL_DinerService.toMembershipNumber(req.membershipId);
        if (membershipNumber == null || CLL_DinerService.findDiner(req.membershipId) == null) {
            r.message = 'The diner account could not be found.';
            return r;
        }
        Restaurant__c restaurant = CLL_DinerService.findRestaurantByCode(req.restaurantId);
        if (restaurant == null) {
            r.message = 'The restaurant could not be found.';
            return r;
        }
        String partySizeError = CLL_DinerService.partySizeError(req.partySize);
        if (partySizeError != null) {
            r.message = partySizeError;
            return r;
        }
        Datetime reservationTime = CLL_DinerService.parseTime(req.reservationTime);
        if (reservationTime == null) {
            r.message = 'The date and time must use the format yyyy-MM-dd HH:mm.';
            return r;
        }
        if (reservationTime < Datetime.now()) {
            r.message = 'The reservation time must be in the future.';
            return r;
        }
        String hoursError = CLL_DinerService.openingHoursError(restaurant, reservationTime);
        if (hoursError != null) {
            r.message = hoursError;
            return r;
        }

        Reservation__c reservation = new Reservation__c(
            Reservation_ID__c = nextReservationId(),
            Contact_ID__c = membershipNumber,
            Restaurant_ID__c = restaurant.Restaurant_ID__c,
            Party_Size__c = req.partySize,
            Reservation_Time__c = reservationTime,
            Status__c = CLL_DinerService.STATUS_ACTIVE
        );
        insert as user reservation;

        r.success = true;
        r.reservationId = reservation.Reservation_ID__c;
        r.reservationTime = CLL_DinerService.formatTime(reservationTime);
        r.message = 'Reservation ' + r.reservationId + ' created at ' + CLL_DinerService.displayName(restaurant) + ' for '
            + req.partySize + ' guests on ' + r.reservationTime + '.';
        return r;
    }

    /**
     * Follows the existing RES-NNN pattern: highest number + 1. The counter row is
     * locked first, so concurrent bookings wait for each other instead of reading
     * the same highest ID; the lock is released when the transaction commits.
     * Other tools also create RES-NNN IDs, so the existing reservations still count.
     */
    private static String nextReservationId() {
        List<CLL_Reservation_Sequence__c> sequences = [
            SELECT Id, Last_Number__c FROM CLL_Reservation_Sequence__c
            WITH USER_MODE
            LIMIT 1
            FOR UPDATE
        ];
        CLL_Reservation_Sequence__c sequence = sequences.isEmpty()
            ? new CLL_Reservation_Sequence__c(Name = 'Reservation ID')
            : sequences[0];
        Integer highest = sequence.Last_Number__c == null ? 0 : sequence.Last_Number__c.intValue();
        for (Reservation__c existing : [
            SELECT Reservation_ID__c FROM Reservation__c
            WHERE Reservation_ID__c LIKE 'RES-%'
            WITH USER_MODE
        ]) {
            String digits = existing.Reservation_ID__c.substringAfter('RES-');
            if (digits.isNumeric()) {
                highest = Math.max(highest, Integer.valueOf(digits));
            }
        }
        sequence.Last_Number__c = highest + 1;
        upsert as user sequence;
        return 'RES-' + String.valueOf(highest + 1).leftPad(3, '0');
    }

    public class Request {
        @InvocableVariable(label='Membership ID' description='Diner membership number from the app session' required=true)
        public String membershipId;

        @InvocableVariable(label='Restaurant ID' description='Restaurant code, for example REST-ATX-01' required=true)
        public String restaurantId;

        @InvocableVariable(label='Reservation Time' description='Date and time in yyyy-MM-dd HH:mm (restaurant local time)' required=true)
        public String reservationTime;

        @InvocableVariable(label='Party Size' description='Number of guests' required=true)
        public Integer partySize;
    }

    public class Result {
        @InvocableVariable(label='Success' description='True when the reservation was created')
        public Boolean success;

        @InvocableVariable(label='Reservation ID' description='New reservation ID')
        public String reservationId;

        @InvocableVariable(label='Reservation Time' description='Formatted reservation date and time')
        public String reservationTime;

        @InvocableVariable(label='Message' description='Result summary for the agent')
        public String message;
    }
}