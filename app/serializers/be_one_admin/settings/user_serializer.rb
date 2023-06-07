module BeOneAdmin
  module Settings
    module UserSerializer
      class List < Serializer
        self.sorting ={
          email: :email,
          signins_count: :signins_count,
          title: :title
        }

        hidden :id 
        as_image :avatar
        attributes :email, :name, :title, :signins_count
        attribute :active, type: :state
        attribute :blocked, type: :state
        def name; "#{self.object.last_name} #{self.object.first_name}" ;end
        def avatar
          object.presenter.foto
        end
      end
      class Item < Serializer
        attributes :id, :email, :last_name, :first_name, :title, :active, :blocked, :blocked_until, :password, :has_child_resource_scope, :has_root_resource_scope, :is_system_owner, :seller_id, :manager_id
        as_image :avatar
        def avatar
          object.presenter.foto
        end

        def manager_id
          object.accessable ? object.accessable.id : 0
        end

        def seller_id
          object.accessable ? object.accessable.seller_id : 0
        end

        def blocked_until
          object.blocked_until.strftime('%d.%m.%Y %H:%M') if object.blocked_until && object.blocked_until >= Time.zone.now
        end
      end

      class UserRoleRelation < BeOneAdmin::Serializer
        attributes :id, :title
      end
      class IndividualPermissionRelation < BeOneAdmin::Serializer
        attributes :id, :title
      end

      class Relation < BeOneAdmin::Serializer
        attributes :title
        hidden :id
        def title; "#{self.object.last_name} #{self.object.first_name}" ;end
      end

    end
  end
end

