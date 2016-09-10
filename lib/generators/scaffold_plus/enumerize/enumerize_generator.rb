require 'rails/generators/active_record'

module ScaffoldPlus
  module Generators
    class EnumerizeGenerator < ActiveRecord::Generators::Base
      desc "Add an enum field to a resource (requires enumerize gem)"
      argument :name, type: :string,
               desc: "The object that will have the enum field"
      argument :column, type: :string,
               desc: "The column to be used as enum field"
      argument :values, type: :array, banner: "VALUE [...]",
               desc: "Values (can be strings or symbols)"
      class_option :migration, type: :boolean, default: false,
               desc: 'Create a migration for added attributes'
      class_option :index, type: :boolean, default: true,
               desc: 'Add an index to the migration'
      class_option :permit, type: :boolean, default: false,
               desc: 'Allow mass assignment for added attributes'
      class_option :before, type: :boolean, default: false,
               desc: 'Add a line before generated text in model'
      class_option :after, type: :boolean, default: false,
               desc: 'Add a line after generated text in model'
      source_root File.expand_path('../templates', __FILE__)

      def add_migration
        return unless options.migration?
        migration_template "enum_migration.rb", "db/migrate/#{migration_name}.rb"
      end

      def update_model
        inject_into_class "app/models/#{name}.rb", class_name do
          text = options.before? ? "\n" : ""
          text << "  extend Enumerize\n"
          text << "  enumerize :#{column}, in: #{values}\n"
          text << "\n" if options.after?
          text
        end
      end

      def update_controller
        return unless options.permit?
        text = ":#{column}"
        file = "app/controllers/#{table_name}_controller.rb"
        gsub_file file, /(permit\(.*)\)/, "\\1, #{text})"
        # Special case: no previous permit
        gsub_file file, /^(\s*params)\[:#{name}\]$/, "\\1.require(:#{name}).permit(#{text})"
      end

      protected

      def migration_name
        "add_ancestry_to_#{table_name}"
      end
    end
  end
end
