require 'rails/generators/active_record'

module ScaffoldPlus
  module Generators
    class ManyToManyGenerator < ActiveRecord::Generators::Base
      desc "Add many-to-many association with intermediate join table"
      argument :name, type: :string,
               desc: "The name of the intermediate table"
      argument :one, type: :string,
               desc: "The first object that has_many TWO objects through NAME"
      argument :two, type: :string,
               desc: "The second object that has_many ONE objects through NAME"
      class_option :add_attr, type: :array, banner: "FIELD[:TYPE][:INDEX] ...",
               desc: 'Setup additional attributes for join table'
      class_option :dependent, type: :string, banner: 'ACTION',
               desc: 'Can be destroy, delete, or restrict'
      class_option :nested, type: :array, banner: 'attribute [...]',
               desc: 'Add accepts_nested_attributes_for to ONE incl. whitelisting'
      class_option :counter, type: :boolean, default: false,
               desc: 'Add counter_cache to ONE (and only to ONE)'
      class_option :before, type: :array,
               desc: 'Add a line before generated text in models'
      class_option :after, type: :array,
               desc: 'Add a line after generated text in models'
      class_option :migration, type: :boolean, default: true,
               desc: 'Create a migration for the join table'
      class_option :index, type: :boolean, default: true,
               desc: 'Add an index to the migration'
      source_root File.expand_path('../templates', __FILE__)

      def add_migration
        return unless options.migration?
        migration_template 'many_to_many_migration.rb', "db/migrate/#{migration_name}.rb"
      end

      def add_counter
        return unless options.counter?
        migration_template 'counter_migration.rb', "db/migrate/#{counter_migration}.rb"
      end

      def add_to_models
        [[one, two], [two, one]].each do |pair|
          current, partner = pair
          inject_into_class "app/models/#{current}.rb", current.camelize do
            text = before_array.include?(current) ? "\n" : ""
            text << "  has_many :#{table_name}"
            text << ", dependent: :#{dependent}" if options.dependent.present?
            text << "\n"
            text << "  has_many :#{partner.pluralize}, through: :#{table_name}\n"
            if current == one
              text << "  accepts_nested_attributes_for :#{table_name}\n" if options.nested.present?
            end
            text << "\n" if after_array.include?(current)
            text
          end
        end

        template 'many_to_many_model.rb', "app/models/#{name}.rb"
      end

      def add_to_permit
        return unless options.nested.present?
        list = options.nested.map{|n| ":#{n}"}.join(', ')
        text = "#{table_name}_attributes: [ #{list} ]"
        file = "app/controllers/#{one.pluralize}_controller.rb"
        gsub_file file, /(permit\(.*)\)/, "\\1, #{text})"
        # Special case: no previous permit
        gsub_file file, /^(\s*params)\[:#{name}\]$/, "\\1.require(:#{name}).permit(#{text})"
      end

      protected

      def added_fields
        list = options.add_attr || []
        array = []
        list.each do |entry|
          name, type, index = entry.split(':')
          type, index = ["string", type] if %w(index uniq).include? type
          array << [name, type || "string", index]
        end
        array
      end

      def before_array
        options.before || []
      end

      def after_array
        options.after || []
      end

      def dependent
        if options.dependent.present? and options.dependent == "restrict"
          "restrict_with_exception"
        else
          options.dependent
        end
      end

      def migration_name
        "create_#{table_name}"
      end

      def counter_migration
        "add_#{table_name}_count_to_#{one}"
      end

      def counter_cache
        options.counter? ? ", counter_cache: true" : ""
      end
    end
  end
end
