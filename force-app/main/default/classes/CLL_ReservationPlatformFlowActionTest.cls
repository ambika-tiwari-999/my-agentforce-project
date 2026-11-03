@IsTest
private class CLL_ReservationPlatformFlowActionTest {

    private class PlatformMock implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest req) {
            HttpResponse res = new HttpResponse();
            Boolean isGroup = req.getEndpoint().contains('partySize=12');
            res.setStatusCode(isGroup ? 422 : 200);
            res.setBody(isGroup ? '{"error":{"code":"GROUP_BOOKING","message":"Parties of 11 or more"}}' : '{"path":"' + req.getEndpoint() + '"}');
            return res;
        }
    }

    private static CLL_ReservationPlatformFlowAction.Request request(String operation) {
        CLL_ReservationPlatformFlowAction.Request r = new CLL_ReservationPlatformFlowAction.Request();
        r.operation = operation;
        r.restaurantId = 'REST-CHI-03';
        r.reservationDate = Date.newInstance(2026, 11, 5);
        r.partySize = 4;
        r.timeHHmm = '19:00';
        r.holdId = 'HOLD-1A2B3C4D';
        return r;
    }

    @IsTest
    static void everyOperationReturnsTheResponseBody() {
        Test.setMock(HttpCalloutMock.class, new PlatformMock());
        List<CLL_ReservationPlatformFlowAction.Request> requests = new List<CLL_ReservationPlatformFlowAction.Request>();
        for (String op : new List<String>{ 'listRestaurants', 'availability', 'today', 'createHold', 'getHold', 'releaseHold', 'waitlist' }) {
            requests.add(request(op));
        }
        Test.startTest();
        List<CLL_ReservationPlatformFlowAction.Result> results = CLL_ReservationPlatformFlowAction.call(requests);
        Test.stopTest();
        Assert.areEqual(7, results.size());
        for (CLL_ReservationPlatformFlowAction.Result r : results) {
            Assert.isTrue(r.isSuccess);
            Assert.areEqual(200, r.statusCode);
        }
        Assert.isTrue(results[1].responseBody.contains('/availability?date=2026-11-05&partySize=4'));
    }

    @IsTest
    static void apiErrorsAndUnknownOperationsAreReturned() {
        Test.setMock(HttpCalloutMock.class, new PlatformMock());
        CLL_ReservationPlatformFlowAction.Request groupRequest = request('availability');
        groupRequest.partySize = 12;
        Test.startTest();
        List<CLL_ReservationPlatformFlowAction.Result> results =
            CLL_ReservationPlatformFlowAction.call(new List<CLL_ReservationPlatformFlowAction.Request>{ groupRequest, request('bogus') });
        Test.stopTest();
        Assert.areEqual(422, results[0].statusCode);
        Assert.areEqual('GROUP_BOOKING', results[0].errorCode);
        Assert.isTrue(results[0].responseBody.contains('GROUP_BOOKING'));
        Assert.areEqual('UNKNOWN_OPERATION', results[1].errorCode);
        Assert.isFalse(results[1].isSuccess);
    }
}