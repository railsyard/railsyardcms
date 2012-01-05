Feature: Add content snippet cells and check the result
  In order to see what happens with the article cells on the public pages
  As an admin user
  I want to manage the article cells on the pages
  
  Scenario: Check the article show
    Given the page is setup in basic mode
    And there are some example articles
    And I am logged in as "admin@example.com" with password "changeme"
    And I go to the admin pages page
    When I add the Articles list snippet from the content cell to the body area at the page "home-en"
    And I follow "Contents" within "#pages-tree"
    And I follow "edit" within "#body"
    And I check "category_main"
    And I press "Save"
    And I add the Article show snippet from the article cell to the body area at the articles design
    And I go to the homepage
    Then the page should be valid
    And I follow "Full article"
    And I should see "First article"
    And I should see "Ut enim ad minim veniam"
    
  Scenario: Check the article comments
    Given the page is setup in basic mode
    And there are some example articles
    And I am logged in as "admin@example.com" with password "changeme"
    And I go to the admin pages page
    When I add the Articles list snippet from the content cell to the body area at the page "home-en"
    And I follow "Contents" within "#pages-tree"
    And I follow "edit" within "#body"
    And I check "category_main"
    And I press "Save"
    And I add the Article show snippet from the article cell to the body area at the articles design
    And I add the Comments snippet from the article cell to the body area at the articles design
    And I go to the homepage
    Then the page should be valid
    And I follow "Full article"
    And I should see "First article"
    And I should see "Ut enim ad minim veniam"
    And I should see "Comments"
    # TO-DO
    # - test comment list
    # - test comment submit
    