require 'rails/generators'
require 'rails/generators/migration'
require 'rails/generators/active_record/migration'

module PpwmMatcher
  class InstallGenerator < Rails::Generators::Base
    include Rails::Generators::Migration
    extend ActiveRecord::Generators::Migration

    source_root File.expand_path('../templates', __FILE__)

    desc 'Generates migrations to add the ppwm-matcher tables'

    def create_migrations
      migration_template 'create_ppwm_matcher_tables.rb', 'db/migrate/create_ppwm_matcher_tables.rb'
    end
  end
end
