public with sharing class LS_CreateReservation {

    private static final Integer MAX_SPECIAL_REQUESTS = 255;

    @InvocableMethod(
        label='LS Create Reservation'
        description='Creates an Active reservation for the diner at the selected restaurant. Times are restaurant local time and are stored as UTC.'
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
        String zoneId = LS_TimeZoneUtil.zoneFor(restaurant.City__c);
        if (zoneId == null) {
            r.message = 'The time zone for ' + CLL_DinerService.displayName(restaurant) + ' is not configured, so it cannot be booked here.';
            return r;
        }
        String partySizeError = CLL_DinerService.partySizeError(req.partySize);
        if (partySizeError != null) {
            r.message = partySizeError;
            return r;
        }
        String specialRequests = String.isBlank(req.specialRequests) ? null : req.specialRequests.trim();
        if (specialRequests != null && specialRequests.length() > MAX_SPECIAL_REQUESTS) {
            r.message = 'Special requests must be ' + MAX_SPECIAL_REQUESTS + ' characters or fewer.';
            return r;
        }
        Datetime wallClock = LS_TimeZoneUtil.parseLocal(req.reservationTime);
        if (wallClock == null) {
            r.message = 'The date and time must use the format yyyy-MM-dd HH:mm.';
            return r;
        }
        Datetime reservationTime = LS_TimeZoneUtil.toUtc(wallClock, zoneId);
        if (reservationTime == null) {
            r.message = 'That local time does not exist because the clocks change then. Ask the diner for a different time.';
            return r;
        }
        if (LS_TimeZoneUtil.isPast(reservationTime)) {
            r.message = 'The reservation time must be in the future.';
            return r;
        }
        String hoursError = CLL_DinerService.openingHoursError(restaurant, wallClock);
        if (hoursError != null) {
            r.message = hoursError;
            return r;
        }

        Reservation__c reservation = new Reservation__c(
            Reservation_ID__c = nextReservationId(),
            Contact_ID__c = membershipNumber,
            Restaurant_ID__c = restaurant.Restaurant_ID__c,
            Restaurant_Name__c = CLL_DinerService.displayName(restaurant).left(255),
            Party_Size__c = req.partySize,
            Reservation_Time__c = reservationTime,
            Special_Requests__c = specialRequests,
            Status__c = CLL_DinerService.STATUS_ACTIVE
        );
        insert as user reservation;

        r.success = true;
        r.reservationId = reservation.Reservation_ID__c;
        r.reservationTime = LS_TimeZoneUtil.formatLocal(reservationTime, zoneId);
        r.message = 'Reservation ' + r.reservationId + ' created at ' + CLL_DinerService.displayName(restaurant) + ' for '
            + req.partySize + ' guests on ' + r.reservationTime + '.';
        return r;
    }

    /**
     * Same RES-NNN scheme and the same shared counter row as CLL_CreateReservation,
     * so IDs from both classes never collide.
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

        @InvocableVariable(label='Special Requests' description='Optional occasion, allergy or seating request, up to 255 characters')
        public String specialRequests;
    }

    public class Result {
        @InvocableVariable(label='Success' description='True when the reservation was created')
        public Boolean success;

        @InvocableVariable(label='Reservation ID' description='New reservation ID')
        public String reservationId;

        @InvocableVariable(label='Reservation Time' description='Formatted reservation date and time in restaurant local time')
        public String reservationTime;

        @InvocableVariable(label='Message' description='Result summary for the agent')
        public String message;
    }
}