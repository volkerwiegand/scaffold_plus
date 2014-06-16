class <%= habtm_migration_name.camelize %> < ActiveRecord::Migration
  def change
    create_table :<%= habtm_table_name %>, id: false do |t|
      t.belongs_to :<%= sorted_sg[0] %>
      t.belongs_to :<%= sorted_sg[1] %>
    end
    add_index :<%=  habtm_table_name %>, :<%= sorted_sg[0] %>_id
    add_index :<%=  habtm_table_name %>, :<%= sorted_sg[1] %>_id
  end
end
