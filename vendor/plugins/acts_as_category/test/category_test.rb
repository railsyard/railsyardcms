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

class Category < ActiveRecord::Base
  acts_as_category :foreign_key => 'my_parent_id',
                   :position => 'my_position',
                   :order_by => 'my_position',
                   :hidden => 'my_hidden',
                   :children_count => 'my_children_count',
                   :ancestors_count => 'my_ancestors_count',
                   :descendants_count => 'my_descendants_count',
                   :counts_readonly => true
end

class UnpositionedCategory < ActiveRecord::Base
  acts_as_category :foreign_key => 'my_parent_id',
                   :order_by => 'id DESC',
                   :hidden => 'my_hidden',
                   :children_count => 'my_children_count',
                   :ancestors_count => 'my_ancestors_count',
                   :descendants_count => 'my_descendants_count',
                   :counts_readonly => true
end

class CategoryTest < Test::Unit::TestCase
  
  # Test category trees:
  #
  #   n1                 n2                n3
  #    \_ n11             \_ n21
  #         \_ n111       \    \_ n211
  #                       \_ n22
  #                            \_ n221
  #
  def setup
    setup_db
    assert @n1   = Category.create! # id 1
    assert @n2   = Category.create! # id 2
    assert @n3   = Category.create! # id 3
    assert @n11  = Category.create!(:my_parent_id => @n1.id)  # id 4
    assert @n21  = Category.create!(:my_parent_id => @n2.id)  # id 5
    assert @n22  = Category.create!(:my_parent_id => @n2.id)  # id 6
    assert @n111 = Category.create!(:my_parent_id => @n11.id) # id 7
    assert @n211 = Category.create!(:my_parent_id => @n21.id) # id 8
    assert @n221 = Category.create!(:my_parent_id => @n22.id) # id 9
    assert @n1   = Category.find(1)
    assert @n2   = Category.find(2)
    assert @n3   = Category.find(3)
    assert @n11  = Category.find(4)
    assert @n21  = Category.find(5)
    assert @n22  = Category.find(6)
    assert @n111 = Category.find(7)
    assert @n211 = Category.find(8)
    assert @n221 = Category.find(9)
    Category.permissions.clear
  end

  def teardown
    teardown_db
  end
  
  def check_cache # This is a helper used by a few tests
    Category.find(:all).each { |c|
      # Note that "children_count" is a built-in Rails functionality and thus must not be tested here
      assert_equal c.ancestors.size,   c.my_ancestors_count
      assert_equal c.descendants.size, c.my_descendants_count
    }
  end
  
  def test_cache_columns
    check_cache
  end
  
  def test_permissions_class_variable
    Category.permissions = nil
    assert_equal [], Category.permissions
    Category.permissions = [nil]
    assert_equal [], Category.permissions
    Category.permissions = [0]
    assert_equal [], Category.permissions
    Category.permissions = 'string'
    assert_equal [], Category.permissions
    Category.permissions = [1]
    assert_equal [1], Category.permissions
    Category.permissions = [1,2,3]
    assert_equal [1,2,3], Category.permissions
    Category.permissions = [1,'string',3]
    assert_equal [1,3], Category.permissions
    Category.permissions.clear
    assert_equal [], Category.permissions
  end
  
  def test_attr_readonly
    assert @n1.my_children_count = 99
    assert @n1.my_ancestors_count = 99
    assert @n1.my_descendants_count = 99
    assert @n1.save
    assert @n1 = Category.find(1)
    assert_equal 1, @n1.my_children_count
    assert_equal 0, @n1.my_ancestors_count
    assert_equal 2, @n1.my_descendants_count
    assert @n1.update_attribute('my_children_count', 99)
    assert @n1.update_attribute('my_ancestors_count', 99)
    assert @n1.update_attribute('my_descendants_count', 99)
    assert @n1 = Category.find(1)
    assert_equal 1, @n1.my_children_count
    assert_equal 0, @n1.my_ancestors_count
    assert_equal 2, @n1.my_descendants_count
  end
  
  def test_get_with_id_or_list_of_ids
    assert_equal @n1, Category.get(@n1.id)
    assert_equal [@n1, @n2], Category.get(@n1.id, @n2.id)
    assert_equal [@n1, @n2], Category.get([@n1.id, @n2.id])
    assert @n1.update_attribute('my_hidden', true)
    assert_equal @n2, Category.get(@n2.id)
    assert_equal @n2, Category.get(@n1.id, @n2.id)
    assert_equal @n2, Category.get([@n1.id, @n2.id])
    assert_raise(ActiveRecord::RecordNotFound) { Category.get }
    assert_raise(ActiveRecord::RecordNotFound) { Category.get(@n1.id) }
    assert_raise(ActiveRecord::RecordNotFound) { Category.get(@n11.id) }
    assert_raise(ActiveRecord::RecordNotFound) { Category.get(@n111.id) }
    assert_equal @n2, Category.get(@n2)
    assert_equal @n3, Category.get(@n3)    
  end
  
  def test_a_little_more_complex_get
    assert @n1.update_attribute('my_hidden', true)
    assert @n21.update_attribute('my_hidden', true)
    assert_equal [@n2, @n3, @n22, @n221], Category.get(:all)
    assert_raise(ActiveRecord::RecordNotFound) { Category.get(:all, :conditions => { :my_parent_id => @n1.id }) }
    assert_equal [@n221], Category.get(:all, :conditions => { :my_parent_id => @n22.id })
    assert_equal [@n2, @n3], Category.get(:all, :conditions => { :my_parent_id => nil })
    assert_equal [@n2, @n3], Category.get(:all, :conditions => { :my_parent_id => nil })
  end
  
  def test_permitted?
    assert @n3.permitted?
    assert @n3.update_attribute('my_hidden', true)
    assert !@n3.permitted?
    Category.permissions = [@n3.id]
    assert @n3.permitted?
    Category.permissions.clear
    assert !@n3.permitted?
    assert @n3.update_attribute('my_hidden', false)
    assert @n3.permitted?
    assert @n2.permitted?
    assert @n21.permitted?
    assert @n211.permitted?
    assert @n211.update_attribute('my_hidden', true)
    assert @n2.permitted?
    assert @n21.permitted?
    assert !@n211.permitted?
    Category.permissions = [@n211.id]
    assert @n2.permitted?
    assert @n21.permitted?
    assert @n211.permitted?
    Category.permissions.clear
    Category.permissions = [99]
    assert @n2.permitted?
    assert @n21.permitted?
    assert !@n211.permitted?
    assert @n211.update_attribute('my_hidden', false)
    assert @n2.permitted?
    assert @n21.permitted?
    assert @n211.permitted?
    assert @n21.update_attribute('my_hidden', true)
    assert @n2.permitted?
    assert !@n21.permitted?
    assert !@n211.my_hidden
    assert !@n211.permitted?
    Category.permissions = [@n21.id]
    assert @n2.permitted?
    assert @n21.permitted?
    assert @n211.permitted?
    Category.permissions.clear
    assert @n2.update_attribute('my_hidden', true)
    assert @n21.update_attribute('my_hidden', false)
    assert !@n2.permitted?
    assert !@n21.permitted?
    assert !@n211.permitted?
    Category.permissions = [@n21.id, @n211.id]
    assert !@n2.permitted?
    assert !@n21.permitted?
    assert !@n211.permitted?
    Category.permissions = [@n2.id]
    assert @n2.permitted?
    assert @n21.permitted?
    assert @n211.permitted?
  end
  
  def test_children
    assert_equal [@n11], @n1.children
    assert_equal [@n21, @n22], @n2.children
    assert_equal [], @n3.children
    assert_equal [@n111], @n11.children
    assert_equal [], @n111.children
    assert_equal [@n211], @n21.children
    assert_equal [@n221], @n22.children
    assert_equal [], @n211.children
    assert_equal [], @n221.children
  end

  def test_children_with_permissions
    assert @n22.update_attribute('my_hidden', true)
    assert_equal [@n21, @n22], @n2.orig_children
    assert_equal [@n11], @n1.children
    assert_equal [@n21], @n2.children
    assert_equal [], @n3.children
    assert_equal [@n111], @n11.children
    assert_equal [], @n111.children
    assert_equal [@n211], @n21.children
    assert_equal [], @n22.children
    assert_equal [], @n211.children
    assert_equal [], @n221.children
  end
  
  def test_children_ids
    assert_equal [@n11.id], @n1.children_ids
    assert_equal [@n21.id, @n22.id], @n2.children_ids
    assert_equal [], @n3.children_ids
    assert_equal [@n111.id], @n11.children_ids
    assert_equal [], @n111.children_ids
    assert_equal [@n211.id], @n21.children_ids
    assert_equal [@n221.id], @n22.children_ids
    assert_equal [], @n211.children_ids
    assert_equal [], @n221.children_ids
  end
  
  def test_children_ids_with_permissions
    assert @n22.update_attribute('my_hidden', true)
    assert_equal [@n11.id], @n1.children_ids
    assert_equal [@n21.id], @n2.children_ids
    assert_equal [], @n3.children_ids
    assert_equal [@n111.id], @n11.children_ids
    assert_equal [], @n111.children_ids
    assert_equal [@n211.id], @n21.children_ids
    assert_equal [], @n22.children_ids
    assert_equal [], @n211.children_ids
    assert_equal [], @n221.children_ids
  end
  
   def test_children_size
     assert_equal 1, @n1.children.size
     assert_equal 2, @n2.children.size
     assert_equal 0, @n3.children.size
     assert_equal 1, @n11.children.size
     assert_equal 0, @n111.children.size
     assert_equal 1, @n21.children.size
     assert_equal 1, @n22.children.size
     assert_equal 0, @n211.children.size
     assert_equal 0, @n221.children.size
     assert @n111.update_attribute('my_hidden', true)
     assert @n22.update_attribute('my_hidden', true)
     assert_equal 1, @n1.children.size
     assert_equal 1, @n2.children.size
     assert_equal 0, @n3.children.size
     assert_equal 0, @n11.children.size
     assert_equal 0, @n111.children.size
     assert_equal 1, @n21.children.size
     assert_equal 0, @n22.children.size
     assert_equal 0, @n211.children.size
     assert_equal 0, @n221.children.size
  end
  
  def test_parent
    assert_nil @n1.parent
    assert_nil @n2.parent
    assert_nil @n3.parent
    assert_equal @n1, @n11.parent
    assert_equal @n11, @n111.parent
    assert_equal @n2, @n21.parent
    assert_equal @n2, @n22.parent
    assert_equal @n21, @n211.parent
    assert_equal @n22, @n221.parent
  end
  
  def test_ancestors
    assert_equal [], @n1.ancestors
    assert_equal [], @n2.ancestors
    assert_equal [], @n3.ancestors
    assert_equal [@n1], @n11.ancestors
    assert_equal [@n2], @n21.ancestors
    assert_equal [@n2], @n22.ancestors
    assert_equal [@n11, @n1], @n111.ancestors
    assert_equal [@n21, @n2], @n211.ancestors
    assert_equal [@n22, @n2], @n221.ancestors
  end
  
  def test_ancestors_ids
    assert_equal [], @n1.ancestors_ids
    assert_equal [], @n2.ancestors_ids
    assert_equal [], @n3.ancestors_ids
    assert_equal [@n1.id], @n11.ancestors_ids
    assert_equal [@n2.id], @n21.ancestors_ids
    assert_equal [@n2.id], @n22.ancestors_ids
    assert_equal [@n11.id, @n1.id], @n111.ancestors_ids
    assert_equal [@n21.id, @n2.id], @n211.ancestors_ids
    assert_equal [@n22.id, @n2.id], @n221.ancestors_ids
  end
  
  def test_descendants
    assert_equal [@n11, @n111], @n1.descendants
    assert_equal [@n21, @n211, @n22, @n221], @n2.descendants
    assert_equal [], @n3.descendants
    assert_equal [@n111], @n11.descendants
    assert_equal [@n211], @n21.descendants
    assert_equal [@n221], @n22.descendants
    assert_equal [], @n111.descendants
    assert_equal [], @n211.descendants
    assert_equal [], @n221.descendants
  end
  
  def test_descendants_with_permissions
    assert @n22.update_attribute('my_hidden', true)
    assert_equal [@n11, @n111], @n1.descendants
    assert_equal [@n21, @n211], @n2.descendants
    assert_equal [], @n3.descendants
    assert_equal [@n111], @n11.descendants
    assert_equal [], @n111.descendants
    assert_equal [@n211], @n21.descendants
    assert_equal [], @n22.descendants
    assert_equal [], @n211.descendants
    assert_equal [], @n221.descendants
  end
  
  def test_descendants_ids
    assert_equal [@n11.id, @n111.id], @n1.descendants_ids
    assert_equal [@n21.id, @n211.id, @n22.id, @n221.id], @n2.descendants_ids
    assert_equal [], @n3.descendants_ids
    assert_equal [@n111.id], @n11.descendants_ids
    assert_equal [@n211.id], @n21.descendants_ids
    assert_equal [@n221.id], @n22.descendants_ids
    assert_equal [@n221.id], @n22.descendants_ids
    assert_equal [@n221.id], @n22.descendants_ids
    assert_equal [], @n111.descendants_ids
    assert_equal [], @n211.descendants_ids
    assert_equal [], @n221.descendants_ids
    assert_equal [], @n221.descendants_ids
  end
  
  def test_descendants_ids_with_permissions
    assert @n22.update_attribute('my_hidden', true)
    assert_equal [@n11.id, @n111.id], @n1.descendants_ids
    assert_equal [@n21.id, @n211.id], @n2.descendants_ids
    assert_equal [], @n3.descendants_ids
    assert_equal [@n111.id], @n11.descendants_ids
    assert_equal [], @n111.descendants_ids
    assert_equal [@n211.id], @n21.descendants_ids
    assert_equal [], @n22.descendants_ids
    assert_equal [], @n211.descendants_ids
    assert_equal [], @n221.descendants_ids
  end
  
  def test_root_of_instance
    assert_equal @n1, @n1.root
    assert_equal @n1, @n11.root
    assert_equal @n1, @n111.root
    assert_equal @n2, @n21.root
    assert_equal @n2, @n211.root
    assert_equal @n2, @n22.root
    assert_equal @n2, @n221.root
    assert_equal @n3, @n3.root
  end
  
  def test_root_of_instance_with_permissions # should ignore permissions
    assert @n22.update_attribute('my_hidden', true)
    assert_equal @n2, @n2.root
    assert_equal @n2, @n22.root
    assert_equal @n2, @n221.root
  end
  
  def test_root?
    assert @n1.root?
    assert @n3.root?
    assert !@n11.root?
  end
  
  def test_root_question_for_instance_with_permissions # should ignore permissions
    assert @n3.update_attribute('my_hidden', true)
    assert @n1.root?
    assert @n3.root?
    assert !@n11.root?
  end
  
  def test_roots_and_forced_roots
    assert_equal [@n1, @n2, @n3], Category.roots
    assert_equal [@n1, @n2, @n3], Category.roots!
  end
  
  def test_roots_with_permissions
    assert @n2.update_attribute('my_hidden', true)
    assert_equal [@n1, @n3], Category.roots
  end
  
  def test_roots_forced
    assert @n2.update_attribute('my_hidden', true)
    assert_equal [@n1, @n2, @n3], Category.roots!
  end
  
  def test_siblings
    assert_equal [@n2, @n3], @n1.siblings
    assert_equal [@n1, @n3], @n2.siblings
    assert_equal [@n1, @n2], @n3.siblings
    assert_equal [], @n11.siblings
    assert_equal [@n22], @n21.siblings
    assert_equal [@n21], @n22.siblings
    assert_equal [], @n111.siblings
    assert_equal [], @n211.siblings
    assert_equal [], @n221.siblings
  end
  
  def test_siblings_permissions
    assert @n2.update_attribute('my_hidden', true)
    assert_equal [@n3], @n1.siblings
    assert_equal [@n1, @n3], @n2.siblings
    assert_equal [@n1], @n3.siblings
    assert_equal [], @n11.siblings
    assert_equal [], @n21.siblings
    assert_equal [], @n22.siblings
    assert_equal [], @n111.siblings
    assert_equal [], @n211.siblings
    assert_equal [], @n221.siblings
    assert @n22.update_attribute('my_hidden', true)
    assert_equal [], @n21.siblings
    assert_equal [], @n22.siblings
    assert_equal [], @n111.siblings
    assert_equal [], @n211.siblings
    assert_equal [], @n221.siblings
    assert @n2.update_attribute('my_hidden', false)
    assert_equal [], @n22.siblings
  end
  
  def test_self_and_siblings
    assert_equal [@n1, @n2, @n3], @n1.self_and_siblings
    assert_equal [@n1, @n2, @n3], @n2.self_and_siblings
    assert_equal [@n1, @n2, @n3], @n3.self_and_siblings
    assert_equal [@n11], @n11.self_and_siblings
    assert_equal [@n21, @n22], @n21.self_and_siblings
    assert_equal [@n21, @n22], @n22.self_and_siblings
    assert_equal [@n111], @n111.self_and_siblings
    assert_equal [@n211], @n211.self_and_siblings
    assert_equal [@n221], @n221.self_and_siblings
  end
  
  def test_self_and_siblings_permissions
    assert @n22.update_attribute('my_hidden', true)
    assert_equal [@n1, @n2, @n3], @n1.self_and_siblings
    assert_equal [@n1, @n2, @n3], @n2.self_and_siblings
    assert_equal [@n1, @n2, @n3], @n3.self_and_siblings
    assert_equal [@n11], @n11.self_and_siblings
    assert_equal [@n21], @n21.self_and_siblings
    assert_equal [@n21], @n22.self_and_siblings
    assert_equal [@n111], @n111.self_and_siblings
    assert_equal [@n211], @n211.self_and_siblings
    assert_equal [], @n221.self_and_siblings
  end
  
  def test_dependent_destroy_and_cache
    assert_equal 9, Category.count
    assert @n1.destroy
    assert_equal 6, Category.count
    check_cache
    assert @n211.destroy
    assert_equal 5, Category.count
    check_cache
    assert @n21.destroy
    assert_equal 4, Category.count
    check_cache
    assert @n22.destroy
    assert_equal 2, Category.count
    check_cache
    assert @n2.destroy
    assert @n3.destroy
    assert_equal 0, Category.count
    check_cache
  end
  
  def test_insert_and_cache
    teardown_db
    setup_db
    assert @n1 = Category.create!
    check_cache
    assert @n2 = Category.create!
    check_cache
    Category.new().save
    assert @n3 = Category.find(3)
    check_cache
    assert @n11 = Category.create!(:my_parent_id => @n1.id)
    check_cache
    Category.new(:my_parent_id => @n2.id).save
    assert @n21 = Category.find(5)
    check_cache
    assert @n22 = Category.create!(:my_parent_id => @n2.id)
    check_cache
    Category.new(:my_parent_id => @n11.id).save
    assert @n111 = Category.find(7)
    check_cache
    assert @n211 = Category.create!(:my_parent_id => @n21.id)
    check_cache
    assert @n221 = Category.create!(:my_parent_id => @n22.id)
    check_cache
    @n12 = @n1.children.create
    check_cache
    assert @n12
    assert_equal @n12.parent, @n1
    assert @n1 = Category.find(1)
    assert_equal 2, @n1.children.size
    assert @n1.children.include?(@n12)
    assert @n1.children.include?(@n11)
    check_cache
  end
  
  def test_update_where_root_becomes_child
    @n1.update_attributes(:my_parent_id => @n21.id)
    check_cache
  end
  
  def test_update_where_child_becomes_root
    @n111.update_attributes(:my_parent_id =>nil)
    check_cache
  end
  
  def test_update_where_child_switches_within_branch
    @n22.update_attributes(:my_parent_id => @n211.id)
    check_cache
  end
  
  def test_update_where_child_switches_branch
    @n221.update_attributes(:my_parent_id => @n11.id)
    check_cache
  end
  
  def test_invalid_parent_id_type
    assert !Category.new(:my_parent_id => 0.0).save
    assert !Category.new(:my_parent_id => 1.5).save
    assert !Category.new(:my_parent_id => 0).save
    assert !Category.new(:my_parent_id => 'string').save
  end
  
  def test_non_existent_foreign_key
    assert !Category.new(:my_parent_id => 9876543210).save
    assert_raise(ActiveRecord::RecordInvalid) { Category.create!(:my_parent_id => 9876543210) }
  end
  
  def test_category_becomes_its_own_parent
    assert !@n1.update_attributes(:my_parent_id => @n1.id)
    assert @n2.my_parent_id = @n2.id
    assert !@n2.save
  end
  
  def test_category_becomes_parent_of_descendant
    assert !@n1.update_attributes(:my_parent_id => @n11.id)
    assert !@n1.update_attributes(:my_parent_id => @n111.id)
    assert !@n11.update_attributes(:my_parent_id => @n111.id)
    assert @n2.my_parent_id = @n21.id
    assert !@n2.save
  end
  
  def test_update_positions # should ignore permissions, by the way
    Category.update_positions({ 'aac_sortable_tree_0' => [@n3.id, @n1.id, @n2.id] })
    assert_equal 1, Category.find(@n3.id).my_position
    assert_equal 2, Category.find(@n1.id).my_position
    assert_equal 3, Category.find(@n2.id).my_position
    Category.update_positions({ "aac_sortable_tree_#{@n2.id}" => [@n22.id, @n21.id] })
    assert_equal 1, Category.find(@n22.id).my_position
    assert_equal 2, Category.find(@n21.id).my_position
    assert_raise(::ArgumentError) { Category.update_positions({ "aac_sortable_tree_#{@n2.id}" => [@n1.id] }) }
    assert_raise(::ArgumentError) { Category.update_positions({ "aac_sortable_tree_#{@n2.id}" => [@n1.id, @n2.id, @n3.id] }) }
    assert_raise(::ArgumentError) { Category.update_positions({ "aac_sortable_tree_#{@n2.id}" => [@n21.id, @n22.id, @n111.id] }) }
    assert_raise(::ArgumentError) { Category.update_positions({ 'aac_sortable_tree_9876543210' => [1] }) }
    assert_raise(::ArgumentError) { Category.update_positions({ "aac_sortable_tree_1" => [9876543210] }) }
  end
  
  def test_roots_order
    assert_equal [@n1, @n2, @n3], Category.roots
    assert @n1.update_attribute('my_position', 2)
    assert @n2.update_attribute('my_position', 3)
    assert @n3.update_attribute('my_position', 1)
    assert_equal [@n3, @n1, @n2], Category.roots
  end
  
  def test_self_and_siblings_order
    assert_equal [@n1, @n2, @n3], Category.find(@n3.id).self_and_siblings
    assert @n1.update_attribute('my_position', 2)
    assert @n2.update_attribute('my_position', 3)
    assert @n3.update_attribute('my_position', 1)
    assert_equal [@n3, @n1, @n2], Category.find(@n3.id).self_and_siblings
  end
  
  def test_order_by_without_position_column
    teardown_db
    setup_db
    assert @n1 = UnpositionedCategory.create!
    assert @n2 = UnpositionedCategory.create!
    assert @n3 = UnpositionedCategory.create!
    assert @n11 = UnpositionedCategory.create!(:my_parent_id => @n1.id)
    assert @n12 = UnpositionedCategory.create!(:my_parent_id => @n1.id)
    assert @n13 = UnpositionedCategory.create!(:my_parent_id => @n1.id)
    assert_equal [@n3, @n2, @n1], UnpositionedCategory.roots
    assert_equal [@n13, @n12, @n11], UnpositionedCategory.find(@n1.id).children
  end
  
end