module BeOneAdmin
  module Settings
    module SettingSerializer
      class List < Serializer
        self.sorting = {
          code: :code
        }
        attributes :code, :value
        hidden :id
      end
      class Item < Serializer
        attributes :id, :code, :value
      end
    end
  end
end
