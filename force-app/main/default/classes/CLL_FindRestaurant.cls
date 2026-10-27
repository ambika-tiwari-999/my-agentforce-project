public with sharing class CLL_FindRestaurant {

    @InvocableMethod(
        label='CLL Find Restaurant'
        description='Finds a restaurant by name, cuisine, city or zip code and returns its restaurant ID.'
    )
    public static List<Result> execute(List<Request> requests) {
        List<Result> results = new List<Result>();
        for (Request req : requests) {
            results.add(find(req.searchTerm, req.city));
        }
        return results;
    }

    private static Result find(String searchTerm, String city) {
        Result r = new Result();
        r.found = false;
        r.matchCount = 0;
        r.restaurantId = '';
        r.restaurantName = '';
        r.zipCode = '';
        String term = String.isBlank(searchTerm) ? '' : searchTerm.trim();
        String cityFilter = String.isBlank(city) ? '' : city.trim();
        if (term.equalsIgnoreCase(cityFilter)) {
            term = '';
        }
        if (term == '' && cityFilter == '') {
            r.message = 'Ask the diner for the restaurant name, city or zip code.';
            return r;
        }
        String nameFilter = '%' + term + '%';
        List<Restaurant__c> matches;
        if (cityFilter == '') {
            matches = [
                SELECT Name, Name__c, Restaurant_ID__c, City__c, Cuisine__c, Zip_Code__c, Operating_Hours__c
                FROM Restaurant__c
                WHERE Zip_Code__c = :term OR City__c = :term OR Cuisine__c LIKE :nameFilter OR Name LIKE :nameFilter OR Name__c LIKE :nameFilter
                WITH USER_MODE
                ORDER BY Name
                LIMIT 10
            ];
        } else {
            // A city narrows a name, cuisine or zip search, e.g. "Japanese" in "New York".
            matches = [
                SELECT Name, Name__c, Restaurant_ID__c, City__c, Cuisine__c, Zip_Code__c, Operating_Hours__c
                FROM Restaurant__c
                WHERE City__c = :cityFilter
                  AND (Zip_Code__c = :term OR Cuisine__c LIKE :nameFilter OR Name LIKE :nameFilter OR Name__c LIKE :nameFilter)
                WITH USER_MODE
                ORDER BY Name
                LIMIT 10
            ];
        }
        String label = cityFilter == '' ? term : (term == '' ? cityFilter : term + ' in ' + cityFilter);
        r.matchCount = matches.size();
        if (matches.isEmpty()) {
            r.message = 'No restaurant matches "' + label + '".';
        } else if (matches.size() == 1) {
            Restaurant__c match = matches[0];
            r.found = true;
            r.restaurantId = match.Restaurant_ID__c;
            r.restaurantName = CLL_DinerService.displayName(match);
            r.zipCode = match.Zip_Code__c;
            r.message = 'Found ' + r.restaurantName + ' (zip ' + match.Zip_Code__c + ').';
        } else {
            List<String> options = new List<String>();
            for (Restaurant__c match : matches) {
                options.add(CLL_DinerService.displayName(match) + ' (' + match.Cuisine__c + ', ' + match.City__c + ' ' + match.Zip_Code__c
                    + '; hours: ' + match.Operating_Hours__c + ')');
            }
            r.message = 'Several restaurants match: ' + String.join(options, '; ') + '. Ask the diner which one.';
        }
        return r;
    }

    public class Request {
        @InvocableVariable(label='Search Term' description='Restaurant name (or part of it), cuisine, city or zip code' required=true)
        public String searchTerm;

        @InvocableVariable(label='City' description='City to narrow the search, for example New York')
        public String city;
    }

    public class Result {
        @InvocableVariable(label='Found' description='True when exactly one restaurant matched')
        public Boolean found;

        @InvocableVariable(label='Restaurant ID' description='Restaurant code, for example REST-ATX-01')
        public String restaurantId;

        @InvocableVariable(label='Restaurant Name' description='Restaurant display name')
        public String restaurantName;

        @InvocableVariable(label='Zip Code' description='Restaurant zip code')
        public String zipCode;

        @InvocableVariable(label='Match Count' description='Number of restaurants that matched')
        public Integer matchCount;

        @InvocableVariable(label='Message' description='Result summary, including candidates when ambiguous')
        public String message;
    }
}