class <%= counter_migration.camelize %> < ActiveRecord::Migration
  def change
    add_column :<%= one.pluralize %>, :<%= table_name %>_count, :integer
  end
end
