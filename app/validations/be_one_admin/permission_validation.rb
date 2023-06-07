module BeOneAdmin
  module PermissionValidation

    class Base
      include Validation::Base
      crudify with: [:habtm, :habtm_update] do
        multilang_attribute :title
        attribute :controller, String
        attribute :allowed, Boolean, default: true
        attribute :actions, Array[String]

        validate :title_multilang_presence
        validates :controller, presence: true, inclusion: { in: BeOneAdmin.modules.keys }
        validates :actions, presence: true
      end
    end

  end
end