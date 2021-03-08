lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'runtime_config/version'

Gem::Specification.new do |spec|
  spec.platform = Gem::Platform::RUBY
  spec.version  = RuntimeConfig::VERSION
  spec.name     = 'runtime_config'
  spec.summary  = 'A middleware to change configuration parameters at runtime for Rails 5'

  spec.required_ruby_version = '>= 2.2.2'

  spec.files = Dir['README.md', 'lib/**/*']
  spec.require_path = 'lib'
  spec.requirements << 'none'

  spec.authors  = ['Mattia Roccoberton']
  spec.email    = ['mat@blocknot.es']
  spec.homepage = 'https://github.com/blocknotes/runtime_config'
  spec.licenses = ['MIT']
end
