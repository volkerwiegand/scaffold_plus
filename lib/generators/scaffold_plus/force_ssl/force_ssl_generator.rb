require 'rails/generators/active_record'

module ScaffoldPlus
  module Generators
    class ForceSslGenerator < ActiveRecord::Generators::Base
      desc "Enforce SSL for this controller in production"
      argument :name, type: :string,
               desc: "The resource that is SSL protected"
      class_option :only, type: :array,
               desc: 'Enforce for these actions'
      class_option :except, type: :array,
               desc: 'Do not enforce for these actions'
      
      def update_controller
        file = "app/controllers/#{table_name}_controller.rb"
        inject_into_file file, after: /^class.*ApplicationController$/ do
          text = "\n  force_ssl if: :ssl_configured?"
          text << ", only: [ #{only_list} ]", if options.only.present?
          text << ", except: [ #{except_list} ]", if options.except.present?
          text
        end
        inject_into_file file, after: /private$/ do
          [
            "",
            "    # When to enforce SSL for this controller",
            "    def ssl_configured?",
            "      Rails.env.production?",
            "    end",
            "",
            ""
          ].join("\n")
        end
      end
      
      protected
      
      def only_list
        [ options.only ].join(", ")
      end
      
      def except_list
        [ options.except ].join(", ")
      end
    end
  end
end
