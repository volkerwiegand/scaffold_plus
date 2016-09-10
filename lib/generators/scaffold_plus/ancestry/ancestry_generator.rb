require 'rails/generators/active_record'

module ScaffoldPlus
  module Generators
    class AncestryGenerator < ActiveRecord::Generators::Base
      desc "Add ancestry to create a tree structure (requires ancestry gem)"
      argument :name, type: :string,
               desc: "The object that has_ancestry"
      class_option :depth, type: :boolean, default: false,
               desc: 'Cache the depth of each node'
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
        migration_template "ancestry_migration.rb", "db/migrate/#{migration_name}.rb"
      end

      def update_model
        inject_into_class "app/models/#{name}.rb", class_name do
          text = options.before? ? "\n" : ""
          text << "  has_ancestry"
          text << ", cache_depth: true" if options.depth?
          text << "\n"
          text << "\n" if options.after?
          text
        end
      end

      def update_controller
        return unless options.permit?
        text = ":ancestry"
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
