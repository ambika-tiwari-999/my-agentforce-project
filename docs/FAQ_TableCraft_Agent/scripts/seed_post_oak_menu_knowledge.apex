/**
 * ============================================================================
 * Script:      seed_post_oak_menu_knowledge.apex
 * Executed On: Tuesday, Nov 3, 2026 at 9:09 AM PST against `agentforce-org`
 * Plan Doc:    docs/FAQ_TableCraft_Agent/specs_plans/rag_knowledge_article_setup.md
 * Plan Step:   Step 3 ("Seed & Publish the Knowledge__kav Articles for Our Restaurants")
 *
 * How it was run:
 *   sf apex run --file docs/FAQ_TableCraft_Agent/scripts/seed_post_oak_menu_knowledge.apex --target-org agentforce-org
 *
 * Result in `agentforce-org`:
 *   - Knowledge__kav Id:          ka0g7000001cvSvAAI
 *   - KnowledgeArticleId:         kA0g7000001HMefCAG
 *   - ArticleNumber:              000001042
 *   - Restaurant_ID__c:           REST-ATX-02 (Post Oak Smokehouse — Austin, TX)
 *   - Category__c:                Menu
 *   - PublishStatus:              Online (IsLatestVersion = true)
 * ============================================================================
 */

// 1. Check if a draft or online article with UrlName 'post-oak-smokehouse-menu' already exists
List<Knowledge__kav> existing = [
    SELECT Id, KnowledgeArticleId, PublishStatus
    FROM Knowledge__kav
    WHERE UrlName = 'post-oak-smokehouse-menu'
];

if (existing.isEmpty()) {
    // 2. Insert the Knowledge__kav record (starts in PublishStatus = 'Draft')
    Knowledge__kav menuArticle = new Knowledge__kav(
        Title = 'Post Oak Smokehouse — Menu & Craft Beer',
        UrlName = 'post-oak-smokehouse-menu',
        Restaurant_ID__c = 'REST-ATX-02',
        Category__c = 'Menu',
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

    // 3. Query back the parent KnowledgeArticleId and publish to 'Online' status
    //    (Data 360 only indexes Published / 'Online' articles)
    Id kaId = [SELECT KnowledgeArticleId FROM Knowledge__kav WHERE Id = :menuArticle.Id].KnowledgeArticleId;
    KbManagement.PublishingService.publishArticle(kaId, true);
    System.debug('Created and Published Knowledge Article! KnowledgeArticleId: ' + kaId);
} else {
    System.debug('Article already exists: ' + existing[0].Id + ' status=' + existing[0].PublishStatus);
}
