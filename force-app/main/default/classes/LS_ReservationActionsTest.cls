@IsTest
private class LS_ReservationActionsTest {

    private static final String DINER = '99000001';
    private static final String OTHER_DINER = '99000002';

    @TestSetup
    static void setup() {
        insert new List<Restaurant__c>{
            restaurant('REST-ATX-01', 'Austin', 'Mon-Thu: 11:00 AM - 10:00 PM; Fri-Sat: 11:00 AM - 11:30 PM; Sun: 10:00 AM - 9:00 PM'),
            restaurant('REST-ATX-02', 'Austin', 'Wed-Sun: 11:30 AM - 10:00 PM; Closed Mon-Tue.'),
            restaurant('REST-NYC-01', 'New York', 'Daily: 11:00 AM - 11:00 PM'),
            restaurant('REST-LA-01', 'Los Angeles', 'Daily: 11:00 AM - 11:00 PM'),
            restaurant('REST-DEN-01', 'Denver', 'Daily: 11:00 AM - 11:00 PM')
        };
        // Contacts without an Account are private to their owner, so the agent user could not see them.
        Account account = new Account(Name = 'LS Test Diners');
        insert account;
        insert new List<Contact>{
            new Contact(FirstName = 'Test', LastName = 'Diner', External_Diner_ID__c = DINER, AccountId = account.Id),
            new Contact(FirstName = 'Other', LastName = 'Person', External_Diner_ID__c = OTHER_DINER, AccountId = account.Id)
        };
        insert new CLL_Reservation_Sequence__c(Name = 'Reservation ID', Last_Number__c = 0);
        createAgentUser();
    }

    /**
     * The actions run in user mode, so they need the same access as the real agent
     * user: the existing CLL_Diner_Agent_Access permission set, plus the two
     * Reservation__c fields the LS_ classes now write (Special_Requests__c and
     * Restaurant_Name__c), which that permission set does not grant.
     */
    private static void createAgentUser() {
        // Setup objects must not share a transaction with the data inserts above.
        System.runAs(new User(Id = UserInfo.getUserId())) {
            Profile profile = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
            User agent = new User(
                Alias = 'lsagent', LastName = 'LS Agent', Email = 'ls.agent@example.com',
                Username = 'ls.agent.test.' + UserInfo.getOrganizationId() + '@example.com',
                ProfileId = profile.Id, TimeZoneSidKey = 'America/Chicago', LocaleSidKey = 'en_US',
                EmailEncodingKey = 'UTF-8', LanguageLocaleKey = 'en_US'
            );
            insert agent;
            PermissionSet extra = new PermissionSet(Name = 'LS_Test_Extra_Access', Label = 'LS Test Extra Access');
            insert extra;
            insert new ObjectPermissions(
                ParentId = extra.Id, SobjectType = 'Reservation__c',
                PermissionsRead = true, PermissionsCreate = true, PermissionsEdit = true
            );
            insert new List<FieldPermissions>{
                new FieldPermissions(ParentId = extra.Id, SobjectType = 'Reservation__c', Field = 'Reservation__c.Special_Requests__c', PermissionsRead = true, PermissionsEdit = true),
                new FieldPermissions(ParentId = extra.Id, SobjectType = 'Reservation__c', Field = 'Reservation__c.Restaurant_Name__c', PermissionsRead = true, PermissionsEdit = true)
            };
            PermissionSet base = [SELECT Id FROM PermissionSet WHERE Name = 'CLL_Diner_Agent_Access' LIMIT 1];
            insert new List<PermissionSetAssignment>{
                new PermissionSetAssignment(AssigneeId = agent.Id, PermissionSetId = base.Id),
                new PermissionSetAssignment(AssigneeId = agent.Id, PermissionSetId = extra.Id)
            };
        }
    }

    private static User agent() {
        return [SELECT Id FROM User WHERE Alias = 'lsagent' AND Username LIKE 'ls.agent.test.%' LIMIT 1];
    }

    private static Restaurant__c restaurant(String code, String city, String hours) {
        return new Restaurant__c(Name = 'Test ' + code, Restaurant_ID__c = code, City__c = city, Operating_Hours__c = hours);
    }

    private static void pinNow(Integer y, Integer mo, Integer d, Integer h, Integer mi) {
        LS_TimeZoneUtil.nowOverride = Datetime.newInstanceGmt(y, mo, d, h, mi, 0);
    }

