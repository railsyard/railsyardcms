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
    # page "child" with id 4, nested under page "second"
    And I newDrag "li#page-4 div" to "ol.sortable.ui-sortable"
    And I press "Save"
    And I confirm popup
    Then I should be on the admin pages page
    And I manually visit "/en/child"
    And the page should be js valid
    
  # @javascript
  # Scenario: Add the first level menu snippet to a page
  #   Given the page is setup in basic mode
  #   And I am logged in as "admin@example.com" with password "changeme"
  #   When I go to the admin pages page
  #   And I follow "Contents" within "li#page-2"
  #   
  #   # And I newDrag "#menu%first_level" to "#available_areas #header"
  #   # And I drag "div[data-snipid='menu%first_level']" to "#available_areas #header"
  #   
  #   # And I sleep 30 seconds
  #   
  #   
    