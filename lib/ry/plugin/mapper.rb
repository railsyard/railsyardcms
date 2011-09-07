module Ry
  module Plugin
    class Mapper
      def initialize()
        @config = {}
      end
      
      def root_path(path)
        @config[:root_path] = path
      end

      def mount(options)
        @config[:mount] = options
      end

      def admin_menu(file)
        @config[:admin_menu] = file
      end

      def ability(&block)
        @config[:ability] = block
      end
      
      def to_hash
        @config
      end
    end
  end
end