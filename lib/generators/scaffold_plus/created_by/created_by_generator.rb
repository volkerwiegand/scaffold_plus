require 'rails/generators/active_record'

module ScaffoldPlus
  module Generators
    class CreatedByGenerator < ActiveRecord::Generators::Base
      desc "Add created_by and updated_by to resource"
      argument :name, type: :string,
               desc: "The resource to be updated"
      argument :user, type: :string, default: "user",
               banner: "user model (default 'user')"
      class_option :migration, type: :boolean, default: true,
               desc: 'Create a migration for added attributes'
      class_option :before, type: :boolean, default: false,
               desc: 'Add a line before generated text in model'
      class_option :after, type: :boolean, default: false,
               desc: 'Add a line after generated text in model'
      source_root File.expand_path('../templates', __FILE__)
      
      def add_migration
        return unless options.migration?
        migration_template 'created_by_migration.rb', "db/migrate/#{migration_name}.rb"
      end
      
      def add_to_model
        [ "created", "updated" ].each do |action|
          lines = options.before? ? [ "" ] : []
          lines << [
            "  def #{action}_by_name",
            "    #{user.camelize}.find(#{action}_by).try('name')",
            "  end",
            ""
          ]
          lines << [ "" ] if options.after?
          inject_into_class "app/models/#{name}.rb", class_name, lines.join("\n")
        end
      end
      
      def add_to_controller
        file = "app/controllers/#{table_name}_controller.rb"
        inject_into_file file, after: /def update$/ do
          "\n    @#{name}.updated_by = current_#{user}.id if current_#{user}"
        end
        inject_into_file file, after: /@#{name} = #{class_name}\.new\(#{name}_params\)$/ do
          "\n    @#{name}.created_by = current_#{user}.id if current_#{user}" +
          "\n    @#{name}.updated_by = current_#{user}.id if current_#{user}"
        end
      end
      
      protected
      
      def migration_name
        "add_created_by_to_#{name}"
      end
    end
  end
end
