class <%= migration_name.camelize %> < ActiveRecord::Migration
  def change
    add_column :<%= child.pluralize %>, :<%= name %>_id, :integer
<%- if options.index? -%>
    add_index :<%= child.pluralize %>, :<%= name %>_id
<%- end -%>
  end
end
