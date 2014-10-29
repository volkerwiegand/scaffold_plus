class <%= migration_name.camelize %> < ActiveRecord::Migration
  def change
<%= @the_lines.join("\n") %>
  end
end
