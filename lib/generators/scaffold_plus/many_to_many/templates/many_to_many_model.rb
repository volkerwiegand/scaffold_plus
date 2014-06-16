class <%= class_name %> < ActiveRecord::Base
  belongs_to :<%= one %><%= counter_cache %>
  belongs_to :<%= two %>
end
