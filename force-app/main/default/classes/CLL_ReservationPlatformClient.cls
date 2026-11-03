/**
 * Client for the mock core reservation platform on Heroku (table inventory, holds,
 * waitlist, daily operations). Calls go through the CLL_Reservation_Platform named
 * credential, which adds the x-api-key header, so no secret lives in code.
 * Plain Apex only: nothing here is exposed to an agent.
 */
public with sharing class CLL_ReservationPlatformClient {

    public static final String NAMED_CREDENTIAL = 'callout:CLL_Reservation_Platform';
    /** Below the 15 s mock "timeout" fault, so that fault surfaces as CALLOUT_FAILED. */
    public static final Integer TIMEOUT_MS = 10000;

    public class PlatformResponse {
        public Integer statusCode;
        /** Parsed JSON: a Map for objects, a List for /v1/restaurants. */
        public Object body;
        public String errorCode;
        public String errorMessage;

        public Boolean isSuccess() {
            return statusCode != null && statusCode >= 200 && statusCode < 300;
        }

        public Map<String, Object> asMap() {
            return body instanceof Map<String, Object> ? (Map<String, Object>) body : null;
        }
    }

    public static PlatformResponse listRestaurants() {
        return send('GET', '/v1/restaurants', null, null);
    }

    /** time is optional ("19:00"); with it the response also has the requested slot and alternatives. */
    public static PlatformResponse getAvailability(String restaurantId, Date day, Integer partySize, String timeHHmm) {
        String path = '/v1/restaurants/' + encode(restaurantId) + '/availability?date=' + isoDate(day)
            + '&partySize=' + partySize;
        if (String.isNotBlank(timeHHmm)) {
            path += '&time=' + encode(timeHHmm);
        }
        return send('GET', path, null, null);
    }

    public static PlatformResponse getToday(String restaurantId) {
        return send('GET', '/v1/restaurants/' + encode(restaurantId) + '/today', null, null);
    }

    /** Holds a table for 5 minutes. The same idempotencyKey returns the same hold. */
    public static PlatformResponse createHold(String restaurantId, Date day, String timeHHmm, Integer partySize,
            String area, String idempotencyKey) {
        Map<String, Object> payload = new Map<String, Object>{
            'restaurantId' => restaurantId, 'date' => isoDate(day), 'time' => timeHHmm, 'partySize' => partySize
        };
        if (String.isNotBlank(area)) {
            payload.put('area', area);
        }
        return send('POST', '/v1/holds', payload, idempotencyKey);
    }

    public static PlatformResponse getHold(String holdId) {
        return send('GET', '/v1/holds/' + encode(holdId), null, null);
    }

    public static PlatformResponse releaseHold(String holdId) {
        return send('POST', '/v1/holds/' + encode(holdId) + '/release', new Map<String, Object>(), null);
    }

    public static PlatformResponse joinWaitlist(String restaurantId, Date day, Integer partySize, String guestName) {
        return send('POST', '/v1/waitlist', new Map<String, Object>{
            'restaurantId' => restaurantId, 'date' => isoDate(day), 'partySize' => partySize, 'guestName' => guestName
        }, null);
    }

    private static PlatformResponse send(String method, String path, Map<String, Object> payload, String idempotencyKey) {
        HttpRequest req = new HttpRequest();
        req.setEndpoint(NAMED_CREDENTIAL + path);
        req.setMethod(method);
        req.setTimeout(TIMEOUT_MS);
        req.setHeader('Accept', 'application/json');
        if (payload != null) {
            req.setHeader('Content-Type', 'application/json');
            req.setBody(JSON.serialize(payload));
        }
        if (String.isNotBlank(idempotencyKey)) {
            req.setHeader('Idempotency-Key', idempotencyKey);
        }
        PlatformResponse out = new PlatformResponse();
        try {
            HttpResponse res = new Http().send(req);
            out.statusCode = res.getStatusCode();
            if (String.isNotBlank(res.getBody())) {
                out.body = JSON.deserializeUntyped(res.getBody());
            }
        } catch (CalloutException e) {
            out.statusCode = 0;
            out.errorCode = 'CALLOUT_FAILED';
            out.errorMessage = e.getMessage();
            return out;
        } catch (JSONException e) {
            out.errorCode = 'INVALID_RESPONSE';
            out.errorMessage = 'The platform returned a non-JSON body';
            return out;
        }
        Map<String, Object> m = out.asMap();
        if (!out.isSuccess() && m != null && m.get('error') instanceof Map<String, Object>) {
            Map<String, Object> error = (Map<String, Object>) m.get('error');
            out.errorCode = (String) error.get('code');
            out.errorMessage = (String) error.get('message');
        }
        return out;
    }

    private static String isoDate(Date day) {
        return day == null ? '' : Datetime.newInstanceGmt(day, Time.newInstance(12, 0, 0, 0)).formatGmt('yyyy-MM-dd');
    }

    private static String encode(String value) {
        return EncodingUtil.urlEncode(value == null ? '' : value, 'UTF-8');
    }
}