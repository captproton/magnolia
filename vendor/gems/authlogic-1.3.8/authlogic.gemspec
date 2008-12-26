# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{authlogic}
  s.version = "1.3.8"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Ben Johnson of Binary Logic"]
  s.date = %q{2008-12-24}
  s.description = %q{A clean, simple, and unobtrusive ruby authentication solution.}
  s.email = %q{bjohnson@binarylogic.com}
  s.extra_rdoc_files = ["CHANGELOG.rdoc", "lib/authlogic/controller_adapters/abstract_adapter.rb", "lib/authlogic/controller_adapters/merb_adapter.rb", "lib/authlogic/controller_adapters/rails_adapter.rb", "lib/authlogic/crypto_providers/aes256.rb", "lib/authlogic/crypto_providers/bcrypt.rb", "lib/authlogic/crypto_providers/sha1.rb", "lib/authlogic/crypto_providers/sha512.rb", "lib/authlogic/orm_adapters/active_record_adapter/acts_as_authentic/config.rb", "lib/authlogic/orm_adapters/active_record_adapter/acts_as_authentic/credentials.rb", "lib/authlogic/orm_adapters/active_record_adapter/acts_as_authentic/logged_in.rb", "lib/authlogic/orm_adapters/active_record_adapter/acts_as_authentic/perishability.rb", "lib/authlogic/orm_adapters/active_record_adapter/acts_as_authentic/persistence.rb", "lib/authlogic/orm_adapters/active_record_adapter/acts_as_authentic/session_maintenance.rb", "lib/authlogic/orm_adapters/active_record_adapter/acts_as_authentic/single_access.rb", "lib/authlogic/orm_adapters/active_record_adapter/acts_as_authentic.rb", "lib/authlogic/orm_adapters/active_record_adapter/authenticates_many.rb", "lib/authlogic/session/active_record_trickery.rb", "lib/authlogic/session/authenticates_many_association.rb", "lib/authlogic/session/base.rb", "lib/authlogic/session/callbacks.rb", "lib/authlogic/session/config.rb", "lib/authlogic/session/cookies.rb", "lib/authlogic/session/errors.rb", "lib/authlogic/session/params.rb", "lib/authlogic/session/perishability.rb", "lib/authlogic/session/scopes.rb", "lib/authlogic/session/session.rb", "lib/authlogic/testing/test_unit_helpers.rb", "lib/authlogic/version.rb", "lib/authlogic.rb", "README.rdoc"]
  s.files = ["CHANGELOG.rdoc", "generators/session/session_generator.rb", "generators/session/templates/session.rb", "init.rb", "lib/authlogic/controller_adapters/abstract_adapter.rb", "lib/authlogic/controller_adapters/merb_adapter.rb", "lib/authlogic/controller_adapters/rails_adapter.rb", "lib/authlogic/crypto_providers/aes256.rb", "lib/authlogic/crypto_providers/bcrypt.rb", "lib/authlogic/crypto_providers/sha1.rb", "lib/authlogic/crypto_providers/sha512.rb", "lib/authlogic/orm_adapters/active_record_adapter/acts_as_authentic/config.rb", "lib/authlogic/orm_adapters/active_record_adapter/acts_as_authentic/credentials.rb", "lib/authlogic/orm_adapters/active_record_adapter/acts_as_authentic/logged_in.rb", "lib/authlogic/orm_adapters/active_record_adapter/acts_as_authentic/perishability.rb", "lib/authlogic/orm_adapters/active_record_adapter/acts_as_authentic/persistence.rb", "lib/authlogic/orm_adapters/active_record_adapter/acts_as_authentic/session_maintenance.rb", "lib/authlogic/orm_adapters/active_record_adapter/acts_as_authentic/single_access.rb", "lib/authlogic/orm_adapters/active_record_adapter/acts_as_authentic.rb", "lib/authlogic/orm_adapters/active_record_adapter/authenticates_many.rb", "lib/authlogic/session/active_record_trickery.rb", "lib/authlogic/session/authenticates_many_association.rb", "lib/authlogic/session/base.rb", "lib/authlogic/session/callbacks.rb", "lib/authlogic/session/config.rb", "lib/authlogic/session/cookies.rb", "lib/authlogic/session/errors.rb", "lib/authlogic/session/params.rb", "lib/authlogic/session/perishability.rb", "lib/authlogic/session/scopes.rb", "lib/authlogic/session/session.rb", "lib/authlogic/testing/test_unit_helpers.rb", "lib/authlogic/version.rb", "lib/authlogic.rb", "Manifest", "MIT-LICENSE", "Rakefile", "README.rdoc", "shoulda_macros/authlogic.rb", "test/crypto_provider_tests/aes256_test.rb", "test/crypto_provider_tests/bcrypt_test.rb", "test/crypto_provider_tests/sha1_test.rb", "test/crypto_provider_tests/sha512_test.rb", "test/fixtures/companies.yml", "test/fixtures/employees.yml", "test/fixtures/projects.yml", "test/fixtures/users.yml", "test/libs/mock_controller.rb", "test/libs/mock_cookie_jar.rb", "test/libs/mock_request.rb", "test/libs/ordered_hash.rb", "test/libs/user.rb", "test/orm_adapters_tests/active_record_adapter_tests/acts_as_authentic_tests/config_test.rb", "test/orm_adapters_tests/active_record_adapter_tests/acts_as_authentic_tests/credentials_test.rb", "test/orm_adapters_tests/active_record_adapter_tests/acts_as_authentic_tests/logged_in_test.rb", "test/orm_adapters_tests/active_record_adapter_tests/acts_as_authentic_tests/perishability_test.rb", "test/orm_adapters_tests/active_record_adapter_tests/acts_as_authentic_tests/persistence_test.rb", "test/orm_adapters_tests/active_record_adapter_tests/acts_as_authentic_tests/session_maintenance_test.rb", "test/orm_adapters_tests/active_record_adapter_tests/acts_as_authentic_tests/single_access_test.rb", "test/orm_adapters_tests/active_record_adapter_tests/authenticates_many_test.rb", "test/session_tests/active_record_trickery_test.rb", "test/session_tests/authenticates_many_association_test.rb", "test/session_tests/base_test.rb", "test/session_tests/config_test.rb", "test/session_tests/cookies_test.rb", "test/session_tests/params_test.rb", "test/session_tests/perishability_test.rb", "test/session_tests/scopes_test.rb", "test/session_tests/session_test.rb", "test/test_helper.rb", "authlogic.gemspec"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/binarylogic/authlogic}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Authlogic", "--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{authlogic}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{A clean, simple, and unobtrusive ruby authentication solution.}
  s.test_files = ["test/crypto_provider_tests/aes256_test.rb", "test/crypto_provider_tests/bcrypt_test.rb", "test/crypto_provider_tests/sha1_test.rb", "test/crypto_provider_tests/sha512_test.rb", "test/orm_adapters_tests/active_record_adapter_tests/acts_as_authentic_tests/config_test.rb", "test/orm_adapters_tests/active_record_adapter_tests/acts_as_authentic_tests/credentials_test.rb", "test/orm_adapters_tests/active_record_adapter_tests/acts_as_authentic_tests/logged_in_test.rb", "test/orm_adapters_tests/active_record_adapter_tests/acts_as_authentic_tests/perishability_test.rb", "test/orm_adapters_tests/active_record_adapter_tests/acts_as_authentic_tests/persistence_test.rb", "test/orm_adapters_tests/active_record_adapter_tests/acts_as_authentic_tests/session_maintenance_test.rb", "test/orm_adapters_tests/active_record_adapter_tests/acts_as_authentic_tests/single_access_test.rb", "test/orm_adapters_tests/active_record_adapter_tests/authenticates_many_test.rb", "test/session_tests/active_record_trickery_test.rb", "test/session_tests/authenticates_many_association_test.rb", "test/session_tests/base_test.rb", "test/session_tests/config_test.rb", "test/session_tests/cookies_test.rb", "test/session_tests/params_test.rb", "test/session_tests/perishability_test.rb", "test/session_tests/scopes_test.rb", "test/session_tests/session_test.rb", "test/test_helper.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activesupport>, [">= 0"])
      s.add_runtime_dependency(%q<echoe>, [">= 0"])
      s.add_development_dependency(%q<echoe>, [">= 0"])
    else
      s.add_dependency(%q<activesupport>, [">= 0"])
      s.add_dependency(%q<echoe>, [">= 0"])
      s.add_dependency(%q<echoe>, [">= 0"])
    end
  else
    s.add_dependency(%q<activesupport>, [">= 0"])
    s.add_dependency(%q<echoe>, [">= 0"])
    s.add_dependency(%q<echoe>, [">= 0"])
  end
end
