class <%= migration_name.camelize %> < ActiveRecord::Migration
  def change
    add_column :<%= table_name %>, :<%= column %>, :integer, default: 0
<%- if options.index? -%>
    add_index :<%= table_name %>, :<%= column %>
<%- end -%>
  end
end
