require 'rails/generators/active_record'

module ScaffoldPlus
  module Generators
    class HabtmGenerator < ActiveRecord::Generators::Base
      desc "Add many-to-many association with has_and_belongs_to_many"
      argument :name, type: :string,
               desc: "The first object that has_and_belongs_to_many OTHERs"
      argument :other, type: :string,
               desc: "The second object that has_and_belongs_to_many NAMEs"
      class_option :migration, type: :boolean, default: true,
               desc: 'Create a migration for the join table'
      class_option :permit, type: :boolean, default: true,
               desc: 'Allow mass assignment for added attributes in NAME'
      class_option :before, type: :array,
               desc: 'Add a line before generated text in models'
      class_option :after, type: :array,
               desc: 'Add a line after generated text in models'
      source_root File.expand_path('../templates', __FILE__)
      
      def add_migration
        return unless options.migration?
        migration_template "habtm_migration.rb", "db/migrate/#{habtm_migration_name}.rb"
      end
      
      def add_to_models
        inject_into_class "app/models/#{name}.rb", class_name do
          text = before_array.include?(name) ? "\n" : ""
          text << "  has_and_belongs_to_many :#{other.pluralize}\n"
          text << "\n" if after_array.include?(name)
          text
        end
        inject_into_class "app/models/#{other}.rb", other.camelize do
          text = before_array.include?(other) ? "\n" : ""
          text << "  has_and_belongs_to_many :#{table_name}\n"
          text << "\n" if after_array.include?(other)
          text
        end
      end
      
      def add_to_permit
        return unless options.permit?
        text = "{ :#{other}_ids => [] }"
        file = "app/controllers/#{table_name}_controller.rb"
        gsub_file file, /(permit\(.*)\)/, "\\1, #{text})"
        # Special case: no previous permit
        gsub_file file, /^(\s*params)\[:#{name}\]$/, "\\1.require(:#{name}).permit(#{text})"
      end
      
      protected
      
      def before_array
        options['before'] || []
      end
      
      def after_array
        options['after'] || []
      end
      
      def sorted_sg
        [name, other].sort
      end
      
      def sorted_pl
        [table_name, other.pluralize].sort
      end
      
      def habtm_migration_name
        "create_#{sorted_pl.first}_and_#{sorted_pl.second}"
      end
      
      def habtm_table_name
        "#{sorted_pl.first}_#{sorted_pl.second}"
      end
    end
  end
end
