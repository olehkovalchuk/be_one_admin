module BeOneAdmin
  module ConfirmationValidation

    class Read
      include Validation::Base
      attribute :id, Integer
      attribute :current_admin, BeOneAdmin::User
      validates :current_admin, :id, presence: true
    end


  end
end