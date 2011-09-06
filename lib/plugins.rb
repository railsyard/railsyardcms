class Plugins
  class << self
    def abilities(abilities_instance, user)
      Ry::Plugin::Manager.instance.plugins.each do |plugin|
        ability = plugin.ability
        if ability
          ability.call(abilities_instance, user)
        end
      end
    end
  end
end