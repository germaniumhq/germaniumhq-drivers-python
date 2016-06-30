Feature: Tests if the browsers do open on the current platform
  using selenium.

  @1
  Scenario: Open Firefox using the embedded driver with marionette
    Given I open Firefox
    And I go to google
    Then the title is "Google"

  @2
  Scenario: Open Chrome using the embedded driver
    Given I open Chrome
    And I go to google
    Then the title is "Google"

  @3
  Scenario: Open IE using the embedded driver
    Given I open IE
    And I go to google
    Then the title is "Google"

