module BeOneAdmin
  class Role < ApplicationRecord
    has_and_belongs_to_many :permissions, association_foreign_key: :permission_id, foreign_key: :role_id
    has_and_belongs_to_many :users, association_foreign_key: :user_id, foreign_key: :role_id

    multilang :title
    multilang :description
  end
end