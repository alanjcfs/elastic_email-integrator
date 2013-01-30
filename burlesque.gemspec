# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'burlesque/version'

Gem::Specification.new do |gem|
  gem.name          = "burlesque"
  gem.version       = Burlesque::VERSION
  gem.authors       = ["Alan Schwarz"]
  gem.email         = ["alan.jcfs@gmail.com"]
  gem.description   = %q{A Contact List Management Wrapper for Elastic Email API}
  gem.summary       = %q{This wrapper is currently only for adding and removing contacts and lists}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
