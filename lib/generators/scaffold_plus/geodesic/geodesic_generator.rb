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

      def update_model
        lat = options.latitude
        lon = options.longitude
        file = "app/models/#{name}.rb"
        prepend_to_file file, "require 'geodesic_wgs84'\n\n"
        lines = [
          "  def to_ary",
          "    [#{lat}, #{lon}]",
          "  end",
          "",
          "  protected",
          "",
          "  def update_coordinates",
          "    wgs84 = Wgs84.new",
          "    if self.#{lat}.blank? and self.#{lon}.blank?",
          "      if self.#{lat}_dms.present? and self.#{lon}_dms.present?",
          "        self.#{lat}, self.#{lon} = wgs84.lat_lon(self.#{lat}_dms, self.#{lon}_dms)",
          "      end",
          "    end",
          "    if self.#{lat}_dms.blank? and self.#{lon}_dms.blank?",
          "      if self.#{lat}.present? and self.#{lon}.present?",
          "        self.#{lat}_dms, self.#{lon}_dms = wgs84.lat_lon_dms(self.#{lat}, self.#{lon})",
          "      end",
          "    end",
          "    true",
          "  end",
          ""
        ]
        inject_into_class file, class_name, lines.join("\n")
      end
    end
  end
end
