require 'rails/generators/active_record'

module ScaffoldPlus
  module Generators
    class SorceryGenerator < ActiveRecord::Generators::Base
      desc "Install authentication (with Sorcery) and setup users."
      argument :name, type: :string, default: "user",
               banner: "name of the user model"
      class_option :user_activation, type: :boolean, default: false,
               desc: 'User activation by email with optional success email'
      class_option :reset_password, type: :boolean, default: false,
               desc: 'Reset password with email verification'
      class_option :remember_me, type: :boolean, default: false,
               desc: 'Remember me with configurable expiration'
      class_option :session_timeout, type: :boolean, default: false,
               desc: 'Configurable session timeout'
      class_option :brute_force_protection, type: :boolean, default: false,
               desc: 'Brute force login hammering protection'
      class_option :http_basic_auth, type: :boolean, default: false,
               desc: 'A before filter for requesting authentication with HTTP Basic'
      class_option :activity_logging, type: :boolean, default: false,
               desc: 'Automatic logging of last login, logout and activity'
      class_option :external, type: :boolean, default: false,
               desc: 'OAuth1 and OAuth2 support (Twitter, Facebook, etc.)'
      class_option :layout, type: :string, default: 'centered',
               desc: 'Layout to be used for rendering login.html.erb'
      class_option :authority, type: :boolean, default: false,
               desc: 'Include Authority::UserAbilities in user model'
      source_root File.expand_path("../templates", __FILE__)

      def add_migrations
        migration_template "user_migration.rb", "db/migrate/create_#{table_name}.rb"
      end

      def add_models
        template "user_model.rb", "app/models/#{name}.rb"
      end

      def add_mailer
        return unless options.reset_password?
        template "user_mailer.rb", "app/mailers/#{mailer_name}.rb"
        template "reset_password_email.html.erb", "app/views/#{mailer_name}/reset_password_email.html.erb"
      end

      def add_controllers
        template "users_controller.rb", "app/controllers/#{table_name}_controller.rb"
      end

      def add_views
        views  = %w[edit _form index log_in new show]
        views += %w[password change] if options.reset_password?
        views.each do |view|
          template "#{view}.html.erb", "app/views/#{table_name}/#{view}.html.erb"
        end
      end

      def add_routes
        lines = [
          "resources :#{table_name} do",
          "    collection do",
          "      get   'log_in'",
          "      post  'access'",
          "      get   'log_out'"
        ]
        lines << [
          "      get   'password'",
          "      post  'reset'"
        ] if options.reset_password?
        lines << [
          "    end"
        ]
        lines << [
          "    member do",
          "      get   'change'",
          "      patch 'refresh'",
          "      put   'refresh'",
          "    end"
        ] if options.reset_password?
        lines << [
          "  end",
          "  get '/login'  => '#{table_name}#log_in',  as: :login,  format: false",
          "  get '/logout' => '#{table_name}#log_out', as: :logout, format: false",
          ""
        ]
        route lines.join("\n")
      end

      def add_initializer
        template "initializer.rb", "config/initializers/sorcery.rb"
      end

      def add_locales
        %w[en de].each do |locale|
          template "sorcery.#{locale}.yml", "config/locales/sorcery.#{locale}.yml"
        end
      end

      def update_application_controller
        file = "app/controllers/application_controller.rb"
        inject_into_class file, "ApplicationController", "  before_action :require_login\n\n"
        inject_into_file file, "\n\n  private", after: /protect_from_forgery.*$/
        lines = [
          "",
          "  def not_authenticated",
          "    redirect_to login_path, alert: t('sorcery.required')",
          "  end",
          "",
          "  def current_sysadm?",
          "    logged_in? and current_#{name}.sysadm",
          "  end",
          "  helper_method :current_sysadm?",
          ""
        ]
        inject_into_file file, lines.join("\n"), before: /^end$/
      end

      protected

      def submodules
        modules = []
        modules << ":user_activation"        if options.user_activation?
        modules << ":reset_password"         if options.reset_password?
        modules << ":remember_me"            if options.remember_me?
        modules << ":session_timeout"        if options.session_timeout?
        modules << ":brute_force_protection" if options.brute_force_protection?
        modules << ":http_basic_auth"        if options.http_basic_auth?
        modules << ":activity_logging"       if options.activity_logging?
        modules << ":external"               if options.external?
        modules.join(', ')
      end

      def migration_name
        "create_#{table_name}"
      end

      def mailer_name
        "#{name}_mailer"
      end

      def controller_name
        "#{table_name}_controller"
      end

      def whitelist
        ":email, :name, :phone, :comment, :theme, " +
        ":active, :sysadm, :password, :password_confirmation"
      end
    end
  end
end
