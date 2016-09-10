class <%= migration_name.camelize %> < ActiveRecord::Migration
  def change
    add_column :<%= table_name %>, :<%= column %>, :string
<%- if options.index? -%>
    add_index :<%= table_name %>, :<%= column %>
<%- end -%>
  end
end
