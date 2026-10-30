/**
 * Converts between restaurant-local wall-clock text and true UTC instants,
 * using named time zones so daylight saving time is handled by the platform
 * (no fixed offsets). Restaurant__c has no time zone field, so the zone is
 * derived from City__c.
 *
 * DST policy for local times typed by a diner:
 *  - Skipped hour (spring forward, e.g. 2027-03-14 02:30 in Chicago): the local
 *    time does not exist, toUtc returns null and the caller refuses the booking.
 *  - Repeated hour (fall back, e.g. 2026-11-01 01:30 in Chicago): the local time
 *    happens twice; the first occurrence (still daylight time) is used.
 */
public with sharing class LS_TimeZoneUtil {

    private static final Pattern LOCAL_TIME = Pattern.compile(
        '^(\\d{4})-(\\d{2})-(\\d{2})[ T](\\d{2}):(\\d{2})(?::(\\d{2}))?$'
    );
    private static final String DISPLAY_PATTERN = 'EEE, MMM d, yyyy \'at\' h:mm a';

    /** Lets tests pin "now" so the future-time check is deterministic. */
    @TestVisible private static Datetime nowOverride;

    public static Datetime now() {
        return nowOverride != null ? nowOverride : Datetime.now();
    }

    /** True when the instant is earlier than now. */
    public static Boolean isPast(Datetime instant) {
        return instant < now();
    }

    /** Returns the IANA zone for a restaurant city, or null when the city is not mapped. */
    public static String zoneFor(String city) {
        if (String.isBlank(city)) {
            return null;
        }
        String key = city.trim().toLowerCase();
        if (key == 'austin' || key == 'chicago') {
            return 'America/Chicago';
        }
        if (key == 'new york' || key == 'miami') {
            return 'America/New_York';
        }
        if (key == 'los angeles') {
            return 'America/Los_Angeles';
        }
        return null;
    }

    /**
     * Parses "yyyy-MM-dd HH:mm" (or with seconds, or a T separator) into a
     * Datetime whose GMT fields are the typed wall-clock fields. This is NOT yet
     * an instant; pass it to toUtc. Returns null for malformed or impossible dates.
     */
    public static Datetime parseLocal(String value) {
        if (String.isBlank(value)) {
            return null;
        }
        Matcher m = LOCAL_TIME.matcher(value.trim());
        if (!m.matches()) {
            return null;
        }
        Integer year = Integer.valueOf(m.group(1));
        Integer month = Integer.valueOf(m.group(2));
        Integer day = Integer.valueOf(m.group(3));
        Integer hour = Integer.valueOf(m.group(4));
        Integer minute = Integer.valueOf(m.group(5));
        Integer second = m.group(6) == null ? 0 : Integer.valueOf(m.group(6));
        if (month < 1 || month > 12 || day < 1 || day > Date.daysInMonth(year, month)
            || hour > 23 || minute > 59 || second > 59) {
            return null;
        }
        return Datetime.newInstanceGmt(year, month, day, hour, minute, second);
    }

    /**
     * Converts wall-clock fields (from parseLocal) in the named zone to the real
     * UTC instant. Returns null when that local time does not exist (DST gap).
     */
    public static Datetime toUtc(Datetime wallClock, String zoneId) {
        if (wallClock == null || String.isBlank(zoneId)) {
            return null;
        }
        TimeZone tz = TimeZone.getTimeZone(zoneId);
        // The offset can only differ across a DST change, so sample a day on each side.
        Integer offsetBefore = tz.getOffset(wallClock.addHours(-24));
        Integer offsetAfter = tz.getOffset(wallClock.addHours(24));
        List<Datetime> valid = new List<Datetime>();
        Set<Integer> tried = new Set<Integer>();
        for (Integer offset : new List<Integer>{ offsetBefore, offsetAfter }) {
            if (!tried.add(offset)) {
                continue;
            }
            Datetime candidate = wallClock.addSeconds(-((Decimal) offset / 1000).intValue());
            if (tz.getOffset(candidate) == offset) {
                valid.add(candidate);
            }
        }
        if (valid.isEmpty()) {
            return null;
        }
        Datetime earliest = valid[0];
        for (Datetime candidate : valid) {
            if (candidate < earliest) {
                earliest = candidate;
            }
        }
        return earliest;
    }

    /**
     * Re-expresses a UTC instant as wall-clock fields in the zone, stored in the
     * GMT fields of the result. This is the shape CLL_DinerService.openingHoursError
     * expects, so the unchanged shared helper can be reused.
     */
    public static Datetime asWallClock(Datetime instant, String zoneId) {
        return Datetime.valueOfGmt(instant.format('yyyy-MM-dd HH:mm:ss', zoneId));
    }

    /** Formats an instant in the restaurant's local time; falls back to labelled UTC without a zone. */
    public static String formatLocal(Datetime instant, String zoneId) {
        if (instant == null) {
            return '';
        }
        return String.isBlank(zoneId)
            ? instant.formatGmt(DISPLAY_PATTERN) + ' UTC'
            : instant.format(DISPLAY_PATTERN, zoneId);
    }
}