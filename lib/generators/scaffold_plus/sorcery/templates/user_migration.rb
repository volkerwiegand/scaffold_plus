class <%= migration_name.camelize %> < ActiveRecord::Migration
  def change
    create_table :<%= table_name %> do |t|
      t.string   :email, null: false
      t.string   :name
      t.string   :phone
      t.text     :comment
      t.string   :theme
      t.boolean  :active, default: true
      t.boolean  :sysadm, default: false

      t.string   :crypted_password, null: false
      t.string   :salt, null: false
<%- if options.user_activation? -%>
      t.string   :activation_state, default: nil
      t.string   :activation_token, default: nil
      t.datetime :activation_token_expires_at, default: nil
<%- end -%>
<%- if options.reset_password? -%>
      t.string   :reset_password_token, default: nil
      t.datetime :reset_password_token_expires_at, default: nil
      t.datetime :reset_password_email_sent_at, default: nil
<%- end -%>
<%- if options.remember_me? -%>
      t.boolean  :remember_me
      t.string   :remember_me_token, default: nil
      t.datetime :remember_me_token_expires_at, default: nil
<%- end -%>
<%- if options.brute_force_protection? -%>
      t.integer  :failed_logins_count, default: 0
      t.datetime :lock_expires_at, default: nil
      t.string   :unlock_token, default: nil
<%- end -%>
<%- if options.activity_logging? -%>
      t.datetime :last_login_at, default: nil
      t.datetime :last_logout_at, default: nil
      t.datetime :last_activity_at, default: nil
      t.string   :last_login_from_ip_address, default: nil
<%- end -%>

      t.timestamps
    end

    add_index :<%= table_name %>, :email, unique: true
    add_index :<%= table_name %>, :sysadm
<%- if options.user_activation? -%>
    add_index :<%= table_name %>, :activation_token
<%- end -%>
<%- if options.reset_password? -%>
    add_index :<%= table_name %>, :reset_password_token
<%- end -%>
<%- if options.remember_me? -%>
    add_index :<%= table_name %>, :remember_me_token
<%- end -%>
<%- if options.brute_force_protection? -%>
    add_index :<%= table_name %>, :unlock_token
<%- end -%>
<%- if options.activity_logging? -%>
    add_index :<%= table_name %>, [:last_logout_at, :last_activity_at]
<%- end -%>
  end
end
