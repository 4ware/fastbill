# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "fastbill/version"

Gem::Specification.new do |s|
  s.name        = "fastbill"
  s.version     = Fastbill::VERSION
  s.authors     = ["Kai Wernicke"]
  s.email       = ["kai@4ware.net"]
  s.homepage    = ""
  s.summary     = %q{ruby wrapper for the fastbill API}
  s.description = %q{a basic ruby wrapper for the methods provided by the fastbill API}

  s.rubyforge_project = "fastbill"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_development_dependency "rspec"
  s.add_development_dependency "json"
  s.add_runtime_dependency "json"
end
