class <%= class_name %>Authorizer < ApplicationAuthorizer
  def self.default(able, user)
    # forbid anything that is not explicitly allowed
    false
  end
end
