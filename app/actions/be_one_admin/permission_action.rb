module BeOneAdmin
  module PermissionAction
    extend self

    def after_update(model, form)
      UserAction.update_user_permissions(model.users + model.role_users)
    end

    def after_destroy(model)
      UserAction.update_user_permissions(model.users + model.role_users)
    end

  end
end
