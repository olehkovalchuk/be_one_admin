module BeOneAdmin
  module EmailOperation
    class Base
      include Operation::Base
      crudify do
        model_name Email
      end
    end

    class Find < Base
      def perform
        BeOneAdmin::Email.find_by(code: form.code)
      end
    end
  end
end
