module BeOneAdmin
  module RoleOperation
    class Base
      include Operation::Base 
      crudify with: [:habtm, :habtm_update] do
        model_name Role
      end
    end
  end
end
