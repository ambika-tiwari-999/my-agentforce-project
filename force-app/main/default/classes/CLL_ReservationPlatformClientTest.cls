@IsTest
private class CLL_ReservationPlatformClientTest {

    /** Replies like the Heroku mock and records the last request. */
    private class PlatformMock implements HttpCalloutMock {
        Integer status;
        String body;
        Boolean fail = false;
        HttpRequest last;

        PlatformMock(Integer status, String body) {
            this.status = status;
            this.body = body;
        }

        public HttpResponse respond(HttpRequest req) {
            last = req;
            if (fail) {
                throw new CalloutException('Read timed out');
            }
            HttpResponse res = new HttpResponse();
            res.setStatusCode(status);
            res.setBody(body);
            return res;
        }
    }

    @IsTest
    static void availabilityBuildsTheQueryAndParsesSlots() {
        PlatformMock mock = new PlatformMock(200, '{"restaurantId":"REST-CHI-03","open":true,"slots":[{"time":"19:00","available":true}]}');
        Test.setMock(HttpCalloutMock.class, mock);
        Test.startTest();
        CLL_ReservationPlatformClient.PlatformResponse r =
            CLL_ReservationPlatformClient.getAvailability('REST-CHI-03', Date.newInstance(2026, 11, 5), 4, '19:00');
        Test.stopTest();
        Assert.isTrue(r.isSuccess());
        Assert.areEqual('callout:CLL_Reservation_Platform/v1/restaurants/REST-CHI-03/availability?date=2026-11-05&partySize=4&time=19%3A00',
            mock.last.getEndpoint());
        Assert.areEqual('GET', mock.last.getMethod());
        Assert.areEqual(1, ((List<Object>) r.asMap().get('slots')).size());
    }

    @IsTest
    static void errorBodyIsExposedAsCodeAndMessage() {
        Test.setMock(HttpCalloutMock.class, new PlatformMock(422,
            '{"error":{"code":"GROUP_BOOKING","message":"Parties of 11 or more are arranged by the restaurant team"}}'));
        Test.startTest();
        CLL_ReservationPlatformClient.PlatformResponse r =
            CLL_ReservationPlatformClient.getAvailability('REST-NYC-05', Date.newInstance(2026, 11, 5), 12, null);
        Test.stopTest();
        Assert.isFalse(r.isSuccess());
        Assert.areEqual(422, r.statusCode);
        Assert.areEqual('GROUP_BOOKING', r.errorCode);
    }

    @IsTest
    static void holdSendsJsonAndIdempotencyKey() {
        PlatformMock mock = new PlatformMock(201, '{"holdId":"HOLD-1A2B3C4D","status":"held"}');
        Test.setMock(HttpCalloutMock.class, mock);
        Test.startTest();
        CLL_ReservationPlatformClient.PlatformResponse r = CLL_ReservationPlatformClient.createHold(
            'REST-CHI-03', Date.newInstance(2026, 11, 5), '18:00', 4, 'Trattoria', 'key-1');
        Test.stopTest();
        Assert.areEqual('HOLD-1A2B3C4D', r.asMap().get('holdId'));
        Assert.areEqual('POST', mock.last.getMethod());
        Assert.areEqual('key-1', mock.last.getHeader('Idempotency-Key'));
        Map<String, Object> sent = (Map<String, Object>) JSON.deserializeUntyped(mock.last.getBody());
        Assert.areEqual('2026-11-05', sent.get('date'));
        Assert.areEqual('Trattoria', sent.get('area'));
    }

    @IsTest
    static void otherEndpointsUseTheirPaths() {
        PlatformMock mock = new PlatformMock(200, '[]');
        Test.setMock(HttpCalloutMock.class, mock);
        Test.startTest();
        Assert.isNull(CLL_ReservationPlatformClient.listRestaurants().asMap());
        Assert.isTrue(mock.last.getEndpoint().endsWith('/v1/restaurants'));
        mock.body = '{"isOpenNow":true}';
        CLL_ReservationPlatformClient.getToday('REST-LA-05');
        Assert.isTrue(mock.last.getEndpoint().endsWith('/v1/restaurants/REST-LA-05/today'));
        CLL_ReservationPlatformClient.getHold('HOLD-1A2B3C4D');
        Assert.isTrue(mock.last.getEndpoint().endsWith('/v1/holds/HOLD-1A2B3C4D'));
        CLL_ReservationPlatformClient.releaseHold('HOLD-1A2B3C4D');
        Assert.isTrue(mock.last.getEndpoint().endsWith('/v1/holds/HOLD-1A2B3C4D/release'));
        mock.status = 201;
        CLL_ReservationPlatformClient.joinWaitlist('REST-CHI-03', Date.newInstance(2026, 11, 5), 4, 'Sofia');
        Assert.isTrue(mock.last.getEndpoint().endsWith('/v1/waitlist'));
        Test.stopTest();
    }

    @IsTest
    static void calloutFailureAndBadJsonAreReported() {
        PlatformMock mock = new PlatformMock(200, 'not json');
        Test.setMock(HttpCalloutMock.class, mock);
        Test.startTest();
        Assert.areEqual('INVALID_RESPONSE', CLL_ReservationPlatformClient.getToday('REST-LA-05').errorCode);
        mock.fail = true;
        CLL_ReservationPlatformClient.PlatformResponse r = CLL_ReservationPlatformClient.getToday('REST-LA-05');
        Test.stopTest();
        Assert.areEqual(0, r.statusCode);
        Assert.areEqual('CALLOUT_FAILED', r.errorCode);
    }
}