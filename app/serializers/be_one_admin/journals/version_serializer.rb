module BeOneAdmin
  module Journals
    module VersionSerializer
      class List < Serializer

        self.sorting = {
          item_type: :item_type,
          item_id: :item_id,
          whodunnit: :whodunnit,
          event: :event
        }

        hidden :id
        attributes :created_at, :item_type, :item_id, :whodunnit, :event

        def created_at
          object.created_at.strftime("%Y-%m-%d %H:%M:%S UTC")
        end
      end
      class Item < Serializer
        attributes :id, :object, :created_at, :event, :item_type, :item_id, :object_changes, :user_agent, :ip
      end
    end
  end

end