    private static LS_CreateReservation.Result create(String restaurantId, String localTime, Integer party, String requests) {
        LS_CreateReservation.Request req = new LS_CreateReservation.Request();
        req.membershipId = DINER;
        req.restaurantId = restaurantId;
        req.reservationTime = localTime;
        req.partySize = party;
        req.specialRequests = requests;
        return createAs(req);
    }

    private static LS_CreateReservation.Result createAs(LS_CreateReservation.Request req) {
        LS_CreateReservation.Result result;
        System.runAs(agent()) {
            result = LS_CreateReservation.execute(new List<LS_CreateReservation.Request>{ req })[0];
        }
        return result;
    }

    private static Reservation__c stored(String reservationId) {
        return [
            SELECT Reservation_ID__c, Contact_ID__c, Restaurant_Name__c, Reservation_Time__c, Special_Requests__c, Party_Size__c, Status__c
            FROM Reservation__c WHERE Reservation_ID__c = :reservationId
        ];
    }

    private static LS_ModifyReservation.Result modify(String reservationId, String newTime, Integer newParty) {
        LS_ModifyReservation.Request req = new LS_ModifyReservation.Request();
        req.membershipId = DINER;
        req.reservationId = reservationId;
        req.newReservationTime = newTime;
        req.newPartySize = newParty;
        return modifyAs(req);
    }

    private static LS_ModifyReservation.Result modifyAs(LS_ModifyReservation.Request req) {
        LS_ModifyReservation.Result result;
        System.runAs(agent()) {
            result = LS_ModifyReservation.execute(new List<LS_ModifyReservation.Request>{ req })[0];
        }
        return result;
    }

    private static LS_GetReservation.Result lookup(String membership, String lastName, String reservationId, Integer prior) {
        LS_GetReservation.Request req = new LS_GetReservation.Request();
        req.membershipId = membership;
        req.lastName = lastName;
        req.reservationId = reservationId;
        req.priorFailedAttempts = prior;
        LS_GetReservation.Result result;
        System.runAs(agent()) {
            result = LS_GetReservation.execute(new List<LS_GetReservation.Request>{ req })[0];
        }
        return result;
    }

    @IsTest
    static void createAustinInDaylightTimeStoresUtcAndReadsBackLocal() {
        pinNow(2026, 10, 20, 12, 0);
        LS_CreateReservation.Result r = create('REST-ATX-01', '2026-10-29 19:00', 2, null);
        System.assert(r.success, r.message);
        System.assertEquals(Datetime.newInstanceGmt(2026, 10, 30, 0, 0, 0), stored(r.reservationId).Reservation_Time__c);
        System.assertEquals('Thu, Oct 29, 2026 at 7:00 PM', r.reservationTime);

        LS_GetReservation.Result g = lookup(DINER, 'Diner', r.reservationId, 0);
        System.assert(g.found);
        System.assert(g.message.contains('7:00 PM'), g.message);
    }

    @IsTest
    static void createAustinInStandardTime() {
        pinNow(2026, 10, 20, 12, 0);
        LS_CreateReservation.Result r = create('REST-ATX-01', '2026-11-06 19:00', 2, null);
        System.assert(r.success, r.message);
        System.assertEquals(Datetime.newInstanceGmt(2026, 11, 7, 1, 0, 0), stored(r.reservationId).Reservation_Time__c);
        System.assertEquals('Fri, Nov 6, 2026 at 7:00 PM', r.reservationTime);
    }

    @IsTest
    static void createNewYorkAndLosAngeles() {
        pinNow(2026, 10, 20, 12, 0);
        LS_CreateReservation.Result ny = create('REST-NYC-01', '2026-11-06 19:00', 2, null);
        System.assert(ny.success, ny.message);
        System.assertEquals(Datetime.newInstanceGmt(2026, 11, 7, 0, 0, 0), stored(ny.reservationId).Reservation_Time__c);

        LS_CreateReservation.Result laStandard = create('REST-LA-01', '2026-11-06 19:00', 2, null);
        System.assertEquals(Datetime.newInstanceGmt(2026, 11, 7, 3, 0, 0), stored(laStandard.reservationId).Reservation_Time__c);

        LS_CreateReservation.Result laDaylight = create('REST-LA-01', '2026-10-29 19:00', 2, null);
        System.assertEquals(Datetime.newInstanceGmt(2026, 10, 30, 2, 0, 0), stored(laDaylight.reservationId).Reservation_Time__c);
    }

