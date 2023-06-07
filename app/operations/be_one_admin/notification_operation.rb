module BeOneAdmin
  module NotificationOperation
    class Base
      include Operation::Base
      crudify except: [:create] do
        model_name Notification
      end
    end
    class Create < Base
      def perform
        with_transaction do
          @model = self.class.model_klass.new
          attributes = form.attributes.slice(*params.keys.map(&:to_sym))
          role_ids = attributes.delete(:role_ids)
          user_ids = attributes.delete(:user_ids)

          users = BeOneAdmin::Role.includes(:users).where(id: role_ids).all.map(&:users).flatten
          users.concat( ::BeOneAdmin::User.where(id: user_ids).all )

          model.attributes = attributes

          result = @model.save

          BeOneAdmin::Confirmation.import( users.uniq.select(&:active).map{|user| {user_id: user.id, notification_id: @model.id } }  )

          trigger :after_create, @model, form

          result
        end
      end
    end
  end
end
