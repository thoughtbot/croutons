$:.push File.expand_path("../lib", __FILE__)

require "croutons/version"

Gem::Specification.new do |s|
  s.name = "croutons"
  s.version = Croutons::VERSION
  s.authors = ["Calle Erlandsson", "George Brocklehurst"]
  s.email = ["calle@thoughtbot.com", "george@thoughtbot.com", "hello@thoughtbot.com"]
  s.homepage = "https://github.com/thoughtbot/croutons"
  s.summary = "Easy breadcrumbs for Rails apps."
  s.license = "MIT"
  s.files = `git ls-files -z`.split("\x0")
  s.test_files = s.files.grep(%r{^(test|spec|features)/})
  s.add_dependency "rails", "~> 4.1.5"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "capybara"
end
