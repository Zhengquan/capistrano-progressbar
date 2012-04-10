# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "capistrano-progressbar/version"

Gem::Specification.new do |s|
  s.name        = "capistrano-progressbar"
  s.version     = Capistrano::Progressbar::VERSION
  s.authors     = ["Zhengquan Yang"]
  s.email       = ["yangzhengquan@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Add the progressbar when using capistrnao}
  s.description = %q{Show progressbar when executing `cap deploy`}
  s.extra_rdoc_files = [
    "README.md"
  ]

  s.rubyforge_project = "capistrano-progressbar"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  s.add_runtime_dependency "capistrano", [">= 2.9.0"]
  s.add_runtime_dependency "progressbar", [">= 0.11.0"]
end
