# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bkc_admin/version'

Gem::Specification.new do |spec|
  spec.name          = "bkc_admin"
  spec.version       = BkcAdmin::VERSION
  spec.authors       = ["Zhenya Telyukov"]
  spec.email         = ["etelyukov@bkc.ru"]
  spec.summary       = %q{BKC Admin Generation}
  spec.description   = %q{Tool to generate Admin controllers, helpers and views}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
# spec.executables   = ["bkc_admin"]  # alternative solution - not optimal
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
# spec.add_development_dependency "haml-rails", "~> 0.8.2"
end
