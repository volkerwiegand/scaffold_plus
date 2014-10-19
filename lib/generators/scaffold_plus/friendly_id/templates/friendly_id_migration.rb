class <%= migration_name.camelize %> < ActiveRecord::Migration
  def change
    add_column :<%= table_name %>, :slug, :string
    add_index :<%= table_name %>, :slug, unique: true
  end
end
