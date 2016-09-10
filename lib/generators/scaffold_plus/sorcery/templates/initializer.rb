#
# This initializer was derived from the original Sorcery initializer
#

Rails.application.config.sorcery.submodules = [<%= submodules %>]

Rails.application.config.sorcery.configure do |config|
  # -- core --
  # config.not_authenticated_action = :not_authenticated
  # config.save_return_to_url = true
  # config.cookie_domain = nil
<%- if options.session_timeout? -%>

  # -- session_timeout --
  # config.session_timeout = 3600
  # config.session_timeout_from_last_action = false
<%- end -%>
<%- if options.http_basic_auth? -%>

  # -- http_basic_auth --
  # config.controller_to_realm_map = { "application" => "Application" }
<%- end -%>
<%- if options.activity_logging? -%>

  # -- activity_logging --
  # config.register_login_time = true
  # config.register_logout_time = true
  # config.register_last_activity_time = true
<%- end -%>
<%- if options.external? -%>

  # -- external --
  # config.external_providers = []
  # config.ca_file = 'path/to/ca_file'
<%- end -%>

  # --- user config ---
  config.user_config do |user|
    # -- core --
    # user.username_attribute_names = [:email]
    # user.password_attribute_name = :password
    # user.downcase_username_before_authenticating = false
    # user.email_attribute_name = :email
    # user.crypted_password_attribute_name = :crypted_password
    # user.salt_join_token = ""
    # user.salt_attribute_name = :salt
    # user.stretches = nil
    # user.encryption_key = nil
    # user.custom_encryption_provider = nil
    # user.encryption_algorithm = :bcrypt
    # user.subclasses_inherit_config = false
<%- if options.user_activation? -%>

    # -- user_activation --
    # user.activation_state_attribute_name = :activation_state
    # user.activation_token_attribute_name = :activation_token
    # user.activation_token_expires_at_attribute_name = :activation_token_expires_at
    # user.activation_token_expiration_period = nil
    # user.user_activation_mailer = nil
    # user.activation_mailer_disabled = false
    # user.activation_needed_email_method_name = :activation_needed_email
    # user.activation_success_email_method_name = :activation_success_email
    # user.prevent_non_active_users_to_login = true
<%- end -%>
<%- if options.reset_password? -%>

    # -- reset_password --
    # user.reset_password_token_attribute_name = :reset_password_token
    # user.reset_password_token_expires_at_attribute_name = :reset_password_token_expires_at
    # user.reset_password_email_sent_at_attribute_name = :reset_password_email_sent_at
    user.reset_password_mailer = <%= class_name %>Mailer
    # user.reset_password_email_method_name = :reset_password_email
    # user.reset_password_mailer_disabled = false
    # user.reset_password_expiration_period = nil
    # user.reset_password_time_between_emails = 300
<%- end -%>
<%- if options.remember_me? -%>

    # -- remember_me --
    # user.remember_me_httponly = true
    # user.remember_me_for = 604800
<%- end -%>
<%- if options.brute_force_protection? -%>

    # -- brute_force_protection --
    # user.failed_logins_count_attribute_name = :failed_logins_count
    # user.lock_expires_at_attribute_name = :lock_expires_at
    # user.consecutive_login_retries_amount_limit = 50
    # user.login_lock_time_period = 3600
    # user.unlock_token_attribute_name = :unlock_token
    # user.unlock_token_email_method_name = :send_unlock_token_email
    # user.unlock_token_mailer_disabled = false
    # user.unlock_token_mailer = nil
<%- end -%>
<%- if options.activity_logging? -%>

    # -- activity_logging --
    # user.last_login_at_attribute_name = :last_login_at
    # user.last_logout_at_attribute_name = :last_logout_at
    # user.last_activity_at_attribute_name = :last_activity_at
    # user.activity_timeout = 600
<%- end -%>
<%- if options.external? -%>

    # -- external --
    # user.authentications_class = nil
    # user.authentications_user_id_attribute_name = :user_id
    # user.provider_attribute_name = :provider
    # user.provider_uid_attribute_name = :uid
<%- end -%>
  end

  config.user_class = "<%= class_name %>"
end
