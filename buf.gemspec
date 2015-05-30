Gem::Specification.new do |s|
  s.name        = 'buf'
  s.version     = '0.0.9'
  s.date        = '2015-05-30'
  s.summary     = "It works. 0.0.7 failed to specify thor as a runtime dependency."
  s.description = "A dead simple short-term memory aid"
  s.authors     = ["Douglas Lamb"]
  s.email       = 'douglaslamb@douglaslamb.com'
  s.files       = ["lib/buf.rb"]
  s.executables << 'buf'
  s.homepage    = 'https://github.com/douglaslamb/buf'
  s.license     = 'none'
  s.add_dependency 'thor'
end
