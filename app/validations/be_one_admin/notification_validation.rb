module BeOneAdmin
  module NotificationValidation

    class Base
      include Validation::Base
      crudify do
        multilang_attribute :heading
        multilang_attribute :text

        attribute :role_ids, Array[Integer]
        attribute :user_ids, Array[Integer]
        attribute :send_email, Boolean, default: false
        attribute :send_sms, Boolean, default: false


        validate :heading_multilang_presence
        validate :text_multilang_presence

        validates_presence_of :user_ids, if: -> { self.role_ids.blank? }

        validates_presence_of :role_ids, if: -> { self.user_ids.blank? }

      end
    end

  end
end