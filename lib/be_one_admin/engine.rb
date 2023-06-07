require 'sass-rails'
require 'haml-rails'
require 'turbolinks'
require 'jquery-rails'
require 'pace/rails'
require 'font-awesome-rails'
require "angularjs-rails"
require "angular-rails-templates"
require "angular-ui-bootstrap-rails"
require "angular-ng-table-rails"
require "angular-translate-rails"
require "will_paginate"
require 'coderay'
require 'be_one_core'
require 'active_model_serializers'


require_relative "controller"
require_relative 'logger'
require_relative 'stat'
require_relative "routable_concern"

module BeOneAdmin
  class Engine < ::Rails::Engine
    isolate_namespace BeOneAdmin

    initializer 'assets' do |app|
      app.config.assets.precompile += %w(*.png *.jpg *.jpeg *.gif)
      app.config.assets.paths << root.join("app", "assets", "images", "be_one_admin")
      app.config.assets.paths << root.join("app", "assets", "fonts", "be_one_admin")
    end

    initializer 'add_config_files', after: :load_config_initializers do |app|
      app.config.paths["config"] << root.join('config')
    end

  end
end

