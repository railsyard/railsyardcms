require 'test_helper'

class ContentCellTest < Cell::TestCase
  test "text_widget" do
    invoke :text_widget
    assert_select "p"
  end
  

end
