require_relative 'lib/mac_addresses/version'

Gem::Specification::new do |spec|
  spec.name = 'mac_addresses'
  spec.version = MacAddresses::VERSION
  spec.platform = Gem::Platform::RUBY
  spec.summary = 'Cross platform mac addresses determination'
  spec.description = 'Cross platform mac addresses determination'
  spec.license = 'MIT'

  spec.files  = Dir['README.md', 'LICENSE', 'lib/**/*.rb']

  spec.author = 'Alessandro Verlato'
  spec.email = 'alessandro@fancypixel.it'
  spec.homepage = 'https://github.com/FancyPixel/mac_addresses'

  spec.required_ruby_version = '>= 2.5.0'
end
