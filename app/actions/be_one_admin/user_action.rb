module BeOneAdmin
  module UserAction
    extend self

    extend self

    def after_create( admin, form )
      update_user_permissions( admin )
      ::BeOneAdmin::UserMailer.registration(admin, form.password).send(Rails.env.development? ? :deliver_now : :deliver_later )
    end

    def after_update( admin, form )
      update_user_permissions( admin )
    end

    def update_user_permissions(users)
      [users].flatten.each do |user|
        user.update(permissions: merge_permissions(user))
      end
    end

    def merge_permissions(user)
      return {} if user.individual_permissions.empty? && user.role_permissions.empty?

      do_merge(user.individual_permissions, do_merge(user.role_permissions))
    end

    private

    def do_merge(permissions_list, permissions = {})
      permissions_list.each do |p|
        permissions[p.controller] = (permissions.fetch(p.controller, []) + (p.allowed ? p.actions : p.actions.map{ |a| "!#{a}" })).uniq
      end
      permissions.keys.each do |k|
        permissions[k].reject!{ |a| permissions[k].include?("!#{a}") }
        permissions[k].reject!{ |a| a[0] == '!' }
      end
      permissions
    end


  end
end