    @IsTest
    static void futureCheckAcceptsLaterTodayAndRejectsPassedTime() {
        pinNow(2026, 10, 29, 18, 37); // 1:37 PM CDT
        LS_CreateReservation.Result later = create('REST-ATX-01', '2026-10-29 15:30', 2, null);
        System.assert(later.success, later.message);
        System.assertEquals(Datetime.newInstanceGmt(2026, 10, 29, 20, 30, 0), stored(later.reservationId).Reservation_Time__c);

        LS_CreateReservation.Result passed = create('REST-ATX-01', '2026-10-29 13:00', 2, null);
        System.assertEquals(false, passed.success);
        System.assert(passed.message.contains('must be in the future'), passed.message);
    }

    @IsTest
    static void modifyUsesRestaurantLocalTimeAndFutureCheck() {
        pinNow(2026, 10, 20, 12, 0);
        LS_CreateReservation.Result created = create('REST-ATX-01', '2026-10-29 19:00', 2, null);
        System.assert(created.success, created.message);

        pinNow(2026, 10, 29, 18, 37); // 1:37 PM CDT
        LS_ModifyReservation.Result ok = modify(created.reservationId, '2026-10-29 15:30', null);
        System.assert(ok.success, ok.message);
        System.assertEquals('Thu, Oct 29, 2026 at 3:30 PM', ok.reservationTime);
        System.assertEquals(Datetime.newInstanceGmt(2026, 10, 29, 20, 30, 0), stored(created.reservationId).Reservation_Time__c);

        LS_ModifyReservation.Result passed = modify(created.reservationId, '2026-10-29 13:00', null);
        System.assertEquals(false, passed.success);
        System.assert(passed.message.contains('must be in the future'), passed.message);
        System.assertEquals(Datetime.newInstanceGmt(2026, 10, 29, 20, 30, 0), stored(created.reservationId).Reservation_Time__c);

        LS_ModifyReservation.Result party = modify(created.reservationId, null, 4);
        System.assert(party.success, party.message);
        System.assertEquals(4, stored(created.reservationId).Party_Size__c.intValue());
    }

    @IsTest
    static void modifyRejectionsLeaveTheReservationUntouched() {
        pinNow(2027, 2, 20, 12, 0);
        LS_CreateReservation.Result created = create('REST-ATX-01', '2027-03-10 19:00', 2, null);
        System.assert(created.success, created.message);
        Datetime original = stored(created.reservationId).Reservation_Time__c;

        System.assertEquals(false, modify('RES-404', '2027-03-11 19:00', null).success, 'unknown reservation');
        System.assertEquals(false, modify(created.reservationId, null, null).success, 'nothing to change');
        System.assertEquals(false, modify(created.reservationId, 'later', null).success, 'bad format');
        System.assertEquals(false, modify(created.reservationId, '2027-03-14 02:30', null).success, 'clock change gap');
        System.assertEquals(false, modify(created.reservationId, '2027-03-11 03:00', null).success, 'outside opening hours');
        System.assertEquals(false, modify(created.reservationId, null, 11).success, 'party too large');
        System.assertEquals(original, stored(created.reservationId).Reservation_Time__c);
        System.assertEquals(2, stored(created.reservationId).Party_Size__c.intValue());

        Reservation__c canceled = stored(created.reservationId);
        canceled.Status__c = 'Canceled';
        update canceled;
        System.assertEquals(false, modify(created.reservationId, '2027-03-11 19:00', null).success, 'only Active can change');
    }

    @IsTest
    static void modifyCannotTouchAnotherDinersReservation() {
        pinNow(2026, 10, 20, 12, 0);
        LS_CreateReservation.Result created = create('REST-ATX-01', '2026-10-29 19:00', 2, null);
        LS_ModifyReservation.Request req = new LS_ModifyReservation.Request();
        req.membershipId = OTHER_DINER;
        req.reservationId = created.reservationId;
        req.newPartySize = 6;
        LS_ModifyReservation.Result r = modifyAs(req);
        System.assertEquals(false, r.success);
        System.assertEquals(2, stored(created.reservationId).Party_Size__c.intValue());
    }

    @IsTest
    static void openingHoursUseRestaurantLocalTime() {
        pinNow(2026, 10, 20, 12, 0);
        // Mon Nov 2 2026: REST-ATX-02 is closed Mon-Tue.
        LS_CreateReservation.Result closed = create('REST-ATX-02', '2026-11-02 19:00', 2, null);
        System.assertEquals(false, closed.success);
        System.assert(closed.message.contains('cannot seat'), closed.message);
        // 7 PM CST on Fri Nov 6 is 01:00 UTC Saturday; still evaluated as Friday evening.
        LS_CreateReservation.Result open = create('REST-ATX-02', '2026-11-06 19:00', 2, null);
        System.assert(open.success, open.message);
        // 10:30 PM is after the 10:00 PM close minus last seating.
        LS_CreateReservation.Result late = create('REST-ATX-02', '2026-11-06 22:30', 2, null);
        System.assertEquals(false, late.success);
    }

