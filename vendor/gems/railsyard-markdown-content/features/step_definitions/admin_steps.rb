Given /^I am logged in as "([^"]*)" with password "([^"]*)"$/ do |email, password|
  Given "I go to the admin page"
  Given "I fill in \"user_email\" with \"#{email}\""
  Given "I fill in \"user_password\" with \"#{password}\""
  Given "I press \"Sign in\""
end