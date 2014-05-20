# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'camcorder/version'

Gem::Specification.new do |spec|
  spec.name          = "camcorder"
  spec.version       = Camcorder::VERSION
  spec.authors       = ["Gordon L. Hempton"]
  spec.email         = ["ghempton@gmail.com"]
  spec.summary       = "VCR-like recording for arbitrary method invocations."
  spec.description   = "VCR-like recording for arbitrary method invocations."
  spec.homepage      = "https://github.com/ghempton/camcorder"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
end
