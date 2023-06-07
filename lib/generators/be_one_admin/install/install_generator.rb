require 'rails/generators/migration'
require 'rails/generators/active_record'

module BeOneAdmin
  class InstallGenerator < Rails::Generators::Base
    include Rails::Generators::Migration
    source_root File.expand_path("../templates", __FILE__)
    def add_route
      route 'mount BeOneAdmin::Engine, at: "/#{BeOneAdmin.config.route}", as: :admin_root'
    end

    def copy_initializer_file
      copy_file "initializer.rb", "config/initializers/be_one_admin.rb"
    end

    def copy_locale_file
      copy_file "locale.yml", "config/locales/#{BeOneAdmin.config.class_name.downcase}.en.yml"
    end


    def copy_assets_file
      copy_file "application.js", "app/assets/javascripts/admin_application.js"
      copy_file "application.css", "app/assets/stylesheets/admin_application.css"
    end

    def init_db_if_not_exist
      run 'rails db:environment:set RAILS_ENV=development'
      run 'rake db:drop'
      run 'rake db:create' unless database_exists?
    end

    def add_active_storage
     Bundler.with_clean_env do
       run "bundle install"
     end

      run 'rails active_storage:install'
      run 'bundle exec rails generate paper_trail:install --with-changes && rake db:migrate'
    end

    def copy_flags
      directory "flags", "public/be_one_admin/flags"
    end

    def copy_migration_tables
      migration_template "add_ip_and_user_agent_to_versions.rb.erb", "db/migrate/add_ip_and_user_agent_to_versions.rb"
      rake("db:migrate")
      migration_template "create_be_one_admin_tables.rb.erb", "db/migrate/create_be_one_admin_tables.rb"
      rake("db:migrate")
      migration_template "create_be_one_admin_records.rb.erb", "db/migrate/create_be_one_admin_records.rb"      
    end


    def migrate
      rake("db:migrate")
      rake("be_one_admin:reset")
    end


    def self.next_migration_number(path)
      unless @prev_migration_nr
        @prev_migration_nr = Time.now.utc.strftime("%Y%m%d%H%M%S").to_i
      else
        @prev_migration_nr += 1
      end
      @prev_migration_nr.to_s
    end


    def database_exists?
      ActiveRecord::Base.connection
    rescue ActiveRecord::NoDatabaseError
      false
    else
      true
    end


  end
end


