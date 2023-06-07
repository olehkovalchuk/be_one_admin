module VersionOperation
  class Base
    include Operation::Base
    crudify only: [:list,:read] do
      model_name Version
    end
  end
end