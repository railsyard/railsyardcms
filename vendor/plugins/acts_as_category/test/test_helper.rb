# –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
# Helper methods to test acts_as_category
#
# For more infos see http://github.com/funkensturm/acts_as_category
# –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

plugin_path = File.join File.dirname(__FILE__), '..'

require 'test/unit'
require 'rubygems'
require 'active_record'
require 'action_view'

# –––––––––––––––––––––––––––
# Virtual Database connection
# –––––––––––––––––––––––––––

ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => ":memory:")
$stdout = StringIO.new # Prevent ActiveRecord's annoying schema statements

def setup_db
  ActiveRecord::Base.logger
  ActiveRecord::Schema.define(:version => 1) do
    
    # A container for Categories
    create_table :catalogues, :force => true do |t|
    end
    
    # Regular Categories
    create_table :categories, :force => true do |t|
      t.integer :my_parent_id
      t.integer :my_position
      t.boolean :my_hidden
      t.integer :my_children_count
      t.integer :my_ancestors_count
      t.integer :my_descendants_count
    end
    
    # Categories where we don't want to keep track of positions
    create_table :unpositioned_categories, :force => true do |t|
      t.integer :my_parent_id
      t.boolean :my_hidden
      t.integer :my_children_count
      t.integer :my_ancestors_count
      t.integer :my_descendants_count
    end
    
    # Scoped Categories
    create_table :scoped_categories, :force => true do |t|
      t.integer :catalogue_id
      t.integer :my_parent_id
      t.integer :my_position
      t.boolean :my_hidden
      t.integer :my_children_count
      t.integer :my_ancestors_count
      t.integer :my_descendants_count
    end
    
  end
end

def teardown_db
  ActiveRecord::Base.connection.tables.each do |table|
    ActiveRecord::Base.connection.drop_table(table)
  end
end

setup_db # Because the plugin needs an existing table before initialization (e.g. for attr_readonly)

# –––––––––––––––––––
# Loading source code
# –––––––––––––––––––

$:.unshift File.join plugin_path, 'lib' # make "lib" known to "require"
require 'active_record/acts/category'
require 'active_record/acts/category_content'
require 'acts_as_category_helper'
require File.join plugin_path, 'init' # Initialize Plugin
