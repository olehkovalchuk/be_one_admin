module BeOneAdmin
  class Menu < ApplicationRecord
    belongs_to :parent, class_name: "BeOneAdmin::Menu", foreign_key: :parent_id, optional: true
    has_many :children, class_name: "BeOneAdmin::Menu", foreign_key: :parent_id

    multilang :title
    is_positionable scope: :parent, start: 1
  end
end

