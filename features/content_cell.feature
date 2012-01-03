Feature: Add content snippet cells and check the result
  In order to see what happens with the content cells on the public pages
  As an admin user
  I want to manage the content cells on the pages
  
  Scenario: Check the text snippet
    Given the page is setup in basic mode
    And I am logged in as "admin@example.com" with password "changeme"  
    And I go to the admin pages page
    When I add the Text widget snippet from the content cell to the body area at the page "home-en"
    And I follow "Contents" within "#pages-tree"
    And I follow "edit" within "#body"
    And I fill in "snippet_options_body" with "Hello World!"
    And I press "Save"
    Then I go to the homepage
    And the page should be valid
    And I should see "Hello World!"
  
  Scenario: Check the editor snippet
    Given the page is setup in basic mode
    And I am logged in as "admin@example.com" with password "changeme"  
    And I go to the admin pages page
    When I add the Rich text widget snippet from the content cell to the body area at the page "home-en"
    And I follow "Contents" within "#pages-tree"
    And I follow "edit" within "#body"
    And I fill in "snippet_options_body" with "Hello World!"
    And I press "Save"
    Then I go to the homepage
    And the page should be valid
    And I should see "Hello World!"
  
  Scenario: Check the editor snippet
    Given the page is setup in basic mode
    And I am logged in as "admin@example.com" with password "changeme"  
    And I go to the admin pages page
    When I add the Twitter stream snippet from the content cell to the body area at the page "home-en"
    And I follow "Contents" within "#pages-tree"
    And I follow "edit" within "#body"
    And I fill in "snippet_options_username" with "silviorelli"
    And I fill in "snippet_options_limit" with "10"
    And I press "Save"
    Then I go to the homepage
    And the page should be valid
    And I should see "Search jQuery"
  
  
  
  
  