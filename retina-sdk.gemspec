# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'retina-sdk/version'

Gem::Specification.new do |spec|
  spec.name          = "retina-sdk"
  spec.version       = RetinaSDK::VERSION
  spec.authors       = ["Laurent Julliard"]
  spec.email         = ["laurent@moldus.org"]
  spec.description   = %q{
**Cortical.io's Retina API** allows the user to perform semantic operations
on text. One can for example:

  * measure the semantic similarity between two written entities
  * create a semantic classifier based on positive and negative example texts
  * extract keywords from a text
  * extract terms from a text based on part of speech tags

The meaning of terms and texts is stored in a sparse binary representation that allows the user to apply logical
operators to refine the semantic representation of a concept.

You can read more about the technology at the `documentation page <http://documentation.cortical.io/intro.html>`_.

To access the API, you will need to register for an `API key  <http://www.cortical.io/resources_apikey.html>`_.
}
  spec.summary       = %q{Client library for accessing Cortical.io's Retina API.}
  spec.homepage      = "https://github.com/cortical-io/retina-sdk.rb"
  spec.license       = "Cortical.io"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "test-unit"

end
