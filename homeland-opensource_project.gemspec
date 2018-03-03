$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "homeland/opensource_project/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "homeland-opensource_project"
  s.version     = Homeland::OpensourceProject::VERSION
  s.authors     = ["lihua zhang"]
  s.email       = ["lihuazhang@hotmail.com"]
  s.homepage    = "https://testerhome.com"
  s.summary     = "Summary of Homeland::OpensourceProject."
  s.description = "Description of Homeland::OpensourceProject."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5"

end
