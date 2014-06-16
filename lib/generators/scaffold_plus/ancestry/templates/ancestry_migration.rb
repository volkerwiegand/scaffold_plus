class <%= migration_name.camelize %> < ActiveRecord::Migration
  def change
    add_column :<%= table_name %>, :ancestry, :string
<%- if create_depth? -%>
    add_column :<%= table_name %>, :ancestry_depth, :integer, default: 0
<%- end -%>
<%- if create_index? -%>
    add_index :<%= table_name %>, :ancestry
<%- end -%>
  end
end
