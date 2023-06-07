module BeOneAdmin
  module UserValidation

    class Base
      using StringExt

      include Validation::Base
      crudify except: [:create], with: [:habtm, :habtm_update] do
        attribute :first_name, String
        attribute :last_name, String
        attribute :email, String
        attribute :locale, String, default: I18n.default_locale
        attribute :title, String
        attribute :avatar, ActionDispatch::Http::UploadedFile
        attribute :active, Boolean, default: true
        attribute :blocked, Boolean, default: false
        attribute :manager_id, Integer
        attribute :seller_id, Integer
        attribute :blocked_until, DateTime
        attribute :is_system_owner, Boolean, default: false
        attribute :has_child_resource_scope, Boolean, default: false
        attribute :has_root_resource_scope, Boolean, default: false


        validates :email, presence: true, email: true, uniqueness: true, if: -> { !manager_id }
        validates :first_name, :last_name, :title, presence: true, length: { in: 3..50 }, if: -> { !manager_id }
        validates :locale, inclusion: { in: I18n.available_locales.map(&:to_s) }
        validates :blocked_until, presence: true, if: ->(s){ s.blocked.presence }

        before_validation do |params|
          params.blocked_until = nil unless params.blocked.presence
        end


      end
    end

    class Create < Base
      attribute :password, String

      before_validation do |params|
        if params.email
          params.email.strip!
          params.email.downcase!
        end
        params.password = ::BeOneCore::Password.random unless params.password.present?
      end

      validates :password, presence: true, length: { in: 3..50 }
    end


    class SignIn
      include Validation::Base
      attribute :email, String
      attribute :password, String
      attribute :ip, String
      attribute :user_agent, String
      attribute :referer, String

      validates :email, :password, :ip, presence: true
      validates :email,    length: { in: 6..50 }, format:{with:/\A^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i}
      validates :password, length: { in: 5..20 }
    end

    class SignOut
      include Validation::Base
      attribute :admin, Admin::User
      attribute :token, String
      attribute :ip, String
      attribute :user_agent, String

      validates :admin, :token, :ip, presence: true
    end

    class RestorePassword
      include Validation::Base
      attribute :token, String
      attribute :ip, String
      attribute :user_agent, String
      attribute :referer, String

      validates :token, :ip, presence: true
    end

    class RemindPassword
      include Validation::Base
      attribute :email, String
      attribute :ip, String
      attribute :user_agent, String
      attribute :referer, String

      validates :email, :ip, presence: true
    end

    class Authentificate
      include Validation::Base
      attribute :token, String
      attribute :ip, String
      attribute :user_agent, String

      validates :token, :ip, presence: true
    end

  end
end