Feature: Editing the page at the frontend
  In order to manage the page
  As a admin
  I want to be able doing this at the frontend
  
  @javascript
  Scenario: Change snippet settings
    Given the page is setup in basic mode
    And I am logged in as "admin@example.com" with password "changeme"
    And I add the Markdown widget snippet from the markdown cell to the body area at the page "/en/home_en"
    And frontend controls are enabled
    And I go to the homepage
    When I click the javascript link ".drag_item a.edit"
    And I should see "Configuration: Markdown widget"
    And I fill in "snippet_options_body" with "Hello World! **This text is strong**"
    And I press "Save"
    And I wait until all Ajax requests are complete
    Then I should see "Hello World!" within ".markdown_text_widget"
    And I should see "This text is strong" within ".markdown_text_widget strong"