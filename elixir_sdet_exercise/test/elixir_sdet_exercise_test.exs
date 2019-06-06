defmodule ElixirSdetExerciseTest do
  # Import helpers
  use Hound.Helpers
  use ExUnit.Case

#Todo -
#Add a function to write test results to file. include test name, condition, and reason as arguments. Write to file named with the datetime. 

#In the interest of demonstrating technique, rather than comprehensive coverage, for this practice I created 4 tests. 
#The first merely loads facebook, confirms that the page title is correct, and takes  a screenshot on failure. 
#The Second will Fill out the form, leaving the first name blank, and confirm that the popup appears asking for the first name, and confirming we are still on the home page. 
#The third checks two different phone numbers, one to short and one to long, and confirms that the correct popup appears. 
#The fourth is the extra credit, which validates that a new page is opened after x number of attempts. 







  # Start hound session and destroy when tests are run
  hound_session()

  test "Page Load" do
    var_pass = false
    #Open up facebook and confirm we have arrived
    navigate_to "https://www.facebook.com/"
    var_pass = if page_title() == "Facebook - Log In or Sign Up" do
      true
    else
      take_screenshot()
    end
    assert var_pass == true
  end

  test "FailFormSubmission" do
    var_pass = false
    #Open up facebook and confirm we have arrived
    navigate_to "https://www.facebook.com/"
    assert page_title() == "Facebook - Log In or Sign Up"

    #Negative Testing account creation
    #Now we will test to ensure that each required field is being enforced
    #Starting with the first name, and then as time permits going on to other fields.
    #Locate necessary elements
    el_LastName = find_element(:name, "lastname")
    el_MobileNumber = find_element(:name, "reg_email__")
    el_Password = find_element(:id, "u_0_q")
    el_SignUp = find_element(:name, "websubmit")

    #First, leave the first name blank, fill out the rest
    fill_field(el_LastName, "TestLast")
    fill_field(el_MobileNumber, "8018118234")
    fill_field(el_Password, "1TotallySecureP@ssword")
    click(el_SignUp)
    
    #check to see if we are still on the homepage. 
    var_pass = if page_title() == "Facebook - Log In or Sign Up" do
      true
    else
      take_screenshot()
    end
    #Now check to see if the "What's your name" error is appearing
    var_pass = if search_element(:class, "_53io", 5) do
      true
    else
      take_screenshot()
    end
    assert var_pass == true
  end

  test "Invalid Phone Number Submission" do
   var_pass = false
   navigate_to "https://www.facebook.com/"
   assert page_title() == "Facebook - Log In or Sign Up"

   #Here I want to ensure that only valid phone numbers are being accepted
   el_FirstName = find_element(:name, "firstname")
   el_LastName = find_element(:name, "lastname")
   el_MobileNumber = find_element(:name, "reg_email__")
   el_SignUp = find_element(:name, "websubmit")


   #I fill the first two fields, so that the error message will appear for the phone number.
   fill_field(el_FirstName, "TestFirst")
   fill_field(el_LastName, "TestLast")
   fill_field(el_MobileNumber, "123")

   click(el_SignUp)
   #check to see if we are still on the homepage. 
   var_pass = if page_title() == "Facebook - Log In or Sign Up" do
      true
    else
      take_screenshot()
    end
    #Check to see if the "You'll use this when you log in" error is present
   var_pass = if search_element(:class, "_53io", 5) do
      true
    else
      take_screenshot()
    end

   fill_field(el_MobileNumber, "")
   click(el_SignUp)
   assert page_title() == "Facebook - Log In or Sign Up"

   fill_field(el_MobileNumber, "42398205983409823409842309823409823490823908")
   click(el_SignUp)
   var_pass = if page_title() == "Facebook - Log In or Sign Up" do
      true
    else
      take_screenshot()
    end
    assert var_pass == true
  end

  #Check to see if x number of failed logins will cause a new screen to appear
  test "Failed Login Screen" do
    var_pass = false
    navigate_to "https://www.facebook.com/"
    el_email = find_element(:id, "email")
    el_pass = find_element(:name, "pass")
    el_login = find_element(:id, "loginbutton")
    #When i was testing, a single failed login would take you to antther page. However, in order to allow x number of times, below is the variable used. 
    #this can be adjusted to x amount of attempts.
    var_NumLogins = 1


    defmodule FillForm do
      el_email = find_element(:id, "email")
      el_pass = find_element(:name, "pass")
      el_login = find_element(:id, "loginbutton")

      def fill(n) when n <= 1 do
        el_email = find_element(:id, "email")
        el_pass = find_element(:name, "pass")
        el_login = find_element(:id, "loginbutton")
        fill_field(el_email, "8018362820")
        fill_field(el_pass, "testpassword")
        click(el_login)
      end

      def fill(n) do
        el_email = find_element(:id, "email")
        el_pass = find_element(:name, "pass")
        el_login = find_element(:id, "loginbutton")
        fill_field(el_email, "asdfdsTestEmail")
        fill_field(el_pass, "testpassword")
        click(el_login)
        var_num = n-1
        fill(var_num)
      end
    end
    FillForm.fill(var_NumLogins)
    Process.sleep(2000)
    #Confirm that the recover your account element is visible(not visible on original page)  
    var_pass = if search_element(:id, "login_link", 5) do
      true
      #take_screenshot()
    else
      take_screenshot()
    end

    assert var_pass == true
  end
  



end