    @IsTest
    static void clockChangeGapIsRefused() {
        pinNow(2027, 3, 1, 12, 0);
        LS_CreateReservation.Result r = create('REST-ATX-01', '2027-03-14 02:30', 2, null);
        System.assertEquals(false, r.success);
        System.assert(r.message.contains('does not exist'), r.message);
    }

    @IsTest
    static void failedCreateChangesNothing() {
        pinNow(2026, 10, 20, 12, 0);
        LS_CreateReservation.Result first = create('REST-ATX-01', '2026-10-29 19:00', 2, 'window seat');
        System.assert(first.success, first.message);
        Reservation__c before = stored(first.reservationId);
        Integer count = [SELECT COUNT() FROM Reservation__c];

        System.assertEquals(false, create('REST-NOPE', '2026-10-29 19:00', 2, null).success);
        System.assertEquals(false, create('REST-ATX-01', 'not a time', 2, null).success);
        System.assertEquals(false, create('REST-ATX-01', '2026-10-29 19:00', 11, null).success);
        System.assertEquals(false, create('REST-DEN-01', '2026-10-29 19:00', 2, null).success);
        System.assertEquals(false, create('REST-ATX-01', '2026-10-29 19:00', 2, 'x'.repeat(256)).success);

        System.assertEquals(count, [SELECT COUNT() FROM Reservation__c]);
        Reservation__c after = stored(first.reservationId);
        System.assertEquals(before.Reservation_Time__c, after.Reservation_Time__c);
        System.assertEquals(before.Special_Requests__c, after.Special_Requests__c);
        System.assertEquals(before.Party_Size__c, after.Party_Size__c);
    }

    @IsTest
    static void unknownDinerCannotBook() {
        pinNow(2026, 10, 20, 12, 0);
        LS_CreateReservation.Request req = new LS_CreateReservation.Request();
        req.membershipId = '1';
        req.restaurantId = 'REST-ATX-01';
        req.reservationTime = '2026-10-29 19:00';
        req.partySize = 2;
        LS_CreateReservation.Result r = createAs(req);
        System.assertEquals(false, r.success);
        System.assertEquals(0, [SELECT COUNT() FROM Reservation__c]);
    }

    @IsTest
    static void specialRequestsAreStoredExactlyAndReservationIsLinkedToTheDiner() {
        pinNow(2026, 10, 20, 12, 0);
        LS_CreateReservation.Result r = create('REST-ATX-01', '2026-10-29 19:00', 2, 'anniversary; nut allergy');
        System.assert(r.success, r.message);
        Reservation__c saved = stored(r.reservationId);
        System.assertEquals('anniversary; nut allergy', saved.Special_Requests__c);
        System.assertEquals(99000001, saved.Contact_ID__c.intValue());
        System.assertEquals('Test REST-ATX-01', saved.Restaurant_Name__c);
        System.assertEquals('Active', saved.Status__c);
    }

    @IsTest
    static void lookupIsScopedToTheDinerAndFailuresAreGeneric() {
        pinNow(2026, 10, 20, 12, 0);
        LS_CreateReservation.Result created = create('REST-ATX-01', '2026-10-29 19:00', 2, null);

        LS_GetReservation.Result good = lookup(DINER, 'diner', created.reservationId, 0);
        System.assert(good.found);
        System.assertEquals(0, good.failedAttempts.intValue());

        // Right reservation ID, wrong last name.
        LS_GetReservation.Result wrongName = lookup(DINER, 'Nobody', created.reservationId, 0);
        // Another diner (valid name for their own account) asking for this diner's reservation ID.
        LS_GetReservation.Result otherDiner = lookup(OTHER_DINER, 'Person', created.reservationId, 1);
        // Right name, reservation ID that does not exist.
        LS_GetReservation.Result noSuchId = lookup(DINER, 'Diner', 'RES-999', 2);

        for (LS_GetReservation.Result r : new List<LS_GetReservation.Result>{ wrongName, otherDiner, noSuchId }) {
            System.assertEquals(false, r.found);
            System.assertEquals('', r.reservationId);
            System.assertEquals(wrongName.message, r.message, 'Failure text must not reveal which detail was wrong');
        }
        System.assertEquals(1, wrongName.failedAttempts.intValue());
        System.assertEquals(2, otherDiner.failedAttempts.intValue());
        System.assertEquals(3, noSuchId.failedAttempts.intValue());
    }
}