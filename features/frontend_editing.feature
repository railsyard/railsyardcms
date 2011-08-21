Feature: Editing the page at the frontend
  In order to manage the page
  As a admin
  I want to be able doing this at the frontend
  
  @javascript
  Scenario: Change snippet settings
    Given the page is setup in basic mode
    And I am logged in as "admin@example.com" with password "changeme"
    And I add the Text widget snippet from the content cell to the body area at the page "/en/home_en"
    And frontend controls are enabled
    And I go to the homepage
    When I click the javascript link ".drag_item a.edit"
    And I should see "Configuration: Text widget"
    And I fill in "snippet_options_body" with "Hello World!"
    And I press "Save"
    And I wait until all Ajax requests are complete
    Then I should see "Hello World!" within ".text_widget"
  
  @javascript
  Scenario: Change snippet settings to invalid value
    Given the page is setup in basic mode
    And I am logged in as "admin@example.com" with password "changeme"
    And I add the Text widget snippet from the content cell to the body area at the page "/en/home_en"
    And frontend controls are enabled
    And I go to the homepage
    When I click the javascript link ".drag_item a.edit"
    And I should see "Configuration: Text widget"
    And I fill in "snippet[title]" with ""
    And I press "Save"
    And I wait until all Ajax requests are complete
    Then I should see "Configuration: Text widget"
    And I should see "Title can't be blank" within ".error"
    
  @javascript
  Scenario: Delete the snippet
    Given the page is setup in basic mode
    And I am logged in as "admin@example.com" with password "changeme"
    And I add the Text widget snippet from the content cell to the body area at the page "/en/home_en"
    And the snippet option "body" is set to "Hello World!"
    And frontend controls are enabled
    And I go to the homepage
    And I should see "Hello World!" within ".text_widget"
    When I click the javascript link ".drag_item a.delete"
    And I confirm popup
    Then I should not see "Hello World!" within "#body"