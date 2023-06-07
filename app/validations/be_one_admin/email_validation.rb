module BeOneAdmin
  module EmailValidation

    class Base
      include Validation::Base
      crudify do
        multilang_attribute :subject
        multilang_attribute :text
        attribute :code, String
        validates :code, presence: true
        validate :subject_multilang_presence
        validate :text_multilang_presence
      end
    end

    class Find
      include Validation::Base
      attribute :code
      validates :code, presence: true
    end

  end
end