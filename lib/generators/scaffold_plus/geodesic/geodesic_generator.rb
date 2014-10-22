require 'rails/generators/active_record'

module ScaffoldPlus
  module Generators
    class GeodesicGenerator < ActiveRecord::Generators::Base
      desc "Prepare resource for geo functions with geodesic_wgs84 gem"
      argument :name, type: :string,
               desc: "The object to be prepared"
      class_option :latitude, type: :string, default: "lat",
               desc: 'Attribute used for storing latitude'
      class_option :longitude, type: :string, default: "lng",
               desc: 'Attribute used for storing longitude'
      class_option :before, type: :boolean, default: false,
               desc: 'Add a line before generated text in model'
      class_option :after, type: :boolean, default: false,
               desc: 'Add a line after generated text in model'

      def update_model
        file = "app/models/#{name}.rb"
        prepend_to_file file, "require 'geodesic_wgs84'\n\n"
        lines = options.before? ? [ "\n" ] : []
        lines << [
          "  def to_ary",
          "    [#{options.latitude}, #{options.longitude}]",
          "  end",
          ""
        ]
        lines << "\n" if options.after?
        inject_into_class file, class_name, lines.join("\n")
      end
    end
  end
end
