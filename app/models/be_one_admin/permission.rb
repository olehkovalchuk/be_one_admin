module BeOneAdmin
  class Permission < ApplicationRecord
    has_and_belongs_to_many :roles, association_foreign_key: :role_id, foreign_key: :permission_id
    has_and_belongs_to_many :users, association_foreign_key: :user_id, foreign_key: :permission_id
    has_many :role_users, through: :roles, source: :users
    multilang :title
  end
end
