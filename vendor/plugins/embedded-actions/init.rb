require 'embedded_actions/detect_rescue_action'
require 'embedded_actions/embed_action'
require 'embedded_actions/caches_embedded'
require 'embedded_actions/default_embedded_options'

class ActionController::Base
  include ::ActionController::EmbeddedActions
  include ::ActionController::CachesEmbedded
  include ::ActionController::DefaultEmbeddedOptions
end

Mime::Type.register "application/x-embedded_action", :embedded
