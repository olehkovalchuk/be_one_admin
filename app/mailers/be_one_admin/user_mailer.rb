module BeOneAdmin
  class UserMailer < BeOneAdmin::ApplicationMailer

    def change_password( user, password )
      safe_action 'change_password' do |template|
        _placeholders( user ).merge(
          password: password
        ).each_pair{ |k,v| template.text = template.text.gsub!("%#{k.to_s.upcase}%",v.to_s) }
        user.email
      end
    end

    def remind_password( user )
      safe_action 'remind_password' do |template|
        _placeholders( user ).each_pair{ |k,v| template.text = template.text.gsub!("%#{k.to_s.upcase}%",v.to_s) }
        user.email
      end
    end

    def registration( user, password )
      safe_action 'admin_create' do |template|
        _placeholders( user ).merge(
          password: password
        ).each_pair{ |k,v| template.text = template.text.gsub!("%#{k.to_s.upcase}%",v.to_s) }
        user.email
      end
    end


    def notify( subject, text, user )
      safe_action 'admin_notification' do |template|
        _placeholders( user ).merge(
          text: text
        ).each_pair{ |k,v| template.text = template.text.gsub!("%#{k.to_s.upcase}%",v.to_s) }
        template.subject = subject
        user.email
      end
    end

    private

    def _placeholders( user )
      {
        email: user.email,
        username: "#{user.last_name} #{user.first_name}",
        root_url: admin.root_url,
        expire_at: I18n.l( user.reset_password_expire_at, format: :short ),
        link: admin.restore_url(token: user.reset_password_token),
        app_name: I18n.t("#{BeOneAdmin.config.class_name.downcase}.title"),
        copyright: "#{I18n.t("#{BeOneAdmin.config.class_name.downcase}.title")} #{Date.today.year}"
      }
    end

  end
end
