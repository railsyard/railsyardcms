module Railsyard
  module Markdown
    module Content
      class Engine < Rails::Engine
        config.to_prepare do
          # Configure the railsyard plugin
          Ry::Plugin::Manager.instance << Ry::Plugin::Base.configure(Railsyard::Markdown::Content::Engine) do
            # setting the root path of the plugin
            root_path File.expand_path('../../',  __FILE__)
          end
        end
      end
    end
  end
end