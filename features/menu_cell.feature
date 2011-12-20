Feature: Add menu snippet cells and check the result
  In order to see what happens with the cells on the public pages
  As an admin user
  I want to manage the cells on the pages
  
  Scenario: Check the first level menu
    Given there are some example pages
    And I am logged in as "admin@example.com" with password "changeme"
    And I go to the admin pages page
    When I add the First level snippet from the menu cell to the header area at the page "home-en"
    And I go to the homepage
    Then the page should be valid
    And I should see "Home en" within "nav.firstlevel-menu"
    And I should see "Second" within "nav.firstlevel-menu"
    And I should see "Third" within "nav.firstlevel-menu"
  
  Scenario: Check the two levels menu
    Given there are some example pages
    And I am logged in as "admin@example.com" with password "changeme"
    And I go to the admin pages page
    When I add the Two levels snippet from the menu cell to the header area at the page "home-en"
    And I go to the homepage
    Then the page should be valid
    And I should see "Home en" within "nav.twolevels-menu"
    And I should see "Second" within "nav.twolevels-menu"
    And I should see "Third" within "nav.twolevels-menu"
    And I should see "Child" within "nav.twolevels-menu"
    
  Scenario: Check the siblings menu
    Given there are some example pages
    And I am logged in as "admin@example.com" with password "changeme"
    And I go to the admin pages page
    When I add the Siblings snippet from the menu cell to the header area at the page "home-en"
    And I go to the homepage
    Then the page should be valid
    And I should see "Home en" within "nav.siblings_menu"
    And I should see "Second" within "nav.siblings_menu"
    And I should see "Third" within "nav.siblings_menu"
  
  Scenario: Check the children menu
    Given there are some example pages
    And I am logged in as "admin@example.com" with password "changeme"
    And I go to the admin pages page
    When I add the Children snippet from the menu cell to the header area at the page "second"
    And I open the page with pretty url "second"
    Then the page should be valid
    And I should see "Child" within "nav.children-menu"
    And I should not see "Third"
  
  Scenario: Check the siblings and children menu
    Given there are some example pages
    And I am logged in as "admin@example.com" with password "changeme"
    And I go to the admin pages page
    When I add the Siblings and children snippet from the menu cell to the header area at the page "home-en"
    And I go to the homepage
    Then the page should be valid
    And I should see "Home en" within "nav.siblings-and-children-menu"
    And I should see "Second" within "nav.siblings-and-children-menu"
    And I should see "Third" within "nav.siblings-and-children-menu"
    And I should see "Child" within "nav.siblings-and-children-menu"
  
  Scenario: Check the footer menu
    Given there are some example pages
    And I am logged in as "admin@example.com" with password "changeme"
    And I go to the admin pages page
    When I add the Footer snippet from the menu cell to the header area at the page "home-en"
    And I go to the homepage
    Then the page should be valid
    And I should see "Home en" within "section.footer_menu"
    And I should see "Second" within "section.footer_menu"
    And I should see "Third" within "section.footer_menu"
    And I should see "Child" within "section.footer_menu"
  
  Scenario: Check the navigation menu
    Given there are some example pages
    And I am logged in as "admin@example.com" with password "changeme"
    And I go to the admin pages page
    When I add the Nav snippet from the menu cell to the header area at the page "child"
    And I open the page with pretty url "child"
    Then the page should be valid
    And I should see "Second" within "nav.nav-menu"
    And I should see "Child" within "nav.nav-menu"
    And I should not see "Third"
  
  
  