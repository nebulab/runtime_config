lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'runtime_conf_tool/version'

Gem::Specification.new do |spec|
  spec.name = 'runtime_conf_tool'
  spec.version = RuntimeConfTool::VERSION

  spec.summary = 'Runtime Configuration Tool for Rails'
  spec.authors = ['Mattia Roccoberton']
  spec.email = ['mat@blocknot.es']
  spec.homepage = 'https://blocknot.es'
  spec.licenses = ['MIT']

  spec.add_dependency 'rails', ['>= 5.0', '< 6.0']

  spec.files = `git ls-files -z lib LICENSE.md README.md`.split("\0")
end
