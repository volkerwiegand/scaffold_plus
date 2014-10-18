require 'rails/generators/active_record'

module ScaffoldPlus
  module Generators
    class GeocoderGenerator < ActiveRecord::Generators::Base
      desc "Add GeoLocation to resource (requires geocoder gem)"
      argument :name, type: :string,
               desc: "The object to be geocoded"
      class_option :address, type: :string, default: "address",
               desc: 'Attribute used for geocoding'
      class_option :latitude, type: :string, default: "lat",
               desc: 'Attribute used for storing latitude'
      class_option :longitude, type: :string, default: "lng",
               desc: 'Attribute used for storing longitude'
      class_option :country, type: :boolean, default: false,
               desc: 'Isolate country into separate attribute'
      class_option :before, type: :boolean, default: false,
               desc: 'Add a line before generated text in model'
      class_option :after, type: :boolean, default: false,
               desc: 'Add a line after generated text in model'
      source_root File.expand_path('../templates', __FILE__)

      def update_model
        geocoded = "  geocoded_by :#{options.address}"
        geocoded << ", latitude: :#{options.latitude}"
        geocoded << ", longitude: :#{options.longitude}"
        if options.country?
          geocoded << " do |obj,results|"
          country = [
            "    if geo = results.first",
            "      # puts JSON.pretty_generate(geo.as_json)",
            "      if geo.country_code.upcase == 'DE'",
            "        obj.country = 'DE'",
            "        obj.address = geo.address.gsub(/, Deutschland/, '')",
            "        obj.#{options.latitude} = geo.latitude",
            "        obj.#{options.longitude} = geo.longitude",
            "      end",
            "    end",
            "  end"
          ]
        else
          country = []
        end
        lines = options.before? ? [ "\n" ] : []
        lines << [
          geocoded,
          country,
          "  after_validation :geocode" +
            ", if: ->(obj){ obj.#{options.address}.present?" +
            " and obj.#{options.address}_changed? }",
          ""
        ]
        lines << "\n" if options.after?
        inject_into_class "app/models/#{name}.rb", class_name do
          lines.flatten.join("\n")
        end
      end
    end
  end
end
