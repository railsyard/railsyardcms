module Ry
  module Plugin
    # Plugins can be registered at the plugin manager to be available in Railsyard CMS
    #
    # Example
    # =======
    # Ry::Plugin::Manager.instance << Plugin.configure do
    #   ...
    # end
    class Manager
      include Singleton

      def initialize
        @plugins = {}
        @plugin_list = []
      end

      # add a plugin to the manager
      def <<(plugin)
        raise "The class is not of the type Ry::Plugin" unless plugin.is_a?(Ry::Plugin::Base)
        @plugins[plugin.engine_class_name.to_sym] = plugin
        update_plugins
      end
      
      # Returning a list of all plugins
      def plugins
        @plugin_list
      end
      
      protected
      
      # Update all RY settings for the current plugin list
      def update_plugins
        @plugin_list = @plugins.to_a.map { |i| i[1] }
        cell_view_paths = [File.join(Rails.root.to_s, 'app', 'cells')]
        cell_view_paths = cell_view_paths + plugins.map { |plugin| File.join(plugin.root_path, 'app', 'cells') }
        Cell::Rails.view_paths = cell_view_paths
      end
    end
  end
end