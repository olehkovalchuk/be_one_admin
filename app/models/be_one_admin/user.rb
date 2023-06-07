module BeOneAdmin
  class User < ApplicationRecord
    @use_resource_scoping = true

    has_paper_trail


    options = {
      # default_url: 'https://upload.wikimedia.org/wikipedia/commons/1/1e/Default-avatar.jpg',
      # processors: [:thumbnail, :compression],
      # styles: {list: "100x100>", thumb: "170x170>" },
      # storage: :filesystem,
      # path: ':rails_root/public/system/img/admins/:id/:style.:extension',
      # url: "#{Rails.application.secrets[:app_protocol]}://#{Rails.application.secrets[:app_host]}/system/img/admins/:id/:style.:extension",
    }

    has_one_attached :avatar, options
    has_secure_password
    signinable restrictions: [:ip, :user_agent]

    has_many :notifications
    has_many :confirmations, foreign_key: :user_id
    has_many :received_notifications, through: :confirmations, foreign_key: :notification_id
    has_many :unread_confirmations, -> { unread }, class_name: "BeOneAdmin::Confirmation", foreign_key: :user_id
    has_many :unread_notifications, through: :unread_confirmations, source: :notification


    has_and_belongs_to_many :individual_permissions, association_foreign_key: :permission_id, foreign_key: :user_id, join_table: :admin_permissions_users, class_name: "BeOneAdmin::Permission"
    has_and_belongs_to_many :roles
    has_many :role_permissions, through: :roles, source: :permissions

    belongs_to :accessable, polymorphic: true, optional: true
  end
end

    
    
