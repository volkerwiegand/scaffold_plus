class <%= counter_migration.camelize %> < ActiveRecord::Migration
  def change
    add_column :<%= table_name %>, :<%= children %>_count, :integer
  end
end
