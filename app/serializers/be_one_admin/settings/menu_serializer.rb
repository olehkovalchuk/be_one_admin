module BeOneAdmin
  module Settings
    module MenuSerializer
      class Item < Serializer
        attributes :id, :icon
        translated :title
      end
    end
  end
end

