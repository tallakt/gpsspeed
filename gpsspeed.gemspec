# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{gpsspeed}
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Tallak Tveide"]
  s.date = %q{2009-02-15}
  s.default_executable = %q{gpsspeed}
  s.description = %q{GPS Track speed calculation utility}
  s.email = ["tallak@tveide.net"]
  s.executables = ["gpsspeed"]
  s.extra_rdoc_files = ["History.txt", "Manifest.txt", "PostInstall.txt", "README.rdoc"]
  s.files = [".git/COMMIT_EDITMSG", ".git/FETCH_HEAD", ".git/HEAD", ".git/ORIG_HEAD", ".git/config", ".git/description", ".git/hooks/applypatch-msg", ".git/hooks/commit-msg", ".git/hooks/post-commit", ".git/hooks/post-update", ".git/hooks/pre-applypatch", ".git/hooks/pre-commit", ".git/hooks/pre-rebase", ".git/hooks/update", ".git/index", ".git/info/exclude", ".git/info/refs", ".git/logs/HEAD", ".git/logs/refs/heads/master", ".git/logs/refs/remotes/origin/master", ".git/objects/02/d65c9f91ef91f62595e79245bcb91bad461b62", ".git/objects/0b/0a551ebfc9464614c71aa152202a2f221b03d9", ".git/objects/12/ec612700ff4e989e503dd220891a1b63cbd2d8", ".git/objects/25/dea7139f3ef7dd83e6b1d102ee35fc95cf975a", ".git/objects/2b/6c4ae5af10f44a6ac34911ff6bb33d2c0b99a4", ".git/objects/2f/e82e84398ee334b5118a8db4eea25542168279", ".git/objects/32/3a2b8eb841d4788eac1523ff6be83466ed480a", ".git/objects/32/95dd081a763fda5712a52312b1db7a7a00ea1c", ".git/objects/3b/75b95ef1d194a4ff34d405e5237182dd3ccb3a", ".git/objects/50/6608c9d876324267947a703a32f93eb794912a", ".git/objects/62/ac49008e679c716427559d5f5767538b0a374d", ".git/objects/68/90199df2fcf3bfa160a59541fee011e169a507", ".git/objects/6a/f4703ab16612390f3c3c53a2349b0a80de9c59", ".git/objects/79/287442820338fc99e34d4835c3334be741eee8", ".git/objects/81/dede27009e06bd87e1f33abaea9072877d2b56", ".git/objects/8e/37a2de160267d3ea1d98fc9a8a7ccd80109257", ".git/objects/b3/b7c75c9709ff478379e69ad9d5808a2918731b", ".git/objects/b8/5f0576d9fd553768b565be0fd37204e9d9620c", ".git/objects/bc/9a29b975c434f4526a65cad2cd4decca6c6d26", ".git/objects/c2/7f6559350f7adb19d43742b55b2f91d07b6550", ".git/objects/dc/3cef1c97816933cc0b8618501b131a6a627f61", ".git/objects/df/25b97f34aefa32a10a82ef68cd1b0ca6c82ddb", ".git/objects/df/daa5b5da960e78444eb6aa4da6c0ae0a9f3e87", ".git/objects/e3/2fc6a7dc0d7b006ed30950ec087dcc30de1998", ".git/objects/e4/8464df56bf487e96e21ea99487330266dae3c9", ".git/objects/e4/c27db670d7b389eb8cfa89cd66b5082b20110a", ".git/objects/eb/3a6ca87e26ffa0dad5f65d09f4293ea92d8383", ".git/objects/info/packs", ".git/objects/pack/pack-2811180054a0c38667402fe9ae480ac7b77d9acb.idx", ".git/objects/pack/pack-2811180054a0c38667402fe9ae480ac7b77d9acb.pack", ".git/packed-refs", ".git/refs/heads/master", ".git/refs/remotes/origin/master", ".gitignore", "History.txt", "LICENSE", "Manifest.txt", "PostInstall.txt", "README.rdoc", "Rakefile", "bin/gpsspeed", "gpsspeed.gemspec", "lib/gpsspeed.rb", "lib/gpsspeed/runner.rb", "script/console", "script/destroy", "script/generate", "test/input/.tracks.gpx.swp", "test/input/test_walk.gpx", "test/input/tracks.gpx", "test/test_gpsspeed.rb", "test/test_helper.rb"]
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
