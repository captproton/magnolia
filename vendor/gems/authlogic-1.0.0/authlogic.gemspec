Gem::Specification.new do |s|
  s.name = %q{authlogic}
  s.version = "1.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Ben Johnson of Binary Logic"]
  s.date = %q{2008-11-05}
  s.description = %q{Framework agnostic object based authentication solution that handles all of the non sense for you. It's as easy as ActiveRecord is with a database.}
  s.email = %q{bjohnson@binarylogic.com}
  s.extra_rdoc_files = ["CHANGELOG.rdoc", "lib/authlogic/active_record/acts_as_authentic.rb", "lib/authlogic/active_record/authenticates_many.rb", "lib/authlogic/active_record/scoped_session.rb", "lib/authlogic/controller_adapters/abstract_adapter.rb", "lib/authlogic/controller_adapters/merb_adapter.rb", "lib/authlogic/controller_adapters/rails_adapter.rb", "lib/authlogic/session/active_record_trickery.rb", "lib/authlogic/session/base.rb", "lib/authlogic/session/callbacks.rb", "lib/authlogic/session/config.rb", "lib/authlogic/session/errors.rb", "lib/authlogic/session/scopes.rb", "lib/authlogic/sha512_crypto_provider.rb", "lib/authlogic/version.rb", "lib/authlogic.rb", "README.rdoc"]
  s.files = ["CHANGELOG.rdoc", "init.rb", "lib/authlogic/active_record/acts_as_authentic.rb", "lib/authlogic/active_record/authenticates_many.rb", "lib/authlogic/active_record/scoped_session.rb", "lib/authlogic/controller_adapters/abstract_adapter.rb", "lib/authlogic/controller_adapters/merb_adapter.rb", "lib/authlogic/controller_adapters/rails_adapter.rb", "lib/authlogic/session/active_record_trickery.rb", "lib/authlogic/session/base.rb", "lib/authlogic/session/callbacks.rb", "lib/authlogic/session/config.rb", "lib/authlogic/session/errors.rb", "lib/authlogic/session/scopes.rb", "lib/authlogic/sha512_crypto_provider.rb", "lib/authlogic/version.rb", "lib/authlogic.rb", "Manifest", "MIT-LICENSE", "Rakefile", "README.rdoc", "test/active_record_acts_as_authentic_test.rb", "test/active_record_authenticates_many_test.rb", "test/fixtures/companies.yml", "test/fixtures/employees.yml", "test/fixtures/projects.yml", "test/fixtures/users.yml", "test/test_helper.rb", "test/user_session_active_record_trickery_test.rb", "test/user_session_base_test.rb", "test/user_session_config_test.rb", "test/user_session_scopes_test.rb", "test_libs/aes128_crypto_provider.rb", "test_libs/mock_controller.rb", "test_libs/mock_cookie_jar.rb", "test_libs/mock_request.rb", "test_libs/ordered_hash.rb", "authlogic.gemspec"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/binarylogic/authlogic}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Authlogic", "--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{authlogic}
  s.rubygems_version = %q{1.2.0}
  s.summary = %q{Framework agnostic object based authentication solution that handles all of the non sense for you. It's as easy as ActiveRecord is with a database.}
  s.test_files = ["test/active_record_acts_as_authentic_test.rb", "test/active_record_authenticates_many_test.rb", "test/test_helper.rb", "test/user_session_active_record_trickery_test.rb", "test/user_session_base_test.rb", "test/user_session_config_test.rb", "test/user_session_scopes_test.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if current_version >= 3 then
      s.add_runtime_dependency(%q<activesupport>, [">= 0"])
      s.add_runtime_dependency(%q<activerecord>, [">= 0"])
      s.add_development_dependency(%q<echoe>, [">= 0"])
    else
      s.add_dependency(%q<activesupport>, [">= 0"])
      s.add_dependency(%q<activerecord>, [">= 0"])
      s.add_dependency(%q<echoe>, [">= 0"])
    end
  else
    s.add_dependency(%q<activesupport>, [">= 0"])
    s.add_dependency(%q<activerecord>, [">= 0"])
    s.add_dependency(%q<echoe>, [">= 0"])
  end
end
