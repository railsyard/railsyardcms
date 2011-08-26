# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "railsyard-markdown-content/version"

Gem::Specification.new do |s|
  s.name        = "railsyard-markdown-content"
  s.version     = Railsyard::Markdown::Content::VERSION
  s.authors     = ["Paul Spieker"]
  s.email       = ["p.spieker@duenos.de"]
  s.homepage    = ""
  s.summary     = %q{TODO: Write a gem summary}
  s.description = %q{TODO: Write a gem description}

  s.rubyforge_project = "railsyard-markdown-content"

  s.files         = Dir["{lib}/**/*", "{app}/**/*", "{config}/**/*"]
  #s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  #s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"
  
  s.add_runtime_dependency "lesstile"
  s.add_runtime_dependency "BlueCloth"
  s.add_runtime_dependency "coderay"
  
  s.add_development_dependency "rails", '3.0.9'
  s.add_development_dependency "cucumber"
  s.add_development_dependency "cucumber-rails"
end
