module BeOneAdmin
  module MenuValidation

    class Base
      include Validation::Base
      crudify do
        multilang_attribute :title
        attribute :icon, String

        validate :title_multilang_presence
        validates :icon, presence: true, length: { in: 2..25 }

      end
    end

    class Move
      include Validation::Base
      attribute :up, Boolean
      attribute :id, Integer
      validates :up, inclusion: { in: [true,false] }
      validates :id, presence: true, numericality: { only_integer: true }
    end

  end
end