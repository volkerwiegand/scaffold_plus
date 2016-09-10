class <%= mailer_name.camelize %> < ActionMailer::Base
  default from: "from@example.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.<%= name %>_mailer.reset_password_email.subject
  #
  def reset_password_email(<%= name %>)
    @<%= name %> = <%= name %>
    @url = change_<%= name %>_url(<%= name %>.reset_password_token)
    mail to: <%= name %>.email
  end
end
