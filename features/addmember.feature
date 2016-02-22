Feature: Add a member function to an open class
  In order to add a member function
  As user
  I just want to type the function signature once
  And have it automatically added to the header and implementation file

  bxScenario: Open a file and check its content - Bootstrap
    Given I open file "myClass.cpp"
    Then I should see "#include \"myClass.h\""
    And I should see "// Anchor 1"


  Scenario: Add a simple member
    Given I open file "myClass.h"
    And I open file "myClass.cpp"
    And I am in buffer "myClass.cpp"

    When I place the cursor after "// Anchor 1"
    And I start an action chain
    And I call "cppext/addmember"
    And I type "void myfunc(int a, int b)"
    And I execute the action chain

    Then I should see "void myClass::myfunc(int a, int b)"
