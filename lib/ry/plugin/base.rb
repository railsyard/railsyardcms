module Ry
  module Plugin
    # Ry::Plugin::Base is the class for registering a plugin at the Railsyard CMS. Any engine which will be
    # integrated have to add a configured instance to the plugin manager.
    #
    # Example
    # =======
    # Ry::Plugin::Manager.instance << Ry::Plugin::Base.configure(self) do
    #   root_path File.expand_path('../../../',  __FILE__)
    #   mount ::Saphira::Engine => '/admin/filemanager', :as => 'filemanager'
    #   admin_menu 'ry-filemanager/admin/menu'
    #   ability do |ability, user|
    #     # cancan abilities
    #   end
    # end
    class Base
      def self.configure(engine, &block)
        # raise "the given class is not of the type engine" unless engine.respond_to?(:call)
        mapper = Mapper.new
        mapper.instance_exec(&block)
        config = mapper.to_hash
        config[:engine] = engine
        Ry::Plugin::Base.new(config)
      end
    
      def initialize(config)
        @config = config
      end
      
      # The engine class of this plugin
      def engine
        @config[:engine]
      end
      
      # The class name of the plugins engine
      def engine_class_name
        @config[:engine].name
      end
      
      # The plugins root path
      def root_path
        @config[:root_path]
      end
      
      # The mount settings if the plugin is a mountable engine
      def mount
        @config[:mount]
      end
      
      # The file containing the menu items for the admin area if the plugin has
      # backend settings
      def admin_menu
        File.join(root_path, 'app', 'views', @config[:admin_menu]) if @config[:admin_menu]
      end
      
      # The block which defines the ability using cancan.
      #
      # Example
      # -------
      # ability do |ability, user|
      #   if user
      #      ability.can :show, Whatever
      #   end
      # end
      def ability
        @config[:ability]
      end
    end
  end
end