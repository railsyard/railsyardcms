When /^I click the javascript link "([^"]*)"$/ do |selector|
  # Need to execute the script through "testScriptExecution" helper method,
  # otherwise the browser is hanging up, don't know why. The error seems to
  # be in the "modules/utils.js" of selenium at line 9162
  page.evaluate_script("testScriptExecution(\"jQuery('#{selector}').click();\")")
end

When /^I wait until all Ajax requests are complete$/ do
  wait_until do
    page.evaluate_script('$.active') == 0
  end
end

When /^I drag "([^"]*)" to "([^"]*)"$/ do |snip, target|
  # FIXME: use jquery.simulate.js to really simulate dragging
  # page.evaluate_script("testDragTo('#{snippet}', '#{target}');")
  
  snip_tag = find(snip).find(:xpath,".//../../..")
  snip_handler = snip_tag[:id]
  target_tag = find(target)
  target_id = target_tag[:id]
  json = { target_id => [snip_handler].join(',') }.to_json
  page.evaluate_script("adminSendSnippetOrder(#{json});")
end