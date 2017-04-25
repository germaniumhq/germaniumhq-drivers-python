Feature: Tests if the browsers do open on the current platform
  using selenium.

  @1 @nochrome @noie @noedge
  Scenario: Open Firefox using the embedded driver with marionette
    Given I open Firefox
    And I go to google
    Then the title is "Google"

  @2 @noie @nofirefox @noedge
  Scenario: Open Chrome using the embedded driver
    Given I open Chrome
    And I go to google
    Then the title is "Google"

  @3 @nochrome @nofirefox @noedge
  Scenario: Open IE using the embedded driver
    Given I open IE
    And I go to google
    Then the title is "Google"

  @4 @nofirefox @nochrome @noie
  Scenario: Open Edge using the downloaded driver
    Given I open Edge
    And I go to google
    Then the title is "Google"
