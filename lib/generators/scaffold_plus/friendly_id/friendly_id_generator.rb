require 'rails/generators/active_record'

module ScaffoldPlus
  module Generators
    class FriendlyIdGenerator < ActiveRecord::Generators::Base
      desc "Add friendly_id to resource"
      argument :name, type: :string,
               desc: 'The object that uses friendly_id'
      argument :attribute, type: :string, default: 'name',
               desc: 'The model attribute to be slugged'
      class_option :before, type: :boolean, default: false,
               desc: 'Add a line before generated text in model'
      class_option :after, type: :boolean, default: false,
               desc: 'Add a line after generated text in model'
      
      def update_model
        inject_into_class "app/models/#{name}.rb", class_name do
          text = options.before? ? "\n" : ""
          text << "  extend FriendlyId\n"
          text << "  friendly_id :#{options.attribute}, use: :slugged\n"
          text << "\n" if options.after?
          text
        end
      end
    end
  end
end
