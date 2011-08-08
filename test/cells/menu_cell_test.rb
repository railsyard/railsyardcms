require 'test_helper'

class MenuCellTest < Cell::TestCase
  test "first_level" do
    invoke :first_level
    assert_select "p"
  end
  
  test "two_levels" do
    invoke :two_levels
    assert_select "p"
  end
  
  test "siglings" do
    invoke :siglings
    assert_select "p"
  end
  
  test "children" do
    invoke :children
    assert_select "p"
  end
  
  test "siblings_and_children" do
    invoke :siblings_and_children
    assert_select "p"
  end
  
  test "footer" do
    invoke :footer
    assert_select "p"
  end
  

end
