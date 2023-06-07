module BeOneAdmin
  module PermissionOperation
    class Base
      include Operation::Base 
      crudify with: [:habtm, :habtm_update] do
        model_name Permission
      end
    end
  end
end
