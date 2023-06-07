module BeOneAdmin
  class Login
    include Validation::Base
    attribute :email, String
    attribute :password, String
    def to_key
      []
    end
  end
end