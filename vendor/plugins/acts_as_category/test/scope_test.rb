# –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
# Test for acts_as_category
#
#  There are several ways to execute this test:
#  
#  1. Open this file on a Mac in TextMate and press  ⌘R
#  2. Go to "vendor/plugins/acts_as_category/test" and run "rake test" in a terminal window
#  3. Run "rake test:plugins" in a terminal window to execute tests of all plugins
#  
#  For more infos see http://github.com/funkensturm/acts_as_category
# –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

# Loading database and libraries
require File.join File.dirname(__FILE__), 'test_helper'

# –––––––––––––––
# Defining Models
# –––––––––––––––

class Catalogue < ActiveRecord::Base
  has_many :scoped_categories
end

class ScopedCategory < ActiveRecord::Base
  belongs_to :catalogue
  acts_as_category :foreign_key => 'my_parent_id',
                   :position => 'my_position',
                   :hidden => 'my_hidden',
                   :scope => :catalogue,
                   :children_count => 'my_children_count',
                   :ancestors_count => 'my_ancestors_count',
                   :descendants_count => 'my_descendants_count',
                   :counts_readonly => true
end

class ScopedCategoryTest < Test::Unit::TestCase
  
  # Test category trees with scopes:
  #
  #  |––––––––––––––– Catalogue @c1 –––––––––––––––|––––––––––––––– Catalogue @c2 –––––––––––––––|–– Without catalogue ––|
  # 
  #    c1n1               c1n2              c1n3     c2n1               c2n2              c2n3      r1               r2
  #     \_ c1n11           \_ c1n21                   \_ c2n11           \_ c2n21                    \_ r11
  #          \_ c1n111     \    \_ c1n211                  \_ c2n111     \    \_ c2n211                   \_ r111
  #                        \_ c1n22                                      \_ c2n22
  #                             \_ c1n221                                     \_ c2n221
  #
  def setup
    setup_db
    # Without a defined cope
    assert @n1   = ScopedCategory.create! # id 1
    assert @n2   = ScopedCategory.create! # id 2
    assert @n11  = ScopedCategory.create!(:my_parent_id => @n1.id)  # id 3
    assert @n111 = ScopedCategory.create!(:my_parent_id => @n11.id) # id 4
    assert @n1   = ScopedCategory.find(1)
    assert @n2   = ScopedCategory.find(2)
    assert @n11  = ScopedCategory.find(3)
    assert @n111 = ScopedCategory.find(4)
    # Catalogue c1 via association
    assert @c1     = Catalogue.create!       # id 1
    assert @c1n1   = @c1.scoped_categories.create! # id 5
    assert @c1n2   = @c1.scoped_categories.create! # id 6
    assert @c1n3   = @c1.scoped_categories.create! # id 7
    assert @c1n11  = @c1n1.children.create!  # id 8
    assert @c1n21  = @c1n2.children.create!  # id 9
    assert @c1n22  = @c1n2.children.create!  # id 10
    assert @c1n111 = @c1n11.children.create! # id 11
    assert @c1n211 = @c1n21.children.create! # id 12
    assert @c1n221 = @c1n22.children.create! # id 13
    assert @c1n1   = ScopedCategory.find(5)
    assert @c1n2   = ScopedCategory.find(6)
    assert @c1n3   = ScopedCategory.find(7)
    assert @c1n11  = ScopedCategory.find(8)
    assert @c1n21  = ScopedCategory.find(9)
    assert @c1n22  = ScopedCategory.find(10)
    assert @c1n111 = ScopedCategory.find(11)
    assert @c1n211 = ScopedCategory.find(12)
    assert @c1n221 = ScopedCategory.find(13)
    # Catalogue c2 via scope parameter
    assert @c2     = Catalogue.create!      # id 2
    assert @c2n1   = ScopedCategory.create!(:catalogue_id => @c2.id) # id 14
    assert @c2n2   = ScopedCategory.create!(:catalogue_id => @c2.id) # id 15
    assert @c2n3   = ScopedCategory.create!(:catalogue_id => @c2.id) # id 16
    assert @c2n11  = ScopedCategory.create!(:catalogue_id => @c2.id, :my_parent_id => @c2n1.id)  # id 17
    assert @c2n21  = ScopedCategory.create!(:catalogue_id => @c2.id, :my_parent_id => @c2n2.id)  # id 18
    assert @c2n22  = ScopedCategory.create!(:catalogue_id => @c2.id, :my_parent_id => @c2n2.id)  # id 19
    assert @c2n111 = ScopedCategory.create!(:catalogue_id => @c2.id, :my_parent_id => @c2n11.id) # id 20
    assert @c2n211 = ScopedCategory.create!(:catalogue_id => @c2.id, :my_parent_id => @c2n21.id) # id 21
    assert @c2n221 = ScopedCategory.create!(:catalogue_id => @c2.id, :my_parent_id => @c2n22.id) # id 22
    assert @c2n1   = ScopedCategory.find(14)
    assert @c2n2   = ScopedCategory.find(15)
    assert @c2n3   = ScopedCategory.find(16)
    assert @c2n11  = ScopedCategory.find(17)
    assert @c2n21  = ScopedCategory.find(18)
    assert @c2n22  = ScopedCategory.find(19)
    assert @c2n111 = ScopedCategory.find(20)
    assert @c2n211 = ScopedCategory.find(21)
    assert @c2n221 = ScopedCategory.find(22)
    ScopedCategory.permissions.clear
  end

  def teardown
    teardown_db
  end
  
  def check_cache # This is merely a method used by certain tests
    ScopedCategory.find(:all).each { |c|
      # Note that "children_count" is a built-in Rails functionality and must not be tested here
      assert_equal c.ancestors.size,   c.my_ancestors_count
      assert_equal c.descendants.size, c.my_descendants_count
    }
  end
  
  def test_cache_columns
    check_cache
  end
  
  def test_siblings_of_roots
    assert_equal [@c1n2, @c1n3], @c1n1.siblings
    assert_equal [@c2n2, @c2n3], @c2n1.siblings
    assert_equal [@n2], @n1.siblings
    assert_equal [@c1n1, @c1n2, @c1n3], @c1n3.self_and_siblings
    assert_equal [@c2n1, @c2n2, @c2n3], @c2n2.self_and_siblings
    assert_equal [@n1, @n2], @n1.self_and_siblings
  end
  
  def test_roots_and_forced_roots_within_association
    assert_equal [@c1n1, @c1n2, @c1n3], @c1.scoped_categories.roots
    assert_equal [@c2n1, @c2n2, @c2n3], @c2.scoped_categories.roots
    assert_equal [@c1n1, @c1n2, @c1n3], @c1.scoped_categories.roots!
    assert_equal [@c2n1, @c2n2, @c2n3], @c2.scoped_categories.roots!
  end
  
  def test_roots_within_association_and_permissions
    assert @c1n2.update_attribute 'my_hidden', true
    assert_equal [@c1n1, @c1n3], @c1.scoped_categories.roots
  end
  
  def test_forced_roots_via_association_and_permissions
    assert @c1n2.update_attribute 'my_hidden', true
    assert_equal [@c1n1, @c1n2, @c1n3], @c1.scoped_categories.roots!
  end
  
end
