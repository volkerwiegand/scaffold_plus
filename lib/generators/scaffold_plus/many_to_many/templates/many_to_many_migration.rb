class <%= migration_name.camelize %> < ActiveRecord::Migration
  def change
    create_table :<%= table_name %> do |t|
      t.belongs_to :<%= one %>
      t.belongs_to :<%= two %>
  <%- added_fields.each do |field| -%>
      t.<%= field[1] %>  :<%= field[0] %>
  <%- end -%>

      t.timestamps
    end
<%- if options.index? -%>
    add_index :<%= table_name %>, :<%= one %>_id
    add_index :<%= table_name %>, :<%= two %>_id
  <%- added_fields.each do |field| -%>
    <%- if field[2] == "uniq" -%>
    add_index :<%= table_name %>, :<%= field[0] %>, unique: true
    <%- elsif field[2] == "index" -%>
    add_index :<%= table_name %>, :<%= field[0] %>
    <%- end -%>
  <%- end -%>
<%- end -%>
  end
end
