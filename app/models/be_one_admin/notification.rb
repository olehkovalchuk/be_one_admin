module BeOneAdmin
  class Notification < ApplicationRecord
    belongs_to :user, foreign_key: :user_id
    has_many :confirmations, foreign_key: :notification_id
    has_many :users, through: :confirmations
    multilang :text
    multilang :heading
    enum message_type: [:from_user, :bug, :plus, :envelope]
  end
end