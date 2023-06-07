module BeOneAdmin
  module Settings
    module RoleSerializer
      class List < Serializer
        attributes :title, :description
        hidden :id
      end
      class Item < Serializer
        attributes :id
        translated :title, :description
      end

      class Relation < Serializer
        attributes :title
        hidden :id
      end

    end
  end
end
