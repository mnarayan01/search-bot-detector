# Maintain your gem's version:
require File.expand_path("../lib/search-bot-detector/version", __FILE__)

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "search-bot-detector"
  s.version     = SearchBotDetector::VERSION
  s.authors     = ["Michael Narayan"]
  s.email       = ["mnarayan01@gmail.com"]
  s.homepage    = "https://github.com/mnarayan01/search-bot-detector"
  s.summary     = "Detect and verify select search bots."
  s.description = "Detect and verify select (i.e. Google and Yandex) search bots."

  s.files = Dir["lib/**/*"] + ["LICENSE", "README.md"]

  s.add_development_dependency "bundler"
  s.add_development_dependency "rake"
end
