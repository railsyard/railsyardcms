Feature: Manage pages admin panel and check effects on public side
  In order to see what happens on the public side
  As an admin user
  I want to manage the pages from the backend
  
  Scenario: Create a new empty page and check it out
    Given the page is setup in basic mode
    And I am logged in as "admin@example.com" with password "changeme"
    When I go to the admin page
    And I go to the new admin page page
    And I fill in "title" with "An empty test"
    And I check "page_visible_in_menu"
    And I check "page_published"
    And I uncheck "page_reserved"
    And I press "Save"
    Then I should be on the admin pages page
    And I should see "An empty test" within "#pages-tree"
    And I manually visit "/en/an-empty-test"
    And the page should be valid
  
  Scenario: Look for a page via pretty url
    Given the page is setup in basic mode
    When I open the page with pretty url "home-en"
    Then the page should be valid
  
  @javascript
  Scenario: Sort the pages tree order
    Given there are some example pages
    And I am logged in as "admin@example.com" with password "changeme"
    When I go to the admin pages page
    #And I newDrag "li#page-4 div" to "ol.sortable.ui-sortable"
    And I newDrag via XPath "/html/body/div/div[2]/div/div[3]/div/ol/li[2]/ol/li/div" to "/html/body/div/div[2]/div/div[3]/div/ol"
    And I press "Save"
    And I sleep 2 seconds
    And I confirm popup
    Then I should be on the admin pages page
    And I manually visit "/en/child"
    And the page should be js valid
  
  Scenario: Check if a reserved page is hidden to normal users
    Given the page is setup in basic mode
    And I am logged in as "admin@example.com" with password "changeme"
    And I go to the admin pages page
    When I follow "Properties" within "table.datatable"
    And I check "page_reserved"
    And I press "Save"
    And I should be on the admin pages page
    And I go to the homepage
    And the page should be valid
    Then I manually visit "/logout"
    And I go to the homepage
    And I should see "You can't access this resource, sorry."
  
  @javascript
  Scenario: Change layout to a page and check if snippets are moved to limbo
    Given the page is setup in basic mode
    And I am logged in as "admin@example.com" with password "changeme"
    And I go to the admin pages page
    When I add the Text widget snippet from the content cell to the body area at the page "home-en"
    #And I follow "Contents" within "table.datatable" #does not work, dunno why..
    And I manually visit "/admin/pages/2"
    And I should see "Text widget" within "#body" 
    And I select "Two columns" from "layout"
    And I confirm popup
    Then I should see "Text widget" within "#limbo"
  
  
  
    