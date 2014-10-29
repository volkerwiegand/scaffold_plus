require 'rails/generators/active_record'

module ScaffoldPlus
  module Generators
    class MigrationGenerator < ActiveRecord::Generators::Base
      desc "Generate additional ALTER TABLE migrations"
      argument :name, type: :string,
               desc: 'The resource to be changed'
      class_option :remove, type: :array, banner: 'column [...]',
               desc: 'Columns that shall be removed'
      class_option :rename, type: :array, banner: 'old_name:new_name [...]',
               desc: 'Columns that shall be renamed'
      class_option :change, type: :array, banner: 'column:new_type [...]',
               desc: 'Change column types'
      class_option :not_null, type: :array, banner: 'column [...]',
               desc: 'Columns that may mot be NULL'
      class_option :set_default, type: :array, banner: 'column:value [...]',
               desc: 'Default values for columns'
      source_root File.expand_path('../templates', __FILE__)

      def prepare_the_lines
        @the_lines = []
      end

      def prepare_change_table
        return unless options.remove.present? or options.rename.present?
        @the_lines << "    change_table :#{table_name} do |t|"
        if options.remove.present?
          options.remove.each do |column|
            @the_lines << "      t.remove :#{column}"
          end
        end
        if options.rename.present?
          options.rename.each do |column|
            old_name, new_name = column.split(':')
            @the_lines << "      t.rename :#{old_name}, :#{new_name}"
          end
        end
        @the_lines << "    end"
      end

      def prepare_change_column
        return unless options.change.present?
        options.change.each do |column|
          column, new_type = column.split(':')
          @the_lines << "    change_column :#{table_name}, :#{column}, :#{new_type}"
        end
      end

      def prepare_not_null
        return unless options.not_null.present?
        options.not_null.each do |column|
          @the_lines << "    change_column_null :#{table_name}, :#{column}, false"
        end
      end

      def prepare_set_default
        return unless options.set_default.present?
        options.set_default.each do |column|
          column, preset = column.split(':')
          @the_lines << "    change_column_default :#{table_name}, :#{column}, #{preset}"
        end
      end

      def add_migration
        return unless @the_lines.any?
        migration_template "change_migration.rb", "db/migrate/#{migration_name}.rb"
      end

      protected

      def migration_name
        "change_#{table_name}"
      end
    end
  end
end
