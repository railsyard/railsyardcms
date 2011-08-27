Factory.define :settings, :class => Setting do |setting|
  setting.site_name 'My new RailsYard site'
  setting.default_lang 'en'
  setting.site_base_url 'localhost:3000'
end