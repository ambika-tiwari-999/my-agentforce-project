@IsTest
private class LS_TimeZoneUtilTest {

    private static Datetime utc(String zoneId, String local) {
        return LS_TimeZoneUtil.toUtc(LS_TimeZoneUtil.parseLocal(local), zoneId);
    }

    private static void assertInstant(Datetime actual, Integer y, Integer mo, Integer d, Integer h, Integer mi) {
        System.assertEquals(Datetime.newInstanceGmt(y, mo, d, h, mi, 0), actual);
    }

    @IsTest
    static void austinDaylightTime() {
        // Thu Oct 29 2026, CDT (UTC-5)
        Datetime t = utc('America/Chicago', '2026-10-29 19:00');
        assertInstant(t, 2026, 10, 30, 0, 0);
        System.assertEquals('Thu, Oct 29, 2026 at 7:00 PM', LS_TimeZoneUtil.formatLocal(t, 'America/Chicago'));
    }

    @IsTest
    static void austinStandardTime() {
        // Fri Nov 6 2026, CST (UTC-6) after the Nov 1 clock change
        Datetime t = utc('America/Chicago', '2026-11-06 19:00');
        assertInstant(t, 2026, 11, 7, 1, 0);
        System.assertEquals('Fri, Nov 6, 2026 at 7:00 PM', LS_TimeZoneUtil.formatLocal(t, 'America/Chicago'));
    }

    @IsTest
    static void newYorkAndLosAngeles() {
        assertInstant(utc('America/New_York', '2026-11-06 19:00'), 2026, 11, 7, 0, 0);
        assertInstant(utc('America/Los_Angeles', '2026-11-06 19:00'), 2026, 11, 7, 3, 0);
        assertInstant(utc('America/Los_Angeles', '2026-10-29 19:00'), 2026, 10, 30, 2, 0);
    }

    @IsTest
    static void springForwardGapIsRejected() {
        // 2027-03-14 02:00-03:00 does not exist in Chicago.
        System.assertEquals(null, utc('America/Chicago', '2027-03-14 02:30'));
        // One minute either side exists.
        assertInstant(utc('America/Chicago', '2027-03-14 01:59'), 2027, 3, 14, 7, 59);
        assertInstant(utc('America/Chicago', '2027-03-14 03:00'), 2027, 3, 14, 8, 0);
    }

    @IsTest
    static void fallBackRepeatedHourUsesFirstOccurrence() {
        // 2026-11-01 01:30 happens twice in Chicago; the first (CDT, UTC-5) is used.
        assertInstant(utc('America/Chicago', '2026-11-01 01:30'), 2026, 11, 1, 6, 30);
        // 02:30 is only CST (UTC-6).
        assertInstant(utc('America/Chicago', '2026-11-01 02:30'), 2026, 11, 1, 8, 30);
    }

    @IsTest
    static void parseLocalRejectsBadInput() {
        System.assertEquals(null, LS_TimeZoneUtil.parseLocal(null));
        System.assertEquals(null, LS_TimeZoneUtil.parseLocal(''));
        System.assertEquals(null, LS_TimeZoneUtil.parseLocal('tomorrow at 7'));
        System.assertEquals(null, LS_TimeZoneUtil.parseLocal('2026-02-30 10:00'));
        System.assertEquals(null, LS_TimeZoneUtil.parseLocal('2026-13-01 10:00'));
        System.assertEquals(null, LS_TimeZoneUtil.parseLocal('2026-10-29 24:00'));
        System.assertNotEquals(null, LS_TimeZoneUtil.parseLocal('2026-10-29T19:00'));
        System.assertNotEquals(null, LS_TimeZoneUtil.parseLocal('2026-10-29 19:00:00'));
    }

    @IsTest
    static void zoneMapping() {
        System.assertEquals('America/Chicago', LS_TimeZoneUtil.zoneFor('Austin'));
        System.assertEquals('America/Chicago', LS_TimeZoneUtil.zoneFor(' chicago '));
        System.assertEquals('America/New_York', LS_TimeZoneUtil.zoneFor('New York'));
        System.assertEquals('America/New_York', LS_TimeZoneUtil.zoneFor('Miami'));
        System.assertEquals('America/Los_Angeles', LS_TimeZoneUtil.zoneFor('Los Angeles'));
        System.assertEquals(null, LS_TimeZoneUtil.zoneFor('Denver'));
        System.assertEquals(null, LS_TimeZoneUtil.zoneFor(null));
    }

    @IsTest
    static void wallClockRoundTripAndUtcFallback() {
        Datetime t = utc('America/Chicago', '2026-10-29 19:00');
        System.assertEquals(Datetime.newInstanceGmt(2026, 10, 29, 19, 0, 0), LS_TimeZoneUtil.asWallClock(t, 'America/Chicago'));
        System.assertEquals('Fri, Oct 30, 2026 at 12:00 AM UTC', LS_TimeZoneUtil.formatLocal(t, null));
        System.assertEquals('', LS_TimeZoneUtil.formatLocal(null, 'America/Chicago'));
    }

    @IsTest
    static void futureCheckUsesPinnedNow() {
        LS_TimeZoneUtil.nowOverride = Datetime.newInstanceGmt(2026, 10, 29, 18, 37, 0); // 1:37 PM CDT
        System.assertEquals(false, LS_TimeZoneUtil.isPast(utc('America/Chicago', '2026-10-29 15:30')));
        System.assertEquals(true, LS_TimeZoneUtil.isPast(utc('America/Chicago', '2026-10-29 13:00')));
    }
}