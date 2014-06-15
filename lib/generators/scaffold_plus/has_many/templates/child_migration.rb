class <%= migration_name.camelize %> < ActiveRecord::Migration
  def change
    add_column :<%= children %>, :<%= name %>_id, :integer
<%- if create_index? -%>
    add_index :<%= children %>, :<%= name %>_id
<%- end -%>
  end
end
