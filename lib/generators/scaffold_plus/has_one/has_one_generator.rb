require 'rails/generators/active_record'

module ScaffoldPlus
  module Generators
    class HasOneGenerator < ActiveRecord::Generators::Base
      desc "Add regular one-to-one association (has_one / belongs_to)"
      argument :name, type: :string,
               desc: "The parent resource that has_one CHILD object"
      argument :child, type: :string,
               desc: "The child resource that belongs_to the NAME object"
      class_option :dependent, type: :string, banner: 'ACTION',
               desc: 'Can be destroy, delete, or restrict'
      class_option :permit, type: :boolean, default: false,
               desc: 'Allow mass assignment for added attributes'
      class_option :nested, type: :array, banner: 'attribute [...]',
               desc: 'Add accepts_nested_attributes_for (incl. whitelisting)'
      class_option :route, type: :boolean, default: false,
               desc: 'Add a nested route and update CHILD controller'
      class_option :foreign_key, type: :string,
               desc: 'Set the name of the foreign key directly'
      class_option :inverse, type: :boolean, default: false,
               desc: 'Add inverse_of to both models'
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

      def add_to_route
        return unless options.route?
        gsub_file "config/routes.rb", /^  resources :#{table_name} do$/ do |match|
          match << "\n    resources :#{child.pluralize}"
        end
        gsub_file "config/routes.rb", /^  resources :#{table_name}$/ do |match|
          match << " do\n    resources :#{child.pluralize}\n  end"
        end
      end

      def add_to_models
        inject_into_class "app/models/#{name}.rb", class_name do
          text = before_array.include?(name) ? "\n" : ""
          text << "  has_one :#{child}"
          text << ", inverse_of: :#{name}" if options.inverse?
          text << ", dependent: :#{dependent}" if options.dependent.present?
          text << "\n"
          if options.nested.present?
            text << "  accepts_nested_attributes_for :#{child}, allow_destroy: true\n"
          end
          text << "\n" if after_array.include?(name)
          text
        end

        inject_into_class "app/models/#{child}.rb", child.camelize do
          text = before_array.include?(child) ? "\n" : ""
          text << "  belongs_to :#{name}"
          if options.foreign_key
            text << ", foreign_key: \"#{options.foreign_key}\""
          end
          text << ", inverse_of: :#{child}" if options.inverse?
          text << "\n"
          text << "\n" if after_array.include?(child)
          text
        end
      end

      def update_parent_controller
        return if options.nested.blank?
        list = options.nested.map{|n| ":#{n}"}.join(', ')
        text = "#{child}_attributes: [ #{list} ]"
        file = "app/controllers/#{table_name}_controller.rb"
        return unless File.exist?(file)
        gsub_file file, /(permit\(.*)\)/, "\\1, #{text})"
        # Special case: no previous permit
        gsub_file file, /^(\s*params)\[:#{name}\]$/, "\\1.require(:#{name}).permit(#{text})"
      end

      def update_child_controller
        return unless options.permit?
        text = ":#{name}_id"
        file = "app/controllers/#{child.pluralize}_controller.rb"
        return unless File.exist?(file)
        gsub_file file, /(permit\(.*)\)/, "\\1, #{text})"
        # Special case: no previous permit
        gsub_file file, /^(\s*params)\[:#{name}\]$/, "\\1.require(:#{name}).permit(#{text})"
      end

      def update_nested_resource
        return unless options.route?
        children = child.pluralize
        file = "app/controllers/#{children}_controller.rb"
        if File.exist?(file)
          gsub_file file, /GET .#{children}.new$/ do |match|
            match = "GET /#{table_name}/:id/#{children}/new"
          end
          gsub_file file, /^    @#{child} = #{child.camelize}.new$/ do |match|
            match = "    @#{name} = #{class_name}.find(params[:#{name}_id])\n" +
                    "    @#{child} = @#{name}.#{children}.build"
          end
        end
        file = "app/views/#{children}/_form.html.erb"
        if File.exist?(file)
          gsub_file file, /form_for\(@#{child}/ do |match|
            match = "form_for([@#{name}, @#{child}]"
          end
        end
      end

      protected

      def before_array
        options.before || []
      end

      def after_array
        options.after || []
      end

      def dependent
        if options.dependent.present? && options.dependent == "restrict"
          "restrict_with_exception"
        else
          options.dependent
        end
      end

      def migration_name
        "add_#{name}_id_to_#{child}"
      end
    end
  end
end

# vim: set expandtab softtabstop=2 shiftwidth=2 autoindent :
