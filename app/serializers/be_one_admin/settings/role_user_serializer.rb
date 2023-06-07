module BeOneAdmin
  module Settings
    module RoleUserSerializer
      class Relation < Serializer
        attributes :title, :email
        hidden :id
      end
    end
  end
end
