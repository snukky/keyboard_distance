# -*- encoding: utf-8 -*-
require File.expand_path('../lib/keyboard_distance/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["snukky"]
  gem.email         = ["snk987@gmail.com"]
  gem.description   = %q{Simple algorithm for measuring of distance-on-keyboard 
                      between two strings.}
  gem.summary       = %q{Distance-on-keyboard algorithm.}
  gem.homepage      = "https://github.com/snukky/keyboard_distance"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "keyboard_distance"
  gem.require_paths = ["lib"]
  gem.version       = KeyboardDistance::VERSION

  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec', '>= 2.0.0'
end
