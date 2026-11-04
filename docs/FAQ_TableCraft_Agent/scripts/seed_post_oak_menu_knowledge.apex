/**
 * ============================================================================
 * Script:      seed_post_oak_menu_knowledge.apex
 * Updated On:  Tuesday, Nov 3, 2026 against `agentforce-org`
 * Plan Doc:    docs/FAQ_TableCraft_Agent/specs_plans/rag_knowledge_article_setup.md
 * Plan Step:   Step 3 ("Seed & Publish the Knowledge__kav Articles for Our Restaurants")
 *
 * How it is run:
 *   sf apex run --file docs/FAQ_TableCraft_Agent/scripts/seed_post_oak_menu_knowledge.apex --target-org agentforce-org
 *
 * Articles Seeded & Published (`PublishStatus = 'Online'`) for Post Oak Smokehouse (`REST-ATX-02`):
 *   1. Category__c = 'Menu'               ('post-oak-smokehouse-menu')
 *   2. Category__c = 'Parking_And_Access' ('post-oak-smokehouse-parking-and-access')
 *   3. Category__c = 'Policies'           ('post-oak-smokehouse-policies')
 * ============================================================================
 */

// 1. Menu Article (Category__c = 'Menu')
List<Knowledge__kav> existingMenu = [
    SELECT Id, KnowledgeArticleId, PublishStatus
    FROM Knowledge__kav
    WHERE UrlName = 'post-oak-smokehouse-menu'
];

if (existingMenu.isEmpty()) {
    Knowledge__kav menuArticle = new Knowledge__kav(
        Title = 'Post Oak Smokehouse — Menu & Craft Beer',
        UrlName = 'post-oak-smokehouse-menu',
        Restaurant_ID__c = 'REST-ATX-02',
        Category__c = 'Menu',
        IsVisibleInPkb = true,
        IsVisibleInApp = true,
        Summary = 'Authentic Texas pit BBQ smoked over aged post oak at Post Oak Smokehouse (REST-ATX-02) in Austin, TX.',
        Detail__c = '<h2>Post Oak Smokehouse — Menu & Craft Beer (REST-ATX-02)</h2>'
            + '<p><b>Cuisine:</b> Authentic Texas pit BBQ, Southern sides, and Craft Beer smoked over aged post oak.</p>'
            + '<h3>Signature Smoked Meats</h3>'
            + '<ul>'
            + '<li><b>16-Hour Smoked Prime Brisket ($28 / half lb)</b> [Gluten-Free]: USDA Prime Black Angus brisket rubbed with coarse black pepper and kosher salt, smoked low and slow over aged Texas post oak for 16 hours. Available lean or moist.</li>'
            + '<li><b>Heritage Pork Spare Ribs ($24 / half rack)</b> [Gluten-Free]: Central Texas-style St. Louis cut pork spare ribs glazed with house apple-cider mop sauce.</li>'
            + '<li><b>Cheddar Jalapeno Sausage ($16)</b>: House-ground pork and beef links stuffed with aged sharp cheddar and fresh roasted jalapenos, snapped over post oak smoke.</li>'
            + '<li><b>Pulled Pork Shoulder ($20)</b> [Gluten-Free]: 12-hour smoked heritage pork shoulder served with tangy Carolina-Texas hybrid vinegar pepper sauce.</li>'
            + '</ul>'
            + '<h3>Southern Sides & Starters</h3>'
            + '<ul>'
            + '<li><b>Bourbon Skillet Cornbread ($10)</b> [Vegetarian]: Cast-iron sweet corn cake brushed with sorghum bourbon butter.</li>'
            + '<li><b>Smoked Gouda Mac & Cheese ($12)</b> [Vegetarian]: Cavatappi pasta baked with smoked gouda, sharp cheddar, and toasted panko crust.</li>'
            + '<li><b>Pit-Smoked Charro Beans ($9)</b>: Pinto beans simmered under the brisket drippings with bacon, jalapeno, and cilantro.</li>'
            + '<li><b>House Pickles, Onions & Texas Toast</b>: Complimentary with all meat plates.</li>'
            + '</ul>'
            + '<h3>Desserts & Craft Beer Bar</h3>'
            + '<ul>'
            + '<li><b>Texas Pecan Banana Pudding ($11)</b>: Layered vanilla wafer pudding topped with toasted Hill Country pecans.</li>'
            + '<li><b>Craft Beer Program</b>: 24 rotating local Austin and Texas Hill Country draft craft beers on tap, plus Texas bourbons and house sweet tea.</li>'
            + '</ul>'
    );
    insert menuArticle;
    Id kaId = [SELECT KnowledgeArticleId FROM Knowledge__kav WHERE Id = :menuArticle.Id].KnowledgeArticleId;
    KbManagement.PublishingService.publishArticle(kaId, true);
    System.debug('Published Menu Article: ' + kaId);
}

// 2. Parking & Access Article (Category__c = 'Parking_And_Access')
List<Knowledge__kav> existingParking = [
    SELECT Id, KnowledgeArticleId, PublishStatus
    FROM Knowledge__kav
    WHERE UrlName = 'post-oak-smokehouse-parking-and-access'
];

