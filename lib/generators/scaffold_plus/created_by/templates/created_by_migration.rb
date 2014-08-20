class <%= migration_name.camelize %> < ActiveRecord::Migration
  def change
    add_column :<%= table_name %>, :created_by, :integer
    add_column :<%= table_name %>, :updated_by, :integer
  end
end
