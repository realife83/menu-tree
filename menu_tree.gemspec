$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "menu_tree/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "menu_tree"
  s.version     = MenuTree::VERSION
  s.authors     = ["KunHa"]
  s.email       = ["potato9@gmail.com"]
  s.homepage    = "http://ufofactory.org"
  s.summary     = "simple DSL to manage menu tree"
  s.description = "able to set and retrive menu tree"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_development_dependency "rails", "~> 4.0.0"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "sqlite3"
end
