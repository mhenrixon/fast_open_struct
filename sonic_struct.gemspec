# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name = 'sonic-struct'
  s.version = '0.1.0'
  s.summary = 'A faster OpenStruct'
  s.description = 'An almost drop-in replacement for OpenStruct that does not invalidate the method cache on every instantiation'
  s.author = 'Mikael Henriksson'
  s.email = 'mikael@mhenrixon.com'
  s.homepage = 'https://github.com/mhenrixon/sonic_struct'
  s.files = ['README.md', 'lib/almost_open_struct.rb']
end
