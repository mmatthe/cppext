Feature: Add a member function to an open class
  In order to add a member function
  As user
  I just want to type the function signature once
  And have it automatically added to the header and implementation file

  Background:
    Given I open file "myClass.h"
    And I open file "myClass.cpp"

  Scenario: Check the file contents
    When I switch to buffer "myClass.h"
    Then I should see "class myClass"

    When I switch to buffer "myClass.cpp"
    Then I should see "#include "myClass.h""
    Then I should see "// Anchor 1"

  Scenario: Add a simple member
    Given I am in buffer "myClass.cpp"

    When I place the cursor after "// Anchor 1"
    And I call addmember with "void myfunc(int a, int b)"
    Then I should see "void myClass::myfunc(int a, int b)"

    When I switch to buffer "myClass.h"
    Then I should see "void myfunc(int a, int b);"

  Scenario: Add a const member
    Given I am in buffer "myClass.cpp"
    When I place the cursor after "// Anchor 1"
    And I call addmember with "void myfunc2(int a, int b) const"
    Then I should see "void myClass::myfunc2(int a, int b) const"

    When I switch to buffer "myClass.h"
    Then I should see "void myfunc2(int a, int b) const;"