if (existingParking.isEmpty()) {
    Knowledge__kav parkingArticle = new Knowledge__kav(
        Title = 'Post Oak Smokehouse — Parking, Patio & Accessibility',
        UrlName = 'post-oak-smokehouse-parking-and-access',
        Restaurant_ID__c = 'REST-ATX-02',
        Category__c = 'Parking_And_Access',
        IsVisibleInPkb = true,
        IsVisibleInApp = true,
        Summary = 'Free parking lot, ADA wheelchair accessibility, and shaded live-oak beer garden patio details for Post Oak Smokehouse (REST-ATX-02) in Austin, TX.',
        Detail__c = '<h2>Post Oak Smokehouse — Parking, Patio & Accessibility (REST-ATX-02)</h2>'
            + '<h3>Parking Lot & Street Parking</h3>'
            + '<ul>'
            + '<li><b>Free On-Site Parking Lot:</b> Post Oak Smokehouse has a free private surface parking lot directly behind the smokehouse with 45 guest spaces, entered from South Lamar Blvd.</li>'
            + '<li><b>Valet Parking:</b> No valet service is offered; all on-site lot parking is complimentary for diners. Free street parking is also available along Barton Springs Rd after 6:00 PM.</li>'
            + '</ul>'
            + '<h3>Outdoor Patio & Seating</h3>'
            + '<ul>'
            + '<li><b>Shaded Live-Oak Beer Garden Patio:</b> Features a covered outdoor cedar patio and picnic garden under heritage live oaks with misting fans in summer and patio heaters in winter.</li>'
            + '</ul>'
            + '<h3>Entrance & ADA Accessibility</h3>'
            + '<ul>'
            + '<li><b>Wheelchair & Stroller Access:</b> Step-free ramp access at both the main front porch entrance and the rear parking lot entrance, with wide aisles and ADA-compliant restrooms.</li>'
            + '</ul>'
    );
    insert parkingArticle;
    Id kaId = [SELECT KnowledgeArticleId FROM Knowledge__kav WHERE Id = :parkingArticle.Id].KnowledgeArticleId;
    KbManagement.PublishingService.publishArticle(kaId, true);
    System.debug('Published Parking_And_Access Article: ' + kaId);
}

// 3. Policies Article (Category__c = 'Policies')
List<Knowledge__kav> existingPolicies = [
    SELECT Id, KnowledgeArticleId, PublishStatus
    FROM Knowledge__kav
    WHERE UrlName = 'post-oak-smokehouse-policies'
];

if (existingPolicies.isEmpty()) {
    Knowledge__kav policiesArticle = new Knowledge__kav(
        Title = 'Post Oak Smokehouse — Dress Code, Kids, Pets & Event Policies',
        UrlName = 'post-oak-smokehouse-policies',
        Restaurant_ID__c = 'REST-ATX-02',
        Category__c = 'Policies',
        IsVisibleInPkb = true,
        IsVisibleInApp = true,
        Summary = 'Casual Austin dress code, family and dog-friendly patio rules, cancellation policy, and private event policies for Post Oak Smokehouse (REST-ATX-02).',
        Detail__c = '<h2>Post Oak Smokehouse — Dress Code, Kids, Pets & Event Policies (REST-ATX-02)</h2>'
            + '<h3>Dress Code</h3>'
            + '<ul>'
            + '<li><b>Casual & Come-As-You-Are:</b> Post Oak Smokehouse has a relaxed, casual Austin dress code. Jeans, boots, shorts, and t-shirts are welcome in both the main dining room and outdoor beer garden (shirts and shoes required).</li>'
            + '</ul>'
            + '<h3>Children & Pet Policy</h3>'
            + '<ul>'
            + '<li><b>Family & Kids Friendly:</b> Children of all ages are welcome; high chairs, booster seats, and a kids BBQ slider plate are available.</li>'
            + '<li><b>Dog-Friendly Outdoor Patio:</b> Well-behaved, leashed dogs are welcome on the outdoor live-oak beer garden patio (water bowls provided). Only ADA service animals are permitted inside the main indoor dining room.</li>'
            + '</ul>'
            + '<h3>Private Dining, Large Groups & Cancellation Policy</h3>'
            + '<ul>'
            + '<li><b> semi-Private Pitmaster Room (Up to 10 Guests Online):</b> Standard reservations up to 10 guests can be booked directly. Groups of 8 to 10 guests may request the semi-private Pitmaster Table at no extra room fee. Parties of 11 or more guests require a custom group event inquiry with a team member.</li>'
            + '<li><b>Cancellation Policy:</b> Reservations may be modified or cancelled at no charge up until the reservation time.</li>'
            + '</ul>'
    );
    insert policiesArticle;
    Id kaId = [SELECT KnowledgeArticleId FROM Knowledge__kav WHERE Id = :policiesArticle.Id].KnowledgeArticleId;
    KbManagement.PublishingService.publishArticle(kaId, true);
    System.debug('Published Policies Article: ' + kaId);
}
