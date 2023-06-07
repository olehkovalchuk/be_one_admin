module BeOneAdmin
  module RoleValidation

    class Base
      include Validation::Base
      crudify with: [:habtm, :habtm_update] do
        multilang_attribute :title
        multilang_attribute :description

        validate :title_multilang_presence
        validate :description_multilang_presence
      end
    end

  end
end