# coding:utf-8

module ActiveRecord
  module Acts
    module Category
      
      # –––––––––––
      # Constructor
      # –––––––––––
      
      # This constructor is evoked when this module is included into <tt>ActiveRecord::Base</tt> by
      # <tt>vendor/plugins/acts_as_category/init.rb</tt>. That is, every time your Rails application is loaded
      #
      def self.included(base)
        # Add ClassMethods module of Acts::Category (see below) to the super-class <tt>ActiveRecord::Base</tt>.
        # Note that the ClassMethods module will add the InstanceMethods, respectively.
        #
        base.extend ClassMethods
      end

      # –––––––––––––––––––
      # ClassMethods module
      # –––––––––––––––––––
      
      module ClassMethods
        # Please refer to README for more information about this plugin.
        #
        #  create_table "categories", :force => true do |t|
        #    t.integer "parent_id"
        #    t.integer "position"
        #    t.boolean "hidden"
        #    t.integer "children_count"
        #    t.integer "ancestors_count"
        #    t.integer "descendants_count"
        #  end
        #
        # Configuration options are:
        #
        # * <tt>foreign_key</tt> - specifies the column name to use for tracking of the tree. Default is <tt>parent_id</tt>.
        # * <tt>position</tt> - specifies the integer column name to use for manually ordering siblings (if the column can't be found, this feature is disabled!). Default is <tt>position</tt>.
        # * <tt>order_by</tt> - specifies an arbitrary column to use for ordering categories. Default is <tt>position</tt>.
        # * <tt>hidden</tt> - specifies a column name to use for hidden (i.e. private) flag. It can be NULL or 0. Default is <tt>hidden</tt>.
        # * <tt>children_count</tt> - specifies a column name used for caching number of children. Default is <tt>children_count</tt>.
        # * <tt>ancestors_count</tt> - specifies a column name used for caching number of ancestors. Default is <tt>ancestors_count</tt>.
        # * <tt>descendants_count</tt> - specifies a column name used for caching number of descendants. Default is <tt>descendants_count</tt>.
        # * <tt>counts_readonly</tt> - will assign <tt>attr_readonly</tt> to the fields <tt>ancestors_count</tt> and <tt>descendants_count</tt>. This is experimental, thus default is <tt>false</tt>.
        def acts_as_category(params = {})
        
          # Load default options whenever acts_as_category is called.
          # After that, overwrite them with the individual settings passed by <tt>params</tt>.
          options = { :foreign_key => 'parent_id', :position => 'position', :order_by => 'position', :hidden => 'hidden', :scope => '1 = 1', :children_count => 'children_count', :ancestors_count => 'ancestors_count', :descendants_count => 'descendants_count', :counts_readonly => false }
          options.update(params) if params.is_a?(Hash)
          
          # Create a class association to itself.
          # Note that subcategories will be destroyed whenever a parent is deleted.
          belongs_to :parent, :class_name => name, :foreign_key => options[:foreign_key], :counter_cache => options[:children_count]
          has_many :children, :class_name => name, :foreign_key => options[:foreign_key], :order => options[:order_by], :dependent => :destroy

          # Substantial validations
          before_validation           :validate_foreign_key
          before_validation_on_create :assign_position
          validates_numericality_of   options[:foreign_key], :only_integer => true, :greater_than => 0, :allow_nil => true, :message => I18n.t('acts_as_category.error.no_descendants')

          # Callbacks for automatic refresh of ancestors_count & descendants_count cache columns
          after_create   :refresh_cache_after_create
          before_update  :prepare_refresh_before_update
          after_update   :refresh_cache_after_update
          before_destroy :prepare_refresh_before_destroy
          after_destroy  :refresh_cache_after_destroy

          # Assign readonly attribute to "self-made" cache columns
          # Note that <tt>children_count</tt> is automatically readonly
          # EXPERIMENTAL NOTICE: This caused bugs for some people, so it's optional.
          if options[:counts_readonly]
            attr_readonly options[:ancestors_count]   if column_names.include? options[:ancestors_count]
            attr_readonly options[:descendants_count] if column_names.include? options[:descendants_count]
          end
          
          # Define class variables
          class_variable_set :@@permissions, []
          
          # Generate instance method for scope condition
          # Note that it is assumed that each tree (i.e. from root to all descending leafs) is within the same scope anyway!
          # That means, that the children method doesn't need to look for any scope.
          # The siblings method must only check for a scope, if the node is the root of a tree.
          if options[:scope].is_a?(Symbol)
            options[:scope] = "#{options[:scope]}_id".intern if options[:scope].to_s !~ /_id$/
            scope_condition_method = %(
              def scope_condition
                if #{options[:scope].to_s}.nil?
                  "#{options[:scope].to_s} IS NULL"
                else
                  "#{options[:scope].to_s} = \#{#{options[:scope].to_s}}"
                end
              end
            )
          else
            scope_condition_method = "def scope_condition() %Q{#{options[:scope]}} end"
          end
          
          # –––––––––––––
          # Class methods
          # –––––––––––––

          # Returns an +array+ with +ids+ of categories, which are to be allowed to be seen,
          # though they might be flagged with the +hidden+ attribute. Returns an empty +array+ if none.
          # The idea is, to define a class variable array +permissions+ each time the user logs in
          # (which is job of the controller, in case you would like to use this functionality).
          def self.permissions
            class_variable_get :@@permissions
          end
          
          # Takes an +array+ of +ids+ of categories and defines them to be permitted.
          # Don't forget that this overwrites the array with each call, instead of adding further ids to it.
          def self.permissions=(ids)
            permissions = []
            ids.each { |id| permissions << id.to_i if id.to_i > 0 } if ids.is_a?(Array)
            class_variable_set :@@permissions, permissions.uniq
          end
          
          # This class_eval contains methods which cannot be added wihtout having a concrete model.
          # Say, we want these methods to use parameters like "options[:foreign_key]", but we
          # don't have these parameters, unless somebody evokes the acts_as_category method in his
          # model. So we use class_eval, which generates methods, whenever acts_as_category is called,
          # and not already when our plugin's init.rb adds our Acts::Category modules to ActiveRecord::Base.
          # Another reason is, that we want to overwrite the association method <tt>children</tt>, but this
          # association doesn't exist before acts_as_category is actually called. So we need class_eval.
          
          class_eval <<-END
          
            # –––––––––––––––––––––––
            # Generated class methods
            # –––––––––––––––––––––––
            
            # Define instance getter methods to keep track of the column names
            def self.parent_id_column()         %Q{#{options[:foreign_key]}}       end
            def self.position_column()          %Q{#{options[:position]}}          end
            def self.order_by()                 %Q{#{options[:order_by]}}          end
            def self.hidden_column()            %Q{#{options[:hidden]}}            end
            def self.children_count_column()    %Q{#{options[:children_count]}}    end
            def self.ancestors_count_column()   %Q{#{options[:ancestors_count]}}   end
            def self.descendants_count_column() %Q{#{options[:descendants_count]}} end
                
            # Update cache columns of a whole branch, which includes the given +category+ or its +id+.
            #
            def self.refresh_cache_of_branch_with(category)
              category = find(category) unless category.instance_of?(self)               # possibly convert id into category
              root = category.#{options[:foreign_key]}.nil? ? category : category.root   # find root of category (if not already)
              root.refresh_cache
              root.descendants.each { |d| d.refresh_cache }
            end
            
            # Receives the controller's +params+ variable and updates category positions accordingly.
            # Please refer to the helper methods that came with this model for further information.
            #
            def self.update_positions(params)
              params.each_key { |key|
                if key.include?('aac_sortable_tree_')
                  parent_id = key.split('_').last.to_i
                  params[key].each_with_index { |id, position|
                    category = find(id)
                    # Verify that every category is valid and from the correct parent
                    raise ArgumentError, 'Invalid attempt to update a category position: Cannot update a category (ID '+category.id.to_s+') out of given parent_id (ID '+parent_id.to_s+')' unless category.#{options[:foreign_key]}.nil? && parent_id == 0 || parent_id > 0 && category.#{options[:foreign_key]} == parent_id
                    @counter = position + 1
                  }
                  self_and_siblings_count = parent_id <= 0 ? roots.size : find(parent_id).children.count
                  # Verify that the parameters correspond to every child of this parent
                  raise ArgumentError, 'Invalid attempt to update a category position: Number of category IDs in param hash is wrong ('+@counter.to_s+' instead of '+self_and_siblings_count.to_s+' for parent with ID '+parent_id.to_s+')' unless @counter == self_and_siblings_count
                  # Do the actual position update
                  params[key].each_with_index { |id, position| find(id).update_attribute('#{options[:position]}', position + 1)}
                  end
              }
              rescue ActiveRecord::RecordNotFound
              raise ArgumentError, 'Invalid attempt to update a category position: Parent category does not exist'
            end

            # Updating all category positions into correct 1, 2, 3 etc. per hierachy level
            #
            def self.refresh_positions(categories = nil)
              categories = roots if categories.blank?
              categories = [categories] unless categories.is_a? Array
              categories.each_with_index { |category, position|
                category.update_attribute('#{options[:position]}', position + 1)
                refresh_positions(category.children) unless category.children.empty?
              }
            end
            
            # ––––––––––––––––––––––––––
            # Generated instance methods
            # ––––––––––––––––––––––––––
            
            # This will actually include the InstanceMethods to your model
            include ActiveRecord::Acts::Category::InstanceMethods

            # Generating the scope_condition instance method
            #{scope_condition_method}

            # Overwrite the children association method, so that it will respect permitted/hidden categories
            # Note: If you request the children of a not-permitted category, the result will be an empty array
            #
            alias :orig_children :children
            def children
              result = orig_children
              result.delete_if { |child| !child.permitted? }
              result
            end
            
          END
          
          # Scope out via given scope conditions for the instance
          named_scope :manual_scope, lambda { |sender| { :conditions => sender.scope_condition, :order => order_by } }
          
          # Scope for permitted categories
          # Does *NOT* respect inherited permissions! 
          # This is intended to be used with roots only
          named_scope :permitted, lambda {
            if permissions.empty?
              { :conditions => ["#{hidden_column} IS NULL OR #{hidden_column} = ? ",false], :order => order_by }
            else
              { :conditions => ["#{hidden_column} IS NULL OR #{hidden_column} = ? OR id IN (?)", false, class_variable_get(:@@permissions)], :order => order_by }
            end
          }

          # Returns all root +categories+, disregarding permissions
          named_scope :roots!, lambda { { :conditions => { parent_id_column => nil }, :order => order_by } }

          # Returns all root +categories+, respecting permitted/hidden ones
          def self.roots
            roots!.permitted
          end
          
          # Deletes all prohibited categories from a find()-resultset
          def self.get(*args)
            case args.first
              # I don't want to explain it now, but :first and :last are really hard to implement with inherited permissions :)
              when :first then raise 'Sorry, :first and :last are not supported currently.'
              when :last  then raise 'Sorry, :first and :last are not supported currently.'
              else result = find(*args)
            end
            return nil if result.nil?
            result = [result] unless result.is_a?(Array)
            result.delete_if { |category| !category.permitted? }
            return result.first if result.size == 1 and args.first != :all
            raise ActiveRecord::RecordNotFound if result.empty?
            result
          end
          
        end
      end

      ##########################
      # InstanceMethods module #
      ##########################
      
      module InstanceMethods
        
        ####################
        # Instance methods #
        ####################
        

        # These are just shortcuts to keep track of the class wide variables
        def permissions()              self.class.permissions              end
        def order_by()                 self.class.order_by                 end
        # And column names defined in the class
        def parent_id_column()         self.class.parent_id_column         end
        def position_column()          self.class.position_column          end
        def hidden_column()            self.class.hidden_column            end
        def children_count_column()    self.class.children_count_column    end
        def ancestors_count_column()   self.class.ancestors_count_column   end
        def descendants_count_column() self.class.descendants_count_column end

        # Returns +true+ if category is visible/permitted, otherwise +false+.
        def permitted?
          return false if self.class.find(self.id).read_attribute(hidden_column) and !self.class.permissions.include?(self.id)          
          node = self
          while node.parent do
            node = node.parent
            return false if self.class.find(node.id).read_attribute(hidden_column) and !self.class.permissions.include?(node.id)
          end
          true
        end

        # Returns +array+ of children's ids, respecting permitted/hidden categories
        def children_ids
          children_ids = []
          self.children.each { |child| children_ids << child.id if child.permitted? } unless self.children.empty?
          children_ids
        end

        # Returns list of ancestors, disregarding any permissions
        def ancestors
          node, nodes = self, []
          nodes << node = node.parent while node.parent
          nodes
        end

        # Returns array of IDs of ancestors, disregarding any permissions
        def ancestors_ids
          node, nodes = self, []
          while node.parent
            node = node.parent
            nodes << node.id
          end
          nodes
        end

        # Returns list of descendants, respecting permitted/hidden categories
        def descendants
          descendants = []
          self.children.each { |child|
            descendants += [child] if child.permitted?
            descendants += child.descendants
          } unless self.children.empty?
          descendants 
        end

        # Returns array of IDs of descendants, respecting permitted/hidden categories
        def descendants_ids(ignore_permissions = false)
          descendants_ids = [] 
          self.children.each { |child|
            descendants_ids += [child.id] if ignore_permissions or child.permitted?
            descendants_ids += child.descendants_ids
          } unless self.children.empty?
          descendants_ids
        end
        
        # Returns the root node of the branch, disregarding any permissions
        # This is okay, since you should never have had access to this category if the root was hidden
        def root
          node = self
          node = node.parent while node.parent
          node
        end
        
        # Returns +true+ if category is root, otherwise +false+, disregarding any permissions
        def root?
          self.parent ? false : true
        end

        # Returns all siblings of the current node, respecting permitted/hidden categories
        def siblings
          result = self_and_siblings - [self]
          result.delete_if { |sibling| !sibling.permitted? }
          result
        end

        # Returns all siblings and a reference to the current node, respecting permitted/hidden categories
        def self_and_siblings
          parent ? parent.children : self.class.roots.manual_scope(self)
        end

        # Returns all ids of siblings and a reference to the current node, respecting permitted/hidden categories
        def self_and_siblings_ids
          parent ? parent.children_ids : self.class.roots.manual_scope(self).map {|x| x.id}
        end
        
        # Immediately refresh cache of category instance
        def refresh_cache
          self.class.connection.execute "UPDATE #{self.class.table_name} SET #{ancestors_count_column}=#{self.ancestors.size},  #{descendants_count_column}=#{self.descendants.size} WHERE id=#{self.id}"
        end
        
        ############################
        # Private instance methods #
        ############################

        private
        
        # Validator for parent_id association after creation and update of a category
        def validate_foreign_key
          # If there is a parent_id given
          unless self.read_attribute(parent_id_column).nil?
            # Parent_id must be a valid category ID
            self.write_attribute(parent_id_column, 0) if self.read_attribute(parent_id_column) > 0 && !self.class.find(self.read_attribute(parent_id_column))
            # Parent must not be itself
            self.write_attribute(parent_id_column, 0) if self.read_attribute(parent_id_column) > 0 && self.id == self.read_attribute(parent_id_column) unless self.id.blank?
            # Parent must not be a descendant of itself
            self.write_attribute(parent_id_column, 0) if self.read_attribute(parent_id_column) > 0 && self.descendants_ids(true).include?(self.read_attribute(parent_id_column))
          end
          rescue ActiveRecord::RecordNotFound
          self.write_attribute(parent_id_column, 0) # Parent was not found
        end
        
        # Assigns a position integer after creation of a category
        def assign_position
          # Position for new nodes is (number of siblings + 1), but only for new categories
          if self.read_attribute(parent_id_column).nil?
            self.write_attribute(position_column, self.class.roots!.size + 1)
          else
            self.write_attribute(position_column, self.class.find(:all, :conditions => ["#{parent_id_column} = ?", self.read_attribute(parent_id_column)]).size + 1)
          end
        end
        
        # Refresh cache of branch of created category instance
        def refresh_cache_after_create
          self.class.refresh_cache_of_branch_with(self.root)
        end
        
        # Gather parent_id before any manipulation
        def prepare_refresh_before_update
          @parent_id_before = self.class.find(self.id).read_attribute(parent_id_column)
        end
        
        # A category has been manipulated, refresh cache columns
        def refresh_cache_after_update
          # Parent didn't change, do nothing with cache
          return if @parent_id_before == self.read_attribute(parent_id_column)
          # If a subcategory has come from another branch, refresh that tree
          self.class.refresh_cache_of_branch_with(@parent_id_before) unless @parent_id_before.nil? || @parent_id_before == self.root.id
          # Refresh current branch in any case
          self.class.refresh_cache_of_branch_with(self.root)
          # Refresh all positions
          self.class.refresh_positions if self.class.column_names.include? position_column
        end
        
        # Gather root.id before destruction
        def prepare_refresh_before_destroy
          @root_id_before = self.root.id
        end
        
        # Refresh cache of branch, where category has been destroyed, unless it was a root
        def refresh_cache_after_destroy
          self.class.refresh_cache_of_branch_with(@root_id_before) if self.class.find(@root_id_before)
          rescue ActiveRecord::RecordNotFound
        end
        
      end
    end
  end
end
