require 'uri'
require 'cgi'
require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "paths"))
require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "selectors"))
include Yard

When /^(?:|I )manually visit \"(.+)\"$/ do |page_url|
  visit page_url
end

When /^(?:|I )open the page with pretty url \"(.+)\"$/ do |pretty_url|
  page = Page.where(:pretty_url => pretty_url).first
  visit get_yard_url(page.id)
end

Then /^I should get a response with status (\d+)$/ do |status|  
  page.driver.status_code.should == status.to_i
end

# Not working with @javascript features
Then /^the page should be valid$/ do
  step "I should get a response with status 200"
  step "I should not see \"The page you were looking for doesn't exist.\""
  step "I should not see \"We're sorry, but something went wrong.\""
  step "I should not see \"You can't access this resource, sorry.\""
end

Then /^the page should be js valid$/ do
  step "I should not see \"The page you were looking for doesn't exist.\""
  step "I should not see \"We're sorry, but something went wrong.\""
  step "I should not see \"You can't access this resource, sorry.\""
end