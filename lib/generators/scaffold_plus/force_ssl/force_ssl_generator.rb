require 'rails/generators/active_record'

module ScaffoldPlus
  module Generators
    class ForceSslGenerator < ActiveRecord::Generators::Base
      desc "Enforce SSL for this controller in production"
      argument :name, type: :string,
               desc: "The resource that is SSL protected"
      class_option :only_for, type: :array,
               desc: 'Enforce SSL for these actions'
      class_option :except_for, type: :array,
               desc: 'Do not enforce SSL for these actions'
      
      def update_controller
        file = "app/controllers/#{table_name}_controller.rb"
        inject_into_file file, after: /^class.*ApplicationController$/ do
          text = "\n  force_ssl if: :ssl_configured?"
          text << ", only: [ #{only_list} ]" if options.only_for.present?
          text << ", except: [ #{except_list} ]" if options.except_for.present?
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
        options.only_for.map { |o| ":#{o}" }.join(", ")
      end
      
      def except_list
        options.except_for.map { |o| ":#{o}" }.join(", ")
      end
    end
  end
end
