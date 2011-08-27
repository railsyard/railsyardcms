Feature: Accessing the admin panel
  In order to manage the page
  As a user
  I want to access the admin panel
  
  Scenario: Sign in as a admin
    Given the page is setup in basic mode
    And I go to the admin page
    And I should see "Sign in"
    When I fill in "user_email" with "admin@example.com"
    And I fill in "user_password" with "changeme"
    And I press "Sign in"
    And I should be on the admin pages page
    And I should see "Pages list" within "header"
    
  # Scenario added for bugfix in commit:5c618b6
  Scenario: Create a new page without having a page before
    Given the page is setup in basic mode
    And I am logged in as "admin@example.com" with password "changeme"
    And I go to the admin page
    When I follow "Delete" within "table.datatable"
    And I go to the new admin page page
    And I fill in "title" with "My new page"
    And I check "page_visible_in_menu"
    And I check "page_published"
    And I uncheck "page_reserved"
    And I press "Save"
    Then I should be on the admin pages page
    And I should not see "Home en" within "#pages-tree"
    And I should see "My new page" within "#pages-tree"
  
  Scenario: Create a new page
    Given the page is setup in basic mode
    And I am logged in as "admin@example.com" with password "changeme"
    And I go to the new admin page page
    When I fill in "title" with "My new page"
    And I check "page_visible_in_menu"
    And I check "page_published"
    And I uncheck "page_reserved"
    And I press "Save"
    Then I should be on the admin pages page
    And I should see "Home en" within "#pages-tree"
    And I should see "My new page" within "#pages-tree"