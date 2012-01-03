When /^I sleep (\d+) seconds$/ do |sec|
  sleep sec.to_i
end

When /^I reload the page$/ do
  visit [ current_path, page.driver.last_request.env['QUERY_STRING'] ].reject(&:blank?).join('?')
end
