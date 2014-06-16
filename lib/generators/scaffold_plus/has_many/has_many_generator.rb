require 'rails/generators/active_record'

module ScaffoldPlus
  module Generators
    class HasManyGenerator < ActiveRecord::Generators::Base
      desc "Add regular one-to-many association (has_many / belongs_to)"
      argument :name, type: :string,
               desc: "The parent resource that has_many CHILDREN objects"
      argument :children, type: :string,
               desc: "The child resources that belongs_to the NAME object"
      class_option :dependent, type: :string, banner: 'ACTION',
               desc: 'Can be destroy, delete, or restrict'
      class_option :nested, type: :array, banner: 'attribute [...]',
               desc: 'Add accepts_nested_attributes_for (incl. whitelisting)'
      class_option :inverse, type: :boolean, default: false,
               desc: 'Add inverse_of to both models'
      class_option :counter, type: :boolean, default: false,
               desc: 'Add counter_cache for CHILDREN'
      class_option :migration, type: :boolean, default: false,
               desc: 'Create a migration for added attributes'
      class_option :index, type: :boolean, default: true,
               desc: 'Add an index to the child migration'
      class_option :before, type: :array,
               desc: 'Add a line before generated text in models'
      class_option :after, type: :array,
               desc: 'Add a line after generated text in models'
      source_root File.expand_path('../templates', __FILE__)
      
      def add_migration
        return unless options.migration?
        migration_template 'child_migration.rb', "db/migrate/#{migration_name}.rb"
      end
      
      def add_counter
        return unless options.counter?
        migration_template 'counter_migration.rb', "db/migrate/#{counter_migration}.rb"
      end
      
      def add_to_models
        inject_into_class "app/models/#{name}.rb", class_name do
          text = before_array.include?(name) ? "\n" : ""
          text << "  has_many :#{children}"
          text << ", inverse_of: :#{name}" if options.inverse?
          text << ", dependent: :#{dependent}" if options[:dependent].present?
          text << "\n"
          text << "  accepts_nested_attributes_for :#{children}\n" if options[:nested].present?
          text << "\n" if after_array.include?(name)
          text
        end
        
        child = children.singularize
        inject_into_class "app/models/#{child}.rb", child.camelize do
          text = before_array.include?(child) ? "\n" : ""
          text << "  belongs_to :#{name}"
          text << ", inverse_of: :#{children}" if options.inverse?
          text << ", counter_cache: true" if options.counter?
          text << "\n"
          text << "\n" if after_array.include?(child)
          text
        end
      end
      
      def add_to_permit
        return unless options[:nested].present?
        list = options[:nested].map{|n| ":#{n}"}.join(', ')
        text = "#{children}_attributes: [ #{list} ]"
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
      
      def dependent
        if options[:dependent].present? && options[:dependent] == "restrict"
          "restrict_with_exception"
        else
          options[:dependent]
        end
      end
      
      def migration_name
        "add_#{name}_id_to_#{children}"
      end
      
      def create_index?
        options[:index]
      end
      
      def counter_migration
        "add_#{children}_count_to_#{table_name}"
      end
    end
  end
end
