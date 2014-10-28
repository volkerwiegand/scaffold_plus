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
      class_option :migration, type: :boolean, default: false,
               desc: 'Create a migration for added attributes'
      class_option :address, type: :boolean, default: true,
               desc: 'Add an address field to the migration'
      class_option :permit, type: :boolean, default: false,
               desc: 'Allow mass assignment for added attributes'
      class_option :before, type: :boolean, default: false,
               desc: 'Add a line before generated text in model'
      class_option :after, type: :boolean, default: false,
               desc: 'Add a line after generated text in model'
      source_root File.expand_path('../templates', __FILE__)

      def add_migration
        return unless options.migration?
        migration_template 'geodesic_migration.rb', "db/migrate/#{migration_name}.rb"
      end

      def update_model
        lat = options.latitude
        lng = options.longitude
        file = "app/models/#{name}.rb"
        prepend_to_file file, "require 'geodesic_wgs84'\n\n"
        lines = options.before? ? [ "" ] : []
        lines << [
          "  def to_lat_lon",
          "    [#{lat}.to_f, #{lng}.to_f]",
          "  end",
          "",
          "  def as_dms(value)",
          "    return '' if value.blank?",
          "    wgs84 = Wgs84.new",
          "    wgs84.as_dms(value)",
          "  end",
          "",
          "  before_save on: [:create, :update] do",
          "    # Normalize geo information",
          "    wgs84 = Wgs84.new",
          "    if self.#{lat}.present?",
          "      self.#{lat} = wgs84.as_deg(self.#{lat}.to_f)",
          "    end",
          "    if self.#{lng}.present?",
          "      self.#{lng} = wgs84.as_deg(self.#{lng}.to_f)",
          "    end",
          "  end",
          ""
        ]
        lines << "" if options.after?
        inject_into_class file, class_name, lines.join("\n")
      end

      def update_controller
        return unless options.permit?
        text = ":#{options.latitude}, :#{options.latitude}"
        text << ", :address, :country" if options.address?
        file = "app/controllers/#{table_name}_controller.rb"
        gsub_file file, /(permit\(.*)\)/, "\\1, #{text})"
        # Special case: no previous permit
        gsub_file file, /^(\s*params)\[:#{name}\]$/, "\\1.require(:#{name}).permit(#{text})"
      end

      protected

      def migration_name
        "add_geodesic_to_#{table_name}"
      end
    end
  end
end
