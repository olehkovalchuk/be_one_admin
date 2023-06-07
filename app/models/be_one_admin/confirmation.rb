module BeOneAdmin
  class Confirmation < ApplicationRecord

#    set_primary_keys :user_id, :notification_id

    scope :unread, -> { where read: false }
    belongs_to :notification, foreign_key: :notification_id
    belongs_to :user, foreign_key: :user_id
    delegate :email, to: :user, prefix: true, allow_nil: true

    delegate :heading, to: :notification, prefix: true, allow_nil: true
    delegate :text, to: :notification, prefix: true, allow_nil: true
  end
end

