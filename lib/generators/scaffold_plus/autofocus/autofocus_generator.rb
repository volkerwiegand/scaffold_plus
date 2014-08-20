require 'rails/generators/active_record'

module ScaffoldPlus
  module Generators
    class AutofocusGenerator < ActiveRecord::Generators::Base
      desc "Add autofocus to view"
      argument :name, type: :string,
               desc: "The object to be updated"
      argument :column, type: :string,
               desc: 'The column name to be focused'
      
      def add_to_view
        file = "app/views/#{table_name}/_form.html.erb"
        gsub_file file, /(:#{column}) %>/, "\\1, autofocus: true %>"
      end
    end
  end
end
