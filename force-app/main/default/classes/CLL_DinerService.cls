/**
 * Shared data access for the Intelligent Dinner CLL Agent actions.
 * Every reservation read or write goes through ownership checks scoped
 * by the diner's membership number (Contact.External_Diner_ID__c, which
 * matches Reservation__c.Contact_ID__c).
 */
public with sharing class CLL_DinerService {

    public static final String STATUS_ACTIVE = 'Active';
    public static final String STATUS_CANCELED = 'Canceled';
    /** Larger parties are group bookings, handled by a person. */
    public static final Integer MAX_PARTY_SIZE = 10;
    /** Last seating is this many minutes before closing. */
    public static final Integer LAST_SEATING_MINUTES = 30;

    private static final List<String> DAYS = new List<String>{ 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun' };
    private static final Pattern HOURS_SEGMENT = Pattern.compile(
        '(Daily|Mon|Tue|Wed|Thu|Fri|Sat|Sun)(?:\\s*-\\s*(Mon|Tue|Wed|Thu|Fri|Sat|Sun))?:\\s*'
        + '(\\d{1,2}:\\d{2}\\s*[AP]M|Noon|Midnight)\\s*-\\s*(\\d{1,2}:\\d{2}\\s*[AP]M|Noon|Midnight)'
    );

    public static String partySizeError(Integer partySize) {
        if (partySize == null || partySize <= 0) {
            return 'Party size must be at least 1 guest.';
        }
        if (partySize > MAX_PARTY_SIZE) {
            return 'Parties of more than ' + MAX_PARTY_SIZE + ' guests are group bookings handled by our team. '
                + 'Do not book it: offer to connect the diner with a person.';
        }
        return null;
    }

    /**
     * Returns why the restaurant can't seat a reservation at the given wall-clock
     * time, or null when it can. Hours are parsed from Operating_Hours__c, for
     * example "Mon-Thu: 11:00 AM - 10:00 PM; Sun: 10:00 AM - Midnight"; a closing
     * time after midnight belongs to the previous day. Unparseable hours are not
     * enforced.
     */
    public static String openingHoursError(Restaurant__c restaurant, Datetime value) {
        String hours = restaurant.Operating_Hours__c;
        if (String.isBlank(hours) || value == null) {
            return null;
        }
        Integer day = Integer.valueOf(value.formatGmt('u')) - 1; // 0 = Monday
        Integer previousDay = Math.mod(day + 6, 7);
        Integer minute = value.hourGmt() * 60 + value.minuteGmt();
        Boolean parsed = false;
        Matcher m = HOURS_SEGMENT.matcher(hours);
        while (m.find()) {
            parsed = true;
            Integer opens = toMinutes(m.group(3));
            Integer closes = toMinutes(m.group(4));
            if (closes <= opens) {
                closes += 1440;
            }
            Integer lastSeating = closes - LAST_SEATING_MINUTES;
            if (coversDay(m.group(1), m.group(2), day) && minute >= opens && minute <= lastSeating) {
                return null;
            }
            if (coversDay(m.group(1), m.group(2), previousDay) && minute + 1440 >= opens && minute + 1440 <= lastSeating) {
                return null;
            }
        }
        if (!parsed) {
            return null;
        }
        return displayName(restaurant) + ' cannot seat a reservation on ' + formatTime(value)
            + '. Opening hours: ' + hours + ' Last seating is ' + LAST_SEATING_MINUTES
            + ' minutes before closing. Ask the diner for another day or time.';
    }

    private static Boolean coversDay(String first, String last, Integer day) {
        if (first == 'Daily') {
            return true;
        }
        Integer start = DAYS.indexOf(first);
        if (last == null) {
            return day == start;
        }
        Integer span = Math.mod(DAYS.indexOf(last) - start + 7, 7);
        return Math.mod(day - start + 7, 7) <= span;
    }

    private static Integer toMinutes(String value) {
        if (value == 'Midnight') {
            return 0;
        }
        if (value == 'Noon') {
            return 720;
        }
        String clock = value.replaceAll('[^0-9:]', '');
        Boolean pm = value.endsWith('PM');
        Integer hour = Math.mod(Integer.valueOf(clock.substringBefore(':')), 12) + (pm ? 12 : 0);
        return hour * 60 + Integer.valueOf(clock.substringAfter(':').left(2));
    }

    public static Contact findDiner(String membershipId) {
        if (String.isBlank(membershipId)) {
            return null;
        }
        String externalId = membershipId.trim();
        List<Contact> diners = [
            SELECT Id, FirstName, LastName, Phone, External_Diner_ID__c
            FROM Contact
            WHERE External_Diner_ID__c = :externalId
            WITH USER_MODE
            LIMIT 1
        ];
        return diners.isEmpty() ? null : diners[0];
    }

    public static Decimal toMembershipNumber(String membershipId) {
        try {
            return Decimal.valueOf(membershipId.trim());
        } catch (Exception e) {
            return null;
        }
    }

    /** Returns the reservation only if it belongs to the given membership. */
    public static Reservation__c findOwnedReservation(String membershipId, String reservationId) {
        Decimal membershipNumber = toMembershipNumber(membershipId);
        if (membershipNumber == null || String.isBlank(reservationId)) {
            return null;
        }
        String normalizedId = reservationId.trim().toUpperCase();
        List<Reservation__c> reservations = [
            SELECT Id, Reservation_ID__c, Contact_ID__c, Restaurant_ID__c,
                   Party_Size__c, Status__c, Reservation_Time__c
            FROM Reservation__c
            WHERE Reservation_ID__c = :normalizedId
              AND Contact_ID__c = :membershipNumber
            WITH USER_MODE
            LIMIT 1
        ];
        return reservations.isEmpty() ? null : reservations[0];
    }

    public static Restaurant__c findRestaurantByCode(String restaurantId) {
        if (String.isBlank(restaurantId)) {
            return null;
        }
        String code = restaurantId.trim();
        List<Restaurant__c> restaurants = [
            SELECT Id, Name, Name__c, Restaurant_ID__c, City__c, Zip_Code__c, Phone_Number__c,
                   Cuisine__c, Operating_Hours__c, Parking_Policy__c, Menu_Details__c
            FROM Restaurant__c
            WHERE Restaurant_ID__c = :code
            WITH USER_MODE
            LIMIT 1
        ];
        return restaurants.isEmpty() ? null : restaurants[0];
    }

    public static String restaurantName(String restaurantId) {
        Restaurant__c restaurant = findRestaurantByCode(restaurantId);
        return restaurant == null ? restaurantId : displayName(restaurant);
    }

    /** The restaurant name lives in the standard Name field; Name__c is a legacy copy. */
    public static String displayName(Restaurant__c restaurant) {
        return String.isNotBlank(restaurant.Name__c) ? restaurant.Name__c : restaurant.Name;
    }

    /**
     * Reservation times are stored as wall-clock values in GMT
     * (19:00Z means 7:00 PM at the restaurant), so they are read and
     * written in GMT without time zone conversion.
     */
    public static String formatTime(Datetime value) {
        return value == null ? '' : value.formatGmt('EEE, MMM d, yyyy \'at\' h:mm a');
    }

    /** Parses "yyyy-MM-dd HH:mm" (or with seconds) as a wall-clock GMT value. */
    public static Datetime parseTime(String value) {
        if (String.isBlank(value)) {
            return null;
        }
        String normalized = value.trim().replace('T', ' ');
        if (normalized.length() == 16) {
            normalized += ':00';
        }
        try {
            return Datetime.valueOfGmt(normalized);
        } catch (Exception e) {
            return null;
        }
    }

    @InvocableMethod(
        label='CLL Validate Restaurant By Code'
        description='Confirms Restaurant_ID__c exists on Restaurant__c; used by Ambika Monday Demo Agent FAQ context setup.'
    )
    public static List<ValidateRestaurantResult> validateRestaurantByCode(List<ValidateRestaurantRequest> requests) {
        List<ValidateRestaurantResult> results = new List<ValidateRestaurantResult>();
        for (ValidateRestaurantRequest req : requests) {
            results.add(buildValidateRestaurantResult(req.restaurantId));
        }
        return results;
    }

    private static ValidateRestaurantResult buildValidateRestaurantResult(String restaurantId) {
        ValidateRestaurantResult r = new ValidateRestaurantResult();
        r.found = false;
        r.restaurantName = '';
        r.phone = '';
        r.operatingHours = '';
        r.currentDateTime = Datetime.now().format('EEE, MMM d, yyyy h:mm a z');
        String code = String.isBlank(restaurantId) ? '' : restaurantId.trim();
        if (code == '') {
            r.message = 'Provide a restaurant ID (for example REST-ATX-01).';
            return r;
        }
        Restaurant__c restaurant = findRestaurantByCode(code);
        if (restaurant == null) {
            r.message = 'No restaurant found for ID "' + code + '". Check the ID and try again.';
            return r;
        }
        r.found = true;
        r.restaurantName = displayName(restaurant);
        r.phone = restaurant.Phone_Number__c == null ? '' : String.valueOf(restaurant.Phone_Number__c);
        r.operatingHours = restaurant.Operating_Hours__c == null ? '' : String.valueOf(restaurant.Operating_Hours__c);
        r.message = 'Found ' + r.restaurantName + ' (' + code + ').';
        return r;
    }

    public class ValidateRestaurantRequest {
        @InvocableVariable(label='Restaurant ID' description='Restaurant business key, for example REST-ATX-01' required=true)
        public String restaurantId;
    }

    public class ValidateRestaurantResult {
        @InvocableVariable(label='Found' description='True when the restaurant ID exists in CRM')
        public Boolean found;

        @InvocableVariable(label='Restaurant Name' description='Display name from Restaurant__c')
        public String restaurantName;

        @InvocableVariable(label='Phone' description='Restaurant Phone_Number__c from CRM')
        public String phone;

        @InvocableVariable(label='Operating Hours' description='Restaurant Operating_Hours__c from CRM')
        public String operatingHours;

        @InvocableVariable(label='Current Date Time' description='Current date and time when validated')
        public String currentDateTime;

        @InvocableVariable(label='Message' description='Summary for the agent planner')
        public String message;
    }
}