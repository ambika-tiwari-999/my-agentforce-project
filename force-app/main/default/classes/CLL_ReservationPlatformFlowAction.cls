/**
 * Flow wrapper around CLL_ReservationPlatformClient so a flow can call the mock
 * reservation platform and get the raw API response back. Used by the
 * CLL_Test_Reservation_Platform flow; it is not registered on any agent.
 */
public with sharing class CLL_ReservationPlatformFlowAction {

    public class Request {
        @InvocableVariable(label='Operation' description='listRestaurants, availability, today, createHold, getHold, releaseHold or waitlist' required=true)
        public String operation;
        @InvocableVariable(label='Restaurant ID' description='For example REST-CHI-03')
        public String restaurantId;
        @InvocableVariable(label='Date')
        public Date reservationDate;
        @InvocableVariable(label='Party Size')
        public Integer partySize;
        @InvocableVariable(label='Time (HH:mm)' description='Optional for availability, required for createHold')
        public String timeHHmm;
        @InvocableVariable(label='Area')
        public String area;
        @InvocableVariable(label='Hold ID')
        public String holdId;
        @InvocableVariable(label='Guest Name')
        public String guestName;
        @InvocableVariable(label='Idempotency Key')
        public String idempotencyKey;
    }

    public class Result {
        @InvocableVariable(label='Status Code' description='HTTP status; 0 when the callout itself failed')
        public Integer statusCode;
        @InvocableVariable(label='Is Success')
        public Boolean isSuccess;
        @InvocableVariable(label='Response Body' description='The API response as JSON')
        public String responseBody;
        @InvocableVariable(label='Error Code')
        public String errorCode;
        @InvocableVariable(label='Error Message')
        public String errorMessage;
    }

    @InvocableMethod(label='CLL Call Reservation Platform (test)' description='Calls the mock reservation platform on Heroku and returns the raw response. For flow testing only.' category='CLL Reservation Platform')
    public static List<Result> call(List<Request> requests) {
        List<Result> results = new List<Result>();
        for (Request r : requests) {
            results.add(toResult(dispatch(r)));
        }
        return results;
    }

    private static CLL_ReservationPlatformClient.PlatformResponse dispatch(Request r) {
        switch on (r.operation == null ? '' : r.operation.trim()) {
            when 'listRestaurants' {
                return CLL_ReservationPlatformClient.listRestaurants();
            }
            when 'availability' {
                return CLL_ReservationPlatformClient.getAvailability(r.restaurantId, r.reservationDate, r.partySize, r.timeHHmm);
            }
            when 'today' {
                return CLL_ReservationPlatformClient.getToday(r.restaurantId);
            }
            when 'createHold' {
                return CLL_ReservationPlatformClient.createHold(r.restaurantId, r.reservationDate, r.timeHHmm, r.partySize,
                    r.area, r.idempotencyKey);
            }
            when 'getHold' {
                return CLL_ReservationPlatformClient.getHold(r.holdId);
            }
            when 'releaseHold' {
                return CLL_ReservationPlatformClient.releaseHold(r.holdId);
            }
            when 'waitlist' {
                return CLL_ReservationPlatformClient.joinWaitlist(r.restaurantId, r.reservationDate, r.partySize, r.guestName);
            }
            when else {
                CLL_ReservationPlatformClient.PlatformResponse unknown = new CLL_ReservationPlatformClient.PlatformResponse();
                unknown.statusCode = 0;
                unknown.errorCode = 'UNKNOWN_OPERATION';
                unknown.errorMessage = 'Unknown operation "' + r.operation + '"';
                return unknown;
            }
        }
    }

    private static Result toResult(CLL_ReservationPlatformClient.PlatformResponse response) {
        Result out = new Result();
        out.statusCode = response.statusCode;
        out.isSuccess = response.isSuccess();
        out.responseBody = response.body == null ? null : JSON.serializePretty(response.body);
        out.errorCode = response.errorCode;
        out.errorMessage = response.errorMessage;
        return out;
    }
}