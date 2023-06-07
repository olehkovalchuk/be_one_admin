# desc "Explaining what the task does"
namespace :be_one_admin do
  desc "Reset permissions"
  task reset: :environment do
    # unless Rails.env.production?
    #  ActiveRecord::Base.logger = Logger.new(STDOUT)
      [ BeOneAdmin::User, BeOneAdmin::Menu, BeOneAdmin::Permission, BeOneAdmin::Role ].each(&:delete_all)
      parent = nil
      BeOneAdmin.modules.keys.each do |_module|
        name = _module.demodulize
        dont_show = []#ConfigFile.fetch("admin_settings", "dont_show_on_menu")
        next if dont_show && dont_show.include?( _module )
        if name == _module
          g = {title: I18n.available_locales.inject({}){|hash,lang| hash[lang] = _module.demodulize; hash }, controller: _module , parent_id: 0 }
          parent = BeOneAdmin::Menu.create!( title: I18n.available_locales.inject({}){|hash,lang| hash[lang] = _module.demodulize; hash }, controller: _module , parent_id: 0 )
        else
          BeOneAdmin::Menu.create!( title: I18n.available_locales.inject({}){|hash,lang| hash[lang] = _module.demodulize; hash }, controller: _module , parent_id: parent.id )
        end

      end

      BeOneAdmin.modules.each_pair do |_module, actions|
        actions = actions.concat(["habtm","hasone","update_habtm","many","export","history"])
        BeOneAdmin::Permission.create!( title: I18n.available_locales.inject({}){|hash,lang| hash[lang] = "#{_module} Manager";hash }, controller: _module, actions: actions, allowed: true  )
      end


      admin_role = BeOneAdmin::Role.create!( title: I18n.available_locales.inject({}){|hash,lang| hash[lang] = "Super Admin";hash }, description: I18n.available_locales.inject({}){|hash,lang| hash[lang] = "Super Admin";hash } )
      admin_role.permissions = BeOneAdmin::Permission.all

      user = BeOneAdmin::User.create!( locale: I18n.default_locale, email: "admin@admin.net", first_name: "John", last_name: "Smith", title: "CEO", password: "admin", has_root_resource_scope: true, has_child_resource_scope:true, path:0 )
      user.roles = Admin::Role.all


      user.save
      BeOneAdmin::UserAction.update_user_permissions user

    # end
  end

  desc "Recreate menu"
  task recreate_menu: :environment do
    BeOneAdmin.menu.each_pair do |parent, childs|
      parent_module = BeOneAdmin::Menu.find_or_initialize_by( controller: parent )
      parent_module.title = I18n.available_locales.inject({}){|hash, l| hash.merge!(l=>parent) } unless parent_module.persisted?
      parent_module.save
      childs.each do |child|
        child_module = BeOneAdmin::Menu.find_or_initialize_by( controller: child )
        child_module.parent_id = parent_module.id
        child_module.title = I18n.available_locales.inject({}){|hash, l| hash.merge!(l=>child) } unless child_module.persisted?
        child_module.save
      end
    end
  end
end
