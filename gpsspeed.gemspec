# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{gpsspeed}
  s.version = "0.0.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Tallak Tveide"]
  s.date = %q{2009-02-15}
  s.description = %q{GPS Track speed calculation utility}
  s.email = ["tallak@tveide.net"]
  s.executables = ["bin", "gpsspeed"]
  s.extra_rdoc_files = ["History.txt", "Manifest.txt", "PostInstall.txt", "README.rdoc"]
  s.files = ["bin", "bin/gpsspeed", "gpsspeed.gemspec", "History.txt", "lib", "lib/gpsspeed", "lib/gpsspeed/runner.rb", "lib/gpsspeed.rb", "LICENSE", "Manifest.txt", "PostInstall.txt", "Rakefile", "README.rdoc", "script", "script/console", "script/generate", "script/destroy", "tasks", "test", "test/test_helper.rb", "test/test_gpsspeed.rb", "test/input", "test/input/test_walk.gpx", "test/input/tracks.gpx", "bin/bin"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/tallakt/plcutil}
  s.post_install_message = %q{PostInstall.txt}
  s.rdoc_options = ["--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{gpsspeed}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{GPS Track speed calculation utility}
  s.test_files = ["test/test_helper.rb", "test/test_gpsspeed.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<tallakt-geoutm>, [">= 0.0.3"])
      s.add_development_dependency(%q<newgem>, [">= 1.2.3"])
      s.add_development_dependency(%q<hoe>, [">= 1.8.0"])
    else
      s.add_dependency(%q<tallakt-geoutm>, [">= 0.0.3"])
      s.add_dependency(%q<newgem>, [">= 1.2.3"])
      s.add_dependency(%q<hoe>, [">= 1.8.0"])
    end
  else
    s.add_dependency(%q<tallakt-geoutm>, [">= 0.0.3"])
    s.add_dependency(%q<newgem>, [">= 1.2.3"])
    s.add_dependency(%q<hoe>, [">= 1.8.0"])
  end
end
