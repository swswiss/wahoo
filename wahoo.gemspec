# frozen_string_literal: true

require_relative "lib/wahoo/version"

Gem::Specification.new do |spec|
  spec.name = "wahoo"
  spec.version = Wahoo::VERSION
  spec.authors = ["swswiss"]
  spec.email = ["stefanachesilviu1993@gmail.com"]

  spec.summary = "A Ruby client for the Wahoo Cloud API."
  spec.description = "OAuth 2.0 (standard + PKCE), full CRUD for workouts, " \
                     "routes, plans, power zones and user, file uploads and " \
                     "webhooks, with first-class models, automatic pagination, " \
                     "unit conversions and automatic retries."
  spec.homepage = "https://github.com/swswiss/wahoo"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.2.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/swswiss/wahoo"
  spec.metadata["changelog_uri"] = "https://github.com/swswiss/wahoo/blob/main/CHANGELOG.md"

  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ Gemfile .gitignore .rspec spec/ .github/])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "faraday", ">= 1.0"
  spec.add_dependency "base64"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "webmock", "~> 3.0"
end