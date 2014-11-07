class <%= migration_name.camelize %> < ActiveRecord::Migration
  def change
    create_table :<%= table_name %> do |t|
      t.belongs_to :<%= one %>
      t.belongs_to :<%= two %>
<%- attributes.each do |attribute| -%>
      t.<%= attribute.split(':').second %> :<%= attribute.split(':').first %>
<%- end -%>

      t.timestamps
    end
<%- if options._index? -%>
    add_index :<%= table_name %>, :<%= one %>_id
    add_index :<%= table_name %>, :<%= two %>_id
<%- end -%>
  end
end
