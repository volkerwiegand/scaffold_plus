class <%= class_name %> < ActiveRecord::Base
  authenticates_with_sorcery!
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :password, presence: true, on: :create
  validates :password, length: { minimum: 6 }, unless: Proc.new { |a| a.password.blank? }
  validates :password, confirmation: true
  validates :password_confirmation, presence: true, on: :create
<%- if options.authority? -%>
  include Authority::UserAbilities
<%- end -%>

  default_scope { order(:name) }
  scope :active,  -> { where(active: true) }
  scope :sysadms, -> { where(sysadm: true) }
  
  extend Enumerize
  enumerize :theme, in: BootswatchRails::THEMES
end
