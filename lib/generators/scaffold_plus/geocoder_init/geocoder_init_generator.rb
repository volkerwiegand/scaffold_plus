module ScaffoldPlus
  module Generators
    class GeocoderInitGenerator < Rails::Generators::Base
      desc "Generate an initializer for the geocoder gem"
      class_option :language, type: :string, default: "de",
               desc: 'Language of the interface'
      class_option :timeout, type: :string, default: "5",
               desc: 'Lookup timeout in seconds'
      class_option :units, type: :string, default: "km",
               desc: 'Define distance units (miles, km)'
      source_root File.expand_path("../templates", __FILE__)

      def add_initializer
        template "geocoder.rb", "config/initializers/geocoder.rb"
      end
    end
  end
end
