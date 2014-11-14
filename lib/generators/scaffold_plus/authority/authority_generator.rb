require 'rails/generators/active_record'

module ScaffoldPlus
  module Generators
    class AuthorityGenerator < ActiveRecord::Generators::Base
      desc "Add authorization to resource (requires authority gem)"
      argument :name, type: :string,
               desc: 'The object that will be protected'
      class_option :authorizer, type: :string,
               desc: 'authorizer (full name) instead of <class name>Authorizer'
      class_option :before, type: :boolean, default: false,
               desc: 'Add a line before generated text in model'
      class_option :after, type: :boolean, default: false,
               desc: 'Add a line after generated text in model'
      source_root File.expand_path('../templates', __FILE__)

      def update_model
        inject_into_class "app/models/#{name}.rb", class_name do
          text = options.before? ? "\n" : ""
          text << "  include Authority::Abilities\n"
          if options.authorizer.present?
            text << "  self.authorizer_name = '#{options.authorizer}'\n"
          else
            text << "  self.authorizer_name = '#{class_name}Authorizer'\n"
          end
          text << "\n" if options.after?
          text
        end
      end

      def add_authorizer
        return if options.authorizer.present?
        template "authorizer.rb", "app/authorizers/#{name}_authorizer.rb"
      end
    end
  end
end
