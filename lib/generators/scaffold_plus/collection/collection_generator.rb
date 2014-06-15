require 'rails/generators/active_record'

module ScaffoldPlus
  module Generators
    class CollectionGenerator < ActiveRecord::Generators::Base
      desc "Add collection(s) to resource route"
      argument :name, type: :string,
               desc: "The object for the collection routes and views"
      argument :routes, type: :array, banner: "route[:verb=get] ...",
               desc: "The collection(s) to be added to NAME"
      source_root File.expand_path('../templates', __FILE__)
      
      def add_routes
        list = []
        routes.each do |route|
          view, verb = route.split(':')
          list << "      #{verb || 'get'} '#{view}'"
        end
        result = list.join("\n")
        gsub_file "config/routes.rb", /(^  resources :#{name.pluralize})$/,
                  "\\1 do\n    collection do\n#{result}\n    end\n  end"
      end
      
      def add_views
        routes.each do |route|
          @view = route.split(':').first
          template "view.html.erb", "app/views/#{table_name}/#{@view}.html.erb"
        end
      end
    end
  end
end
