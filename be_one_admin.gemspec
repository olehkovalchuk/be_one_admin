$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "be_one_admin/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = "be_one_admin"
  spec.version     = BeOneAdmin::VERSION
  spec.authors     = ["Aleksander Chernov"]
  spec.email       = ["boss@beone.software"]
  spec.homepage    = "https://gems.beone.software/"
  spec.summary     = "BeOneAdmin"
  spec.description = "Admin functionality"
  spec.license     = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "https://gems.beone.software/"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_dependency 'be_one_core'
  spec.add_dependency 'haml-rails'
  spec.add_dependency 'sass-rails'
  spec.add_dependency 'font-awesome-rails'
  spec.add_dependency 'coffee-rails'
  spec.add_dependency 'uglifier'
  spec.add_dependency 'active_model_serializers'

  spec.add_dependency 'jquery-rails'
  spec.add_dependency 'pace-rails'
  spec.add_dependency 'angularjs-rails', '1.6.8'
  spec.add_dependency 'turbolinks'
  spec.add_dependency 'angular-rails-templates', '1.0.2'
  spec.add_dependency 'angular-ng-table-rails'
  spec.add_dependency 'angular-ui-bootstrap-rails'
  spec.add_dependency 'angular-translate-rails'
  spec.add_dependency 'coderay'
  spec.add_dependency 'will_paginate'
  
end

