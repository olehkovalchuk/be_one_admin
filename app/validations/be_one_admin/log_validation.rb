module BeOneAdmin
  module LogValidation
    class List
      include Validation::Base
      attribute :date, Date
      attribute :filters, Hash, default: {}
      attribute :sorters, Hash, default: []
    end
    class Read
      include Validation::Base
      attribute :id, String
    end
  end
end