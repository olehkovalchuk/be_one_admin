module BeOneAdmin
  module ConfirmationOperation
    class Base
      include Operation::Base
      crudify only: [:list] do
        model_name Confirmation
      end
    end
    class Read < Base
      def perform
        add_error!(:id, "Cant find notification") unless @model = form.current_admin.confirmations.find_by(notification_id: form.id)
        @model.update_attributes( {read: true, reading_date: Time.zone.now} ) unless @model.read
        @model
      end
    end
  end
end
