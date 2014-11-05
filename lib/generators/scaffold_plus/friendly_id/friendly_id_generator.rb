require 'rails/generators/active_record'

module ScaffoldPlus
  module Generators
    class FriendlyIdGenerator < ActiveRecord::Generators::Base
      desc "Add friendly_id to resource"
      argument :name, type: :string,
               desc: 'The object that uses friendly_id'
      argument :attribute, type: :string, default: 'name',
               desc: 'The model attribute to be slugged'
      class_option :migration, type: :boolean, default: true,
               desc: 'Create migration for the slug attribute'
      class_option :before, type: :boolean, default: false,
               desc: 'Add a line before generated text in model'
      class_option :after, type: :boolean, default: false,
               desc: 'Add a line after generated text in model'
      source_root File.expand_path('../templates', __FILE__)

      def add_migration
        return unless options.migration?
        migration_template "friendly_id_migration.rb", "db/migrate/#{migration_name}.rb"
      end

      def update_model
        inject_into_class "app/models/#{name}.rb", class_name do
          text = options.before? ? "\n" : ""
          text << "  extend FriendlyId\n"
          text << "  friendly_id :#{attribute}, use: [:slugged, :finders]\n"
          text << "\n" if options.after?
          text
        end
      end

      def update_controller
        file = "app/controllers/#{table_name}_controller.rb"
        gsub_file file, /(#{class_name})\.find/, "\\1.friendly.find"
      end

      protected

      def migration_name
        "add_friendly_id_to_#{table_name}"
      end
    end
  end
end
