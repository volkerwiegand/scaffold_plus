class <%= migration_name.camelize %> < ActiveRecord::Migration
  def change
    add_column :<%= table_name %>, :<%= options.latitude %>, :decimal, precision: 9, scale: 6
    add_column :<%= table_name %>, :<%= options.longitude %>, :decimal, precision: 9, scale: 6
<%- if options.address? -%>
    add_column :<%= table_name %>, :address, :string
    add_column :<%= table_name %>, :country, :string
<%- end -%>
    add_index :<%= table_name %>, :<%= options.latitude %>
    add_index :<%= table_name %>, :<%= options.longitude %>
  end
end
