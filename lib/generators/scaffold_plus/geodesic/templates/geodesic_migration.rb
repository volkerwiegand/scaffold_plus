class <%= migration_name.camelize %> < ActiveRecord::Migration
  def change
    add_column :<%= table_name %>, :<%= options.latitude %>, :float
    add_column :<%= table_name %>, :<%= options.longitude %>, :float
<%- if options.address? -%>
    add_column :<%= table_name %>, :address, :string
    add_column :<%= table_name %>, :country, :string
<%- end -%>
    add_index :<%= table_name %>, :<%= options.latitude %>
    add_index :<%= table_name %>, :<%= options.longitude %>
  end
end
