module BeOneAdmin
  module Settings
    module PermissionSerializer
      class List < Serializer
        self.sorting ={
          controller: :controller
        }
        attributes :title, :controller, :actions
        hidden :id
        attribute :allowed, type: :state, sorting: :allowed
      end
      class Item < Serializer
        attributes :id, :controller
        translated :title
        as_tags :actions
      end

      class Relation < BeOneAdmin::Serializer
        attributes :title
        hidden :id
      end

    end
  end
end
