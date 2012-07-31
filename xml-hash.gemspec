require File.expand_path('../lib/xml-hash/version', __FILE__)

Gem::Specification.new do |s|
  s.name          = 'xml-hash'
  s.authors       = ['Chad W. Pry', 'Andrew Dennis']
  s.email         = ['chad.pry@gmail.com', 'adennis4@gmail.com']
  s.summary       = 'XML to Hash converter'
  s.description   = 'Converts an XML file to a Hash.'
  s.homepage      = 'http://github.com/adennis4/xml-hash'

  #s.executables   = `git ls-files -- bin/*`.split('\n').map{ |f| File.basename(f) }
  s.files         = `git ls-files`.split('\n')
  #s.test_files    = `git ls-files -- {test,spec,features}/*`.split('\n')
  #s.require_paths = ['lib']
  s.version       = XmlHash::VERSION

  s.add_development_dependency('rake')
  s.add_development_dependency('rspec', '~> 2.11.0')
end