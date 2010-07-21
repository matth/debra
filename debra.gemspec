$:.push(File.dirname(__FILE__) + "/lib")

require 'debra'

Gem::Specification.new do |s|
  s.name = "debra"
  s.version = Debra::VERSION.join(".")
  s.author = "Matt Haynes"
  s.email = "matt@matthaynes.net"
  s.homepage = "http://github.com/matth/debra/tree/master"
  s.summary  = "A little DSL for creating debian packages (experimental)"
  s.description = "Debra is an DSL for creating debian binary package files, still in the experimental stage but should work!"
  s.bindir = 'bin'
  s.executables << 'debra'  
  s.files = Dir.glob("lib/**/*") + %w(README.md)
  s.require_path = "lib"
  s.has_rdoc = false
  s.add_dependency 'rake'
end

