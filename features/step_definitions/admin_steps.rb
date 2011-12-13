Given /^I am logged in as "([^"]*)" with password "([^"]*)"$/ do |email, password|
  step "I go to the admin page"
  step "I fill in \"user_email\" with \"#{email}\""
  step "I fill in \"user_password\" with \"#{password}\""
  step "I press \"Sign in\""
end
