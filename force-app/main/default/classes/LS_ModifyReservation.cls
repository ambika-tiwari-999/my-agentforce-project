public with sharing class LS_ModifyReservation {

    @InvocableMethod(
        label='LS Modify Reservation'
        description='Changes the time and/or party size of an Active reservation owned by the diner. Times are restaurant local time and are stored as UTC.'
    )
    public static List<Result> execute(List<Request> requests) {
        List<Result> results = new List<Result>();
        for (Request req : requests) {
            results.add(modify(req));
        }
        return results;
    }

    private static Result modify(Request req) {
        Result r = new Result();
        r.success = false;

        Reservation__c reservation = CLL_DinerService.findOwnedReservation(req.membershipId, req.reservationId);
        if (reservation == null) {
            r.message = 'The reservation could not be found for this account.';
            return r;
        }
        if (reservation.Status__c != CLL_DinerService.STATUS_ACTIVE) {
            r.message = 'Only Active reservations can be changed. This one is ' + reservation.Status__c + '.';
            return r;
        }
        Boolean hasNewTime = String.isNotBlank(req.newReservationTime);
        Boolean hasNewPartySize = req.newPartySize != null;
        if (!hasNewTime && !hasNewPartySize) {
            r.message = 'Ask the diner for the new time or the new party size.';
            return r;
        }
        Restaurant__c restaurant = CLL_DinerService.findRestaurantByCode(reservation.Restaurant_ID__c);
        String zoneId = restaurant == null ? null : LS_TimeZoneUtil.zoneFor(restaurant.City__c);

        // Only update the fields that were provided.
        if (hasNewTime) {
            if (zoneId == null) {
                r.message = 'The restaurant time zone is not configured, so the time cannot be changed here.';
                return r;
            }
            Datetime wallClock = LS_TimeZoneUtil.parseLocal(req.newReservationTime);
            if (wallClock == null) {
                r.message = 'The new date and time must use the format yyyy-MM-dd HH:mm.';
                return r;
            }
            Datetime newTime = LS_TimeZoneUtil.toUtc(wallClock, zoneId);
            if (newTime == null) {
                r.message = 'That local time does not exist because the clocks change then. Ask the diner for a different time.';
                return r;
            }
            if (LS_TimeZoneUtil.isPast(newTime)) {
                r.message = 'The new reservation time must be in the future.';
                return r;
            }
            String hoursError = CLL_DinerService.openingHoursError(restaurant, wallClock);
            if (hoursError != null) {
                r.message = hoursError;
                return r;
            }
            reservation.Reservation_Time__c = newTime;
        }
        if (hasNewPartySize) {
            String partySizeError = CLL_DinerService.partySizeError(req.newPartySize);
            if (partySizeError != null) {
                r.message = partySizeError;
                return r;
            }
            reservation.Party_Size__c = req.newPartySize;
        }
        update as user reservation;

        r.success = true;
        r.reservationTime = LS_TimeZoneUtil.formatLocal(reservation.Reservation_Time__c, zoneId);
        r.partySize = reservation.Party_Size__c == null ? null : reservation.Party_Size__c.intValue();
        r.message = 'Reservation ' + reservation.Reservation_ID__c + ' is now for ' + r.partySize
            + ' guests on ' + r.reservationTime + '.';
        return r;
    }

    public class Request {
        @InvocableVariable(label='Membership ID' description='Diner membership number from the app session' required=true)
        public String membershipId;

        @InvocableVariable(label='Reservation ID' description='Verified reservation ID' required=true)
        public String reservationId;

        @InvocableVariable(label='New Reservation Time' description='New date and time in yyyy-MM-dd HH:mm (restaurant local time)')
        public String newReservationTime;

        @InvocableVariable(label='New Party Size' description='New number of guests')
        public Integer newPartySize;
    }

    public class Result {
        @InvocableVariable(label='Success' description='True when the reservation was updated')
        public Boolean success;

        @InvocableVariable(label='Reservation Time' description='Formatted reservation date and time after the change, in restaurant local time')
        public String reservationTime;

        @InvocableVariable(label='Party Size' description='Number of guests after the change')
        public Integer partySize;

        @InvocableVariable(label='Message' description='Result summary for the agent')
        public String message;
    }
}